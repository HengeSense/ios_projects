//
//  DeviceCommandUpdateUnitNameHandler.m
//  SmartHome
//
//  Created by Zhao yang on 9/13/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "DeviceCommandUpdateUnitNameHandler.h"

@implementation DeviceCommandUpdateUnitNameHandler

- (void)handle:(DeviceCommand *)command {
    [super handle:command];
    if([command isKindOfClass:[DeviceCommandUpdateUnitName class]]) {
        NSArray *subscriptions = [[SMShared current].memory getSubscriptionsFor:self.class];
        if(subscriptions != nil && subscriptions.count > 0) {
            for(int i=0; i<subscriptions.count; i++) {
                if([[subscriptions objectAtIndex:i] respondsToSelector:@selector(updateUnitNameOnCompleted:)]) {
                    [[subscriptions objectAtIndex:i] performSelectorOnMainThread:@selector(updateUnitNameOnCompleted:) withObject:command waitUntilDone:NO];
                }
            }
        }
    }
}

@end
