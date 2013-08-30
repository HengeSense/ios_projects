//
//  DeviceCommandUpdateUnitsHandler.m
//  SmartHome
//
//  Created by hadoop user account on 30/08/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "DeviceCommandUpdateUnitsHandler.h"

@implementation DeviceCommandUpdateUnitsHandler

- (void)handle:(DeviceCommand *)command {
    if(![command isMemberOfClass:[DeviceCommandUpdateUnits class]]) return;
    DeviceCommandUpdateUnits *updateUnitsCommand = (DeviceCommandUpdateUnits *)command;
    
    // do service here
}

@end
