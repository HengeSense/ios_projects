//
//  DeviceCommandEventFilter.m
//  SmartHome
//
//  Created by Zhao yang on 12/13/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "DeviceCommandEventFilter.h"

@implementation DeviceCommandEventFilter

- (BOOL)apply:(XXEvent *)event {
    if(event != nil && [event isKindOfClass:[DeviceCommandEvent class]]) {
        return YES;
    }
    return NO;
}


@end
