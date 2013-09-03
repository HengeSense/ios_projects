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
@synthesize isService;

- (id)init {
    self = [super init];
    if(self) {
        isService = NO;
    }
    return self;
}

/*
 *
 *
 *
 */
- (void)executeDeviceCommand:(DeviceCommand *)command {
   
    // will determine using tcp or rest service to execute device command
    
    [self.tcpService executeDeviceCommand:command];
}

/*
 *
 *
 */
- (void)handleDeviceCommand:(DeviceCommand *)command {
    
}

- (void)startService {
    if(!self.isService) {
        isService = YES;
        if(![self.tcpService isConnect]) {
            [self performSelectorInBackground:@selector(startTcp) withObject:nil];
        }
    }
}

- (void)stopService {
    if(self.isService) {
        [self.tcpService disconnect];
        isService = NO;
    }
}

- (void)startTcp {
    [self.tcpService connect];
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