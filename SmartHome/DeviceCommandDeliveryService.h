//
//  DeviceCommandDeliveryService.h
//  SmartHome
//
//  Created by Zhao yang on 8/29/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DeviceCommand.h"

@interface DeviceCommandDeliveryService : NSObject

- (void)executeDeviceCommand:(DeviceCommand *)command;
- (void)handleDeviceCommand:(DeviceCommand *)command;

@end
