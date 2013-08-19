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
    [json setObject:self.deviceCode forKey:@"deviceCode"];
    [json setObject:self.className forKey:@"_className"];
    [json setObject:self.masterDeviceCode forKey:@"masterDeviceCode"];
    [json setObject:self.appKey forKey:@"appKey"];
    [json setObject:self.security forKey:@"security"];
    [json setObject:[NSNumber numberWithLong:self.commandTime] forKey:@"commandTime"];
    return json;
}



@end
