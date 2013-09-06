//
//  DeviceCommandUpdateNotificationsHandler.m
//  SmartHome
//
//  Created by Zhao yang on 9/4/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "DeviceCommandUpdateNotificationsHandler.h"

@implementation DeviceCommandUpdateNotificationsHandler

- (void)handle:(DeviceCommand *)command {
    [super handle:command];
    if([command isKindOfClass:[DeviceCommandUpdateNotifications class]]) {
        DeviceCommandUpdateNotifications *receivedNotificationsCommand = (DeviceCommandUpdateNotifications *)command;
        // do service here ...
    }
}

@end
