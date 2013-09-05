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


- (void)handle:(DeviceCommand *)command {
    [super handle:command];
    
    NSLog(@" trigger device command update units .");
    
    if(command.resultID != 1) return;
    if(![command isKindOfClass:[DeviceCommandUpdateUnits class]]) return;
    DeviceCommandUpdateUnits *updateUnitsCommand = (DeviceCommandUpdateUnits *)command;

    NSLog(@"units count is %d",     updateUnitsCommand.units.count);
//    Unit *u = [updateUnitsCommand.units objectAtIndex:0];
//    NSLog(@"unit >>> [id=%@, name=%@, status=%@, localPort=%d, localIp=%@, zones.count=%d]",u.identifier, u.name, u.status, u.localPort, u.localIP, u.zones.count);
//    
//    Zone *z = [u.zones objectAtIndex:0];
//    NSLog(@"zone >>> [id=%@, name=%@, devices.count=%d]", z.identifier, z.name, z.devices.count);
//    
//    Device *d = [z.devices objectAtIndex:0];
//    NSLog(@"%@", d.name);
    
    return;
    
    NSArray *newUnits = [[SMShared current].memory updateUnits:updateUnitsCommand.units];

    NSArray *users = [[SMShared current].memory getSubscriptionsFor:[DeviceCommandUpdateUnitsHandler class]];
}

@end
