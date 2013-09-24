//
//  CameraSocket.m
//  SmartHome
//
//  Created by Zhao yang on 9/23/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "CameraSocket.h"
#import "NSString+StringUtils.h"
#import "BitUtils.h"

#define MAX_RETRY_COUNT 20
#define BUFFER_SIZE 4096

@implementation CameraSocket {
    NSString *connectionString;
    NSUInteger hasRetryCount;
    NSMutableData *currentImageData;
    NSUInteger currentImageLength;
    NSTimeInterval lastSendTime;
    BOOL needToShakeHands;
    BOOL shakeHandsSuccess;
    BOOL inOpen;
    BOOL outOpen;
}

@synthesize delegate;

- (id)initWithIPAddress:(NSString *)ip andPort:(NSInteger)portNumber {
    self = [super initWithIPAddress:ip andPort:portNumber];
    if(self) {
        hasRetryCount = 0;
        shakeHandsSuccess = NO;
        needToShakeHands = YES;
        inOpen = NO;
        outOpen = NO;
        currentImageLength = -1;
        currentImageData = [NSMutableData data];
    }
    return self;
}

@synthesize key = _key_;

#pragma mark -
#pragma mark socket

- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode {
    if(eventCode == NSStreamEventHasBytesAvailable) {
        if(aStream != nil && aStream == self.inputStream) {
            if(!shakeHandsSuccess) {
                uint8_t header[1];
                int bytesRead = [self.inputStream read:header maxLength:1];
                if(bytesRead == -1) {
                    //unkonw, maybe server client was closed... don't need to process
                    return;
                }
                // shake hands success
                if(header[0] == 1) {
                    shakeHandsSuccess = YES;
                } else {
                    [NSThread sleepForTimeInterval:1];
                    needToShakeHands = YES;
                    [self tryShakeHands];
                }
            } else {
                int bytesRead = 0;
                if(currentImageLength == -1) {
                    uint8_t dataLength[5-currentImageData.length];
                    bytesRead = [self.inputStream read:dataLength maxLength:5-currentImageData.length];
                    if(bytesRead != -1) {
                        [currentImageData appendBytes:dataLength length:bytesRead];
                    }
                    if(currentImageData.length == 5) {
                        uint8_t bytes[5];
                        [currentImageData getBytes:bytes length:5];
                        if(bytes[0] != 1) {
                            NSLog(@"camera socket header match error!");
                            [self close];
                            return;
                        }
                        currentImageLength = [BitUtils bytes2Int:bytes range:NSMakeRange(1, 4)];
                    }
                } else {
                    uint8_t dataDomain[BUFFER_SIZE];
                    NSUInteger remainBytes = currentImageLength - currentImageData.length;
                    bytesRead = [self.inputStream read:dataDomain maxLength:remainBytes >= BUFFER_SIZE ? BUFFER_SIZE : remainBytes];
                    if(bytesRead != -1) {
                        [currentImageData appendBytes:dataDomain length:bytesRead];
                    }
                    if(currentImageData.length == currentImageLength) {
                        [self performSelectorOnMainThread:@selector(notifyImageWasReady:) withObject:currentImageData waitUntilDone:YES];
                        currentImageLength = -1;
                        currentImageData = [NSMutableData data];
                    }
                }
            }
        }
    } else if(eventCode == NSStreamEventHasSpaceAvailable) {
        [self tryShakeHands];
    } else if(eventCode == NSStreamEventOpenCompleted) {
        if(aStream == self.inputStream) {
            inOpen = YES;
        }
        if(aStream == self.outputStream) {
            outOpen = YES;
        }
        if(inOpen && outOpen) {
            [self performSelectorOnMainThread:@selector(notifyConnectionOpen) withObject:nil waitUntilDone:NO];
        }
    } else if(eventCode == NSStreamEventEndEncountered) {
        [self close];
    } else if(eventCode == NSStreamEventErrorOccurred) {
        [self close];
    } else if(eventCode == NSStreamEventNone) {
        //no event
    } else {
        //unknow event code , ignore this
    }
}

- (void)tryShakeHands {
    @synchronized(self) {
        if(shakeHandsSuccess) return;
        if(needToShakeHands) {
            needToShakeHands = NO;
            if([NSString isBlank:connectionString]) {
                [self close];
                return;
            }
            
            if(hasRetryCount >= MAX_RETRY_COUNT) {
                hasRetryCount = 0;
                [self close];
                return;
            }
            
            NSData *data = [connectionString dataUsingEncoding:NSUTF8StringEncoding];
            [self.outputStream write:data.bytes maxLength:data.length];
            hasRetryCount++;
        }
    }
}

- (void)connect {
    if([self isConnectted]) return;
    [super connect];
}

- (void)close {
    [super close];
    inOpen = NO;
    outOpen = NO;
    shakeHandsSuccess = NO;
    needToShakeHands = YES;
    currentImageLength = -1;
    currentImageData = [NSMutableData data];
    [self performSelectorOnMainThread:@selector(notifyConnectionClosed) withObject:nil waitUntilDone:NO];
}

- (BOOL)isConnectted {
    return inOpen && outOpen;
}

#pragma mark -
#pragma mark delegate

- (void)notifyImageWasReady:(NSData *)data {
    if(self.delegate != nil && [self.delegate respondsToSelector:@selector(notifyNewImageWasReceived:)]) {
        UIImage *image = [UIImage imageWithData:[data subdataWithRange:NSMakeRange(5, data.length - 5 - 1)]];
        [self.delegate notifyNewImageWasReceived:image];
    }
}

- (void)notifyConnectionOpen {
     if(self.delegate != nil && [self.delegate respondsToSelector:@selector(notifyCameraConnectted)]) {
         [self.delegate notifyCameraConnectted];
     }
}

- (void)notifyConnectionClosed {
    if(self.delegate != nil && [self.delegate respondsToSelector:@selector(notifyCameraWasDisconnectted)]) {
        [self.delegate notifyCameraWasDisconnectted];
    }
}

#pragma mark -
#pragma mark getter and setters

- (void)setKey:(NSString *)key {
    _key_ = key;
    if(_key_ != nil) {
        connectionString = [NSString stringWithFormat:@"%@sj", _key_];
    }
}

@end
