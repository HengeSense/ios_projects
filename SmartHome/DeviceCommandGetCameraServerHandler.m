//
//  DeviceCommandGetCameraServerHandler.m
//  SmartHome
//
//  Created by Zhao yang on 9/23/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "DeviceCommandGetCameraServerHandler.h"

@implementation DeviceCommandGetCameraServerHandler

- (void)handle:(DeviceCommand *)command {
    [super handle:command];
    if([command isKindOfClass:[DeviceCommandReceivedCameraServer class]]) {
        DeviceCommandReceivedCameraServer *cmd = (DeviceCommandReceivedCameraServer *)command;
        NSArray *subscriptions = [[SMShared current].memory getSubscriptionsFor:[self class]];
        if(subscriptions != nil) {
            for(int i=0; i<subscriptions.count; i++) {
                if([[subscriptions objectAtIndex:i] respondsToSelector:@selector(receivedCameraServer:)]) {
                    [[subscriptions objectAtIndex:i] performSelectorOnMainThread:@selector(receivedCameraServer:) withObject:cmd waitUntilDone:NO];
                }
            }
        }
    }
}

@end
