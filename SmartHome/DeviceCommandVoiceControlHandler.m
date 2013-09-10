//
//  DeviceCommandVoiceControlHandler.m
//  SmartHome
//
//  Created by Zhao yang on 9/5/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "DeviceCommandVoiceControlHandler.h"

@implementation DeviceCommandVoiceControlHandler

- (void)handle:(DeviceCommand *)command {
    [super handle:command];
    if([command isKindOfClass:[DeviceCommandVoiceControl class]]) {
        DeviceCommandVoiceControl *voiceControlCommand = (DeviceCommandVoiceControl *)command;
        NSArray *subscriptions = [[SMShared current].memory getSubscriptionsFor:[self class]];
        if(subscriptions != nil && subscriptions.count > 0) {
            for(int i=0; i<subscriptions.count; i++) {
                if([[subscriptions objectAtIndex:i] respondsToSelector:@selector(notifyVoiceControlAccept:)]) {
                    [[subscriptions objectAtIndex:i] performSelectorOnMainThread:@selector(notifyVoiceControlAccept:) withObject:voiceControlCommand waitUntilDone:NO];
                }
            }
        }
    }
}

@end
