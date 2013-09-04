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
    
    if(command == nil) {
        //
        return;
    }
    
    if([command isKindOfClass:[DeviceCommandUpdateAccount class]]) {
        DeviceCommandUpdateAccount *deviceCommand = (DeviceCommandUpdateAccount *)command;
        
        
        NSLog(@" trigger device command update account .");
        // do service here ...
    }

}

@end
