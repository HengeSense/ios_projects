//
//  DeviceCommandUpdateDevicesHandler.m
//  SmartHome
//
//  Created by Zhao yang on 9/5/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "DeviceCommandUpdateDevicesHandler.h"
#import "DeviceCommandGetUnitsHandler.h"

@implementation DeviceCommandUpdateDevicesHandler

- (void)handle:(DeviceCommand *)command {
    [super handle:command];
    if([command isKindOfClass:[DeviceCommandUpdateDevices class]]) {
        DeviceCommandUpdateDevices *updateDevicesCommand = (DeviceCommandUpdateDevices *)command;
        [[SMShared current].memory updateUnitDevices:updateDevicesCommand.devicesStatus forUnit:updateDevicesCommand.masterDeviceCode];
        NSArray *subscriptions = [[SMShared current].memory getSubscriptionsFor:[DeviceCommandGetUnitsHandler class]];
        if(subscriptions != nil && subscriptions.count > 0) {
            for(int i=0; i<subscriptions.count; i++) {
                if([[subscriptions objectAtIndex:i] respondsToSelector:@selector(notifyDevicesStatusWasUpdate:)]) {
                    [[subscriptions objectAtIndex:i] performSelectorOnMainThread:@selector(notifyDevicesStatusWasUpdate:) withObject:updateDevicesCommand waitUntilDone:NO];
                }
            }
        }
    }
}

@end
