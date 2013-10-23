//
//  DeviceCommandCheckVersionHandler.m
//  SmartHome
//
//  Created by hadoop user account on 23/10/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "DeviceCommandCheckVersionHandler.h"

@implementation DeviceCommandCheckVersionHandler

- (void)handle:(DeviceCommand *)command {
    [super handle:command];
    if([command isKindOfClass:[DeviceCommandCheckVersion class]]) {
        NSArray *subscriptions = [[SMShared current].memory getSubscriptionsFor:[DeviceCommandCheckVersionHandler class]];
        if(subscriptions != nil && subscriptions.count > 0) {
            for(int i=0; i<subscriptions.count; i++) {
                if([[subscriptions objectAtIndex:i] respondsToSelector:@selector(didCheckVersionComplete:)]) {
                    [[subscriptions objectAtIndex:i] performSelectorOnMainThread:@selector(didCheckVersionComplete:) withObject:command waitUntilDone:NO];
                }
            }
        }
    }
}

@end
