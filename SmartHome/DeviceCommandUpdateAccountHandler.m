//
//  DeviceCommandUpdateAccountHandler.m
//  SmartHome
//
//  Created by Zhao yang on 9/3/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "DeviceCommandUpdateAccountHandler.h"
#import "DeviceCommandUpdateAccount.h"

@implementation DeviceCommandUpdateAccountHandler

- (void)handle:(DeviceCommand *)command {
    [super handle:command];
    NSArray *arr = [[SMShared current].memory getSubscriptionsFor:[DeviceCommandUpdateAccountHandler class]];
    for(int i=0; i<arr.count; i++) {
        if([[arr objectAtIndex:i] respondsToSelector:@selector(didEndUpdateAccount:)]) {
            [[arr objectAtIndex:i] performSelectorOnMainThread:@selector(didEndUpdateAccount:) withObject:command waitUntilDone:NO];
        }
    }
}

@end
