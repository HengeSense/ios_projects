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

@synthesize result;
@synthesize deviceCode;
@synthesize className;
@synthesize commandTime;
@synthesize masterDeviceCode;
@synthesize appKey;
@synthesize security;
@synthesize tcpAddress;


- (id)initWithDictionary:(NSDictionary *)json {
    self = [super init];
    if(self) {
        if(json != nil) {
            self.deviceCode = [json notNSNullObjectForKey:@"deviceCode"];
            self.className = [json notNSNullObjectForKey:@"_className"];
            self.masterDeviceCode = [json notNSNullObjectForKey:@"masterDeviceCode"];
            self.tcpAddress = [json notNSNullObjectForKey:@"tcp"];
            self.security = [json notNSNullObjectForKey:@"security"];
            self.result = [json notNSNullObjectForKey:@"id"];
            NSNumber *timestamp = [json notNSNullObjectForKey:@"commandTime"];
            if(timestamp != nil) {
                self.commandTime = [NSDate dateWithTimeIntervalSince1970:timestamp.longLongValue];
            }
        }
    }
    return self;
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
    if(![NSString isBlank:self.security]) {
        [json setObject:self.security forKey:@"security"];
    }
    if(self.commandTime != nil) {
        [json setObject:[NSNumber numberWithLongLong:(long long)self.commandTime.timeIntervalSince1970] forKey:@"commandTime"];
    }
    return json;
}

@end
