//
//  DeviceCommand.m
//  SmartHome
//
//  Created by Zhao yang on 8/19/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "DeviceCommand.h"

@implementation DeviceCommand

@synthesize deviceCode;
@synthesize className;
@synthesize masterDeviceCode;
@synthesize appKey;
@synthesize security;
@synthesize commandTime;

- (void)initWithDictionary:(NSDictionary *)json {
    
}

- (NSDictionary *)toDictionary {
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:@"dsfdsf" forKey:@"deviceCode"];
    [json setObject:@"com.hentre.smarthome.repository.command.ViewZKInfoCommand" forKey:@"_className"];
    [json setObject:@"2424" forKey:@"masterDeviceCode"];
    [json setObject:@"" forKey:@"appKey"];
    [json setObject:@"" forKey:@"security"];
    [json setObject:[NSNumber numberWithLong:self.commandTime] forKey:@"commandTime"];
    return json;
}

@end
