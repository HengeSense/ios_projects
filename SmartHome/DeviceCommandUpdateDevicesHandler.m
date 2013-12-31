//
//  DeviceCommandUpdateDevicesHandler.m
//  SmartHome
//
//  Created by Zhao yang on 9/5/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "DeviceCommandUpdateDevicesHandler.h"
#import "DeviceCommandGetUnitsHandler.h"
#import "DeviceStatusChangedEvent.h"
#import "XXEventSubscriptionPublisher.h"

@implementation DeviceCommandUpdateDevicesHandler

- (void)handle:(DeviceCommand *)command {
    [super handle:command];
    if([command isKindOfClass:[DeviceCommandUpdateDevices class]]) {
        DeviceCommandUpdateDevices *updateDevicesCommand = (DeviceCommandUpdateDevices *)command;
        [[SMShared current].memory updateUnitDevices:updateDevicesCommand.devicesStatus forUnit:updateDevicesCommand.masterDeviceCode];
        
        [[XXEventSubscriptionPublisher defaultPublisher] publishWithEvent:[[DeviceStatusChangedEvent alloc] initWithCommand:updateDevicesCommand]];
    }
}

@end
