//
//  DeviceCommandDeliveryService.m
//  SmartHome
//
//  Created by Zhao yang on 8/29/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "DeviceCommandDeliveryService.h"

@implementation DeviceCommandDeliveryService

@synthesize tcpService;
@synthesize restfulService;

/*
 *
 *
 *
 *
 */
- (void)executeDeviceCommand:(DeviceCommand *)command {
   
    
    [self.tcpService executeDeviceCommand:command];
    
    
}


/*
 *
 *
 *
 *
 */
- (void)handleDeviceCommand:(DeviceCommand *)command {
    
}

#pragma mark -
#pragma mark getter and setters

- (TCPCommandService *)tcpService {
    if(tcpService == nil) {
        tcpService = [[TCPCommandService alloc] init];
    }
    return tcpService;
}

- (RestfulCommandService *)restfulService {
    return nil;
}

@end