//
//  DeviceCommandGetNotificationHandler.m
//  SmartHome
//
//  Created by Zhao yang on 9/4/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "DeviceCommandGetNotificationHandler.h"

@implementation DeviceCommandGetNotificationHandler

- (void)handle:(DeviceCommand *)command {
    [super handle:command];
    
    if(command == nil) {
        
        return;
    }
    
    if([command isKindOfClass:[DeviceCommandReceivedNotifications class]]) {
        DeviceCommandReceivedNotifications *receivedNotificationsCommand = (DeviceCommandReceivedNotifications *)command;
        
        // do service here ...
    }
}

@end
