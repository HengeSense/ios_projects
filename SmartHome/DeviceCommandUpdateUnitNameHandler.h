//
//  DeviceCommandUpdateUnitNameHandler.h
//  SmartHome
//
//  Created by Zhao yang on 9/13/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "DeviceCommandHandler.h"

@protocol DeviceCommandUpdateUnitNameHandlerDelegate<NSObject>

- (void)updateUnitNameOnCompleted:(DeviceCommand *)command;

@end

@interface DeviceCommandUpdateUnitNameHandler : DeviceCommandHandler

@end
