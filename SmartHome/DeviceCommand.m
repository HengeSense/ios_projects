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
@synthesize masterDeviceCode;
@synthesize appKey;
@synthesize security;

- (void)initWithDictionary:(NSDictionary *)json {
    
}

- (NSDictionary *)toDictionary {
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:@"iphone4s" forKey:@"deviceCode"];
    [json setObject:@"com.hentre.smarthome.repository.command.ViewZKInfoCommand" forKey:@"_className"];
    [json setObject:@"fieldunit" forKey:@"masterDeviceCode"];
    [json setObject:@"smarthome" forKey:@"appKey"];
    [json setObject:@"123321" forKey:@"security"];
    [json setObject:[NSNumber numberWithLongLong:(long long)self.commandTime.timeIntervalSince1970] forKey:@"commandTime"];
    return json;
}

@end
