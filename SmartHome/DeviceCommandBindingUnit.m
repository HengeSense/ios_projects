//
//  DeviceCommandBindingUnit.m
//  SmartHome
//
//  Created by Zhao yang on 9/25/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "DeviceCommandBindingUnit.h"

@implementation DeviceCommandBindingUnit

@synthesize requestDeviceCode;

- (NSMutableDictionary *)toDictionary {
    NSMutableDictionary *json = [super toDictionary];
    if(json != nil) {
        [json setMayBlankString:self.requestDeviceCode forKey:@"requestDeviceCode"];
    }
    return json;
}

@end
