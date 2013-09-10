//
//  DeviceCommandGetNotificationsHandler.m
//  SmartHome
//
//  Created by Zhao yang on 9/4/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "DeviceCommandGetNotificationsHandler.h"
#import "NotificationsFileManager.h"

@implementation DeviceCommandGetNotificationsHandler

- (void)handle:(DeviceCommand *)command {
    [super handle:command];
    if([command isKindOfClass:[DeviceCommandUpdateNotifications class]]) {
        NSLog(@"trigger get notification handler...");
        DeviceCommandUpdateNotifications *receivedNotificationsCommand = (DeviceCommandUpdateNotifications *)command;
        NSArray *notificationSubscripts = [[SMShared current].memory.subscriptions objectForKey:self.class];
        for (int i=0; i<notificationSubscripts.count; ++i) {
            if([[notificationSubscripts objectAtIndex:i] respondsToSelector:@selector(getNotifications)]){
                [[notificationSubscripts objectAtIndex:i] performSelectorOnMainThread:@selector(getNotifications) withObject:receivedNotificationsCommand.notifications waitUntilDone:NO];
            }
        }
        [[NotificationsFileManager fileManager] writeToDisk:receivedNotificationsCommand.notifications];
        
        NSArray *subscriptions = [[SMShared current].memory getSubscriptionsFor:[self class]];
        if(subscriptions != nil) {
            for(int i=0; i<subscriptions.count; i++) {
                if([[subscriptions objectAtIndex:i] respondsToSelector:@selector(notifyUpdateNotifications)]) {
                    [[subscriptions objectAtIndex:i] performSelectorOnMainThread:@selector(notifyUpdateNotifications) withObject:nil waitUntilDone:NO];
                }
            }
        }
    }
}

@end
