//
//  DeviceCommandGetAccountHandler.m
//  SmartHome
//
//  Created by Zhao yang on 9/3/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "DeviceCommandGetAccountHandler.h"
#import "DeviceCommandUpdateAccount.h"


@implementation DeviceCommandGetAccountHandler

- (void)handle:(DeviceCommand *)command {
    [super handle:command];
    
    if(command == nil) {
        //
        return;
    }
    NSLog(@" trigger device command get account");
    
    if([command isKindOfClass:[DeviceCommandUpdateAccount class]]) {
        
        DeviceCommandUpdateAccount *deviceCommand = (DeviceCommandUpdateAccount *)command;
        
        NSLog(@" email %@  screenName %@",
              deviceCommand.email, deviceCommand.screenName);
        
    }
    
}

@end
