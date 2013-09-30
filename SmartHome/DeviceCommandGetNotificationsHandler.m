//
//  DeviceCommandGetNotificationsHandler.m
//  SmartHome
//
//  Created by Zhao yang on 9/4/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "DeviceCommandGetNotificationsHandler.h"
#import "NotificationsFileManager.h"
#import "SystemAudio.h"

@implementation DeviceCommandGetNotificationsHandler

- (void)handle:(DeviceCommand *)command {
    [super handle:command];
    
    if([command isKindOfClass:[DeviceCommandUpdateNotifications class]]) {
        DeviceCommandUpdateNotifications *receivedNotificationsCommand = (DeviceCommandUpdateNotifications *)command;
        [[NotificationsFileManager fileManager] writeToDisk:receivedNotificationsCommand.notifications];
        
        NSArray *subscriptions = [[SMShared current].memory getSubscriptionsFor:[self class]];
        if(subscriptions != nil) {
            for(int i=0; i<subscriptions.count; i++) {
                if([[subscriptions objectAtIndex:i] respondsToSelector:@selector(notifyUpdateNotifications)]) {
                    [[subscriptions objectAtIndex:i] performSelectorOnMainThread:@selector(notifyUpdateNotifications) withObject:nil waitUntilDone:NO];
                }
            }
        }
        
        if([COMMAND_PUSH_NOTIFICATIONS isEqualToString:receivedNotificationsCommand.commandName]) {
            if([SMShared current].settings.isVoice) {
                [SystemAudio playClassicSmsSound];
            }
            if([SMShared current].settings.isShake) {
                [SystemAudio shake];
            }
        }
    }
}

@end
