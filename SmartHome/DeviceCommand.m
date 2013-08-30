//
//  DeviceCommand.m
//  SmartHome
//
//  Created by Zhao yang on 8/19/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "DeviceCommand.h"
#import "NSString+StringUtils.h"
#import "JsonUtils.h"

@implementation DeviceCommand

@synthesize deviceCode;
@synthesize className;
@synthesize commandTime;
@synthesize phoneNumber;
@synthesize masterDeviceCode;
@synthesize appKey;
@synthesize security;


- (void)initWithDictionary:(NSDictionary *)json {
//    NSString *d_code = [json notNSNullObjectForKey:@"deviceCode"];
//NSString *d_code = [json notNSNullObjectForKey:@"deviceCode"];
//NSString *d_code = [json notNSNullObjectForKey:@"deviceCode"];
//    NSString *d_code = [json notNSNullObjectForKey:@"deviceCode"];
    
}

- (NSDictionary *)toDictionary {
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    if(![NSString isBlank:self.deviceCode]) {
        [json setObject:self.deviceCode forKey:@"deviceCode"];
    }
    if(![NSString isBlank:self.className]) {
        [json setObject:self.className forKey:@"_className"];
    }
    if(![NSString isBlank:self.masterDeviceCode]) {
        [json setObject:self.masterDeviceCode forKey:@"masterDeviceCode"];
    }
    if(![NSString isBlank:self.appKey]) {
        [json setObject:self.appKey forKey:@"appKey"];
    }
    if(![NSString isBlank:self.phoneNumber]) {
        [json setObject:self.phoneNumber forKey:@"phoneNumber"];
    }
    if(![NSString isBlank:self.security]) {
        [json setObject:self.security forKey:@"security"];
    }
    if(self.commandTime != nil) {
        [json setObject:[NSNumber numberWithLongLong:(long long)self.commandTime.timeIntervalSince1970] forKey:@"commandTime"];
    }
    return json;
}

- (NSString *)description {
    
    return nil;
}

@end
