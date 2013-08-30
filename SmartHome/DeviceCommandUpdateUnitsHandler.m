//
//  DeviceCommandUpdateUnitsHandler.m
//  SmartHome
//
//  Created by hadoop user account on 30/08/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "DeviceCommandUpdateUnitsHandler.h"
#import "Unit.h"
#define DELEFGATE_METHOD @selector(updateUnits:)
@implementation DeviceCommandUpdateUnitsHandler
@synthesize delegate;

- (void)handle:(DeviceCommand *)command {
    if(![command isMemberOfClass:[DeviceCommandUpdateUnits class]]) return;
    DeviceCommandUpdateUnits *updateUnitsCommand = (DeviceCommandUpdateUnits *)command;
    // do service here
    Memory *memory = [SMShared current].memory;
    NSArray *newUnits = [memory replaceWithUnits:updateUnitsCommand.units];
    NSArray *users = [memory getSubscriptionsFor:[DeviceCommandUpdateUnitsHandler class]];
    [users enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([self.delegate isEqual:obj]&&[obj respondsToSelector:DELEFGATE_METHOD]) {
            [obj performSelector:DELEFGATE_METHOD withObject:newUnits];
        }
    }];
    
    
    
}
- (void) registerUsersForUnitsUpdate:(id)user{
    Memory *memory = [SMShared current].memory;
    [memory subscribeHandler:[DeviceCommandUpdateUnitsHandler class] for:user];
}

@end
