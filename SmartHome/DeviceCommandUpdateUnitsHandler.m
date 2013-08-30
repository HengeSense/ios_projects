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
    Memory *memory = [SMShared current].memory;
   // NSArray *users = memory getSubscriptionsFor:<#(NSString *)#>
//    __block NSMutableArray *newUnits
//    [SMShared current].memory.units = updateUnitsCommand.units;
    
    
    
}
- (void) registerForUpdate:(id) user{
    Memory *memory = [SMShared current].memory;
}

+ (NSString *)handlerName {
    return @"updateUnitsHandler";
}

@end
