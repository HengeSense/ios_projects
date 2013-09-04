//
//  DeviceCommandReceivedNotificationHandler.m
//  SmartHome
//
//  Created by Zhao yang on 9/4/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "DeviceCommandReceivedNotificationHandler.h"

@implementation DeviceCommandReceivedNotificationHandler

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
