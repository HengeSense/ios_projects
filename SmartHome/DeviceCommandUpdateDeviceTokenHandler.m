//
//  DeviceCommandUpdateDeviceTokenHandler.m
//  SmartHome
//
//  Created by Zhao yang on 10/10/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "DeviceCommandUpdateDeviceTokenHandler.h"

@implementation DeviceCommandUpdateDeviceTokenHandler

- (void)handle:(DeviceCommand *)command {
    [super handle:command];
#ifdef DEBUG
    NSLog(@"[Update Token Handler] Result ID [%d].", command.resultID);
#endif
}

@end
