//
//  DeviceStatusChangedFilter.m
//  SmartHome
//
//  Created by Zhao yang on 12/12/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "DeviceStatusChangedFilter.h"

@implementation DeviceStatusChangedFilter

- (BOOL)apply:(XXEvent *)event {
    if(event != nil && [event isKindOfClass:[DeviceStatusChangedEvent class]]) {
        return YES;
    }
    return NO;
}

@end
