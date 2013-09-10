//
//  DeviceCommandGetUnitsHandler.h
//  SmartHome
//
//  Created by hadoop user account on 30/08/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "DeviceCommandHandler.h"
#import "DeviceCommandUpdateUnits.h"

@protocol DeviceCommandGetUnitsHandlerDelegate<NSObject>

- (void)notifyUnitsWasUpdate;

@end

@interface DeviceCommandGetUnitsHandler : DeviceCommandHandler

@end
