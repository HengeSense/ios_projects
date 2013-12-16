//
//  NotificationsFileUpdatedEventFilter.m
//  SmartHome
//
//  Created by Zhao yang on 12/12/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "NotificationsFileUpdatedEventFilter.h"

@implementation NotificationsFileUpdatedEventFilter

- (BOOL)apply:(XXEvent *)event {
    if(event != nil && [event isKindOfClass:[NotificationsFileUpdatedEvent class]]) {
        return YES;
    }
    return NO;
}

@end
