//
//  DeviceCommandGetNotificationsHandler.h
//  SmartHome
//
//  Created by Zhao yang on 9/4/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "DeviceCommandHandler.h"
#import "DeviceCommandUpdateNotifications.h"

@protocol DeviceCommandGetNotificationsHandlerDelegate <NSObject>

- (void)notifyUpdateNotifications;

@end

@interface DeviceCommandGetNotificationsHandler : DeviceCommandHandler

@end
