//
//  CommunicationMessage.m
//  SmartHome
//
//  Created by Zhao yang on 8/19/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "CommunicationMessage.h"
#import "NSString+StringUtils.h"

#define DATA_HEADER_LENGTH   1
#define DATA_LENGTH_LENGTH   4
#define DEVICE_NO_LENGTH     17
#define MD5_LENGTH           16

@implementation CommunicationMessage

- (id)initWithDeviceCommand:(DeviceCommand *)command {
    self = [super init];
    if(self) {
        self.deviceCommand = command;
    }
    return self;
}

- (NSData *)generateData {
    if(self.deviceCommand == nil) return nil;
    
    //append data header
    NSMutableData *message = [NSMutableData data];
    [self addDataHeaderFor:message];
    
    NSData *dataDomain = [JsonUtils createJsonDataFromDictionary:[self.deviceCommand toDictionary]];
    
    //append data length
    NSUInteger totalLength = DATA_HEADER_LENGTH + DATA_LENGTH_LENGTH + DEVICE_NO_LENGTH + dataDomain.length + MD5_LENGTH;
    uint8_t dataLength[4];
    [self int2Bytes:totalLength bytes:dataLength];
    [message appendBytes:dataLength length:4];
    
    //append device number
    [self addDeviceNumberFor:message];
    
    //append message content
    [message appendData:dataDomain];
    
    //append md5
    [self addMD5For:message];
    
    return message;
}

- (void)addDataHeaderFor:(NSMutableData *)message {
    uint8_t header[1];
    header[0] = 127;
    [message appendBytes:header length:1];
}

- (void)int2Bytes:(NSUInteger)number bytes:(uint8_t *)bytes {
    bytes[0] = number & 0xff;
    bytes[1] = number >> 8  & 0xff;
    bytes[2] = number >> 16 & 0xff;
    bytes[3] = number >> 24 & 0xff;
}

- (void)addDeviceNumberFor:(NSMutableData *)message {
    
}

- (void)addMD5For:(NSMutableData *)message {
    NSString *str = [[NSString alloc] initWithData:message encoding:NSUTF8StringEncoding];
    [message appendData:[[NSString md5HexDigest:str] dataUsingEncoding:NSUTF8StringEncoding]];
}

@end
