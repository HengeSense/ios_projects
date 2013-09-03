//
//  DeviceCommandGetAccountHandler.m
//  SmartHome
//
//  Created by Zhao yang on 9/3/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "DeviceCommandGetAccountHandler.h"


@implementation DeviceCommandGetAccountHandler

- (void)handle:(DeviceCommand *)command {
    [super handle:command];
    
    if(command == nil) {
        //
        return;
    }
    
    NSLog(@" trigger device command get account");
}

@end
