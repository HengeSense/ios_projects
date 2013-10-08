//
//  DeviceCommandGetAccountHandler.m
//  SmartHome
//
//  Created by Zhao yang on 9/3/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "DeviceCommandGetAccountHandler.h"
#import "NavigationView.h"
#import "ViewsPool.h"

@implementation DeviceCommandGetAccountHandler

- (void)handle:(DeviceCommand *)command {
    [super handle:command];
    if([command isKindOfClass:[DeviceCommandUpdateAccount class]]) {
        DeviceCommandUpdateAccount *deviceCommand = (DeviceCommandUpdateAccount *)command;

        NavigationView *nav = (NavigationView *)[[ViewsPool sharedPool] viewWithIdentifier:@"mainView"];
        if(nav != nil) {
            DrawerView *drawerView = (DrawerView *)nav.ownerController.leftView;
            if(drawerView != nil) {
                [drawerView setScreenName:deviceCommand.screenName];
            }
        }
        
        NSArray *arr = [[SMShared current].memory getSubscriptionsFor:[DeviceCommandGetAccountHandler class]];
        for(int i=0; i<arr.count; i++) {
            if([[arr objectAtIndex:i] respondsToSelector:@selector(updateAccount:)]) {
                [[arr objectAtIndex:i] performSelectorOnMainThread:@selector(updateAccount:) withObject:deviceCommand waitUntilDone:NO];
            }
        }
    }
}

@end
