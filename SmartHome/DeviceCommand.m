//
//  DeviceCommand.m
//  SmartHome
//
//  Created by Zhao yang on 8/19/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "DeviceCommand.h"
#import "NSString+StringUtils.h"

@implementation DeviceCommand

@synthesize deviceCode;
@synthesize className;
@synthesize commandTime;
@synthesize phoneNumber;
@synthesize masterDeviceCode;
@synthesize appKey;
@synthesize security;

- (void)initWithDictionary:(NSDictionary *)json {
    
}

- (NSDictionary *)toDictionary {
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:self.deviceCode forKey:@"deviceCode"];
    [json setObject:self.className forKey:@"_className"];
    [json setObject:self.masterDeviceCode forKey:@"masterDeviceCode"];
    [json setObject:self.appKey forKey:@"appKey"];
    [json setObject:self.phoneNumber forKey:@"phoneNumber"];
    [json setObject:self.security forKey:@"security"];
    [json setObject:[NSNumber numberWithLongLong:(long long)self.commandTime.timeIntervalSince1970] forKey:@"commandTime"];
    return json;
}

@end
