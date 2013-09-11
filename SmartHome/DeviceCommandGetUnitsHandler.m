//
//  DeviceCommandGetUnitsHandler.m
//  SmartHome
//
//  Created by hadoop user account on 30/08/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "DeviceCommandGetUnitsHandler.h"
#import "CommandFactory.h"
#import "Unit.h"

@implementation DeviceCommandGetUnitsHandler

- (void)handle:(DeviceCommand *)command {
    [super handle:command];
    if([command isKindOfClass:[DeviceCommandUpdateUnits class]]) {
        DeviceCommandUpdateUnits *updateUnitsCommand = (DeviceCommandUpdateUnits *)command;
        [[SMShared current].memory updateUnits:updateUnitsCommand.units];
        NSArray *subscriptions = [[SMShared current].memory getSubscriptionsFor:[self class]];
        if(subscriptions) {
            for(int i=0; i<subscriptions.count; i++) {
                if([[subscriptions objectAtIndex:i] respondsToSelector:@selector(notifyUnitsWasUpdate)]) {
                    [[subscriptions objectAtIndex:i] performSelectorOnMainThread:@selector(notifyUnitsWasUpdate) withObject:nil waitUntilDone:NO];
                }
            }
        }
        
        for(Unit *unit in updateUnitsCommand.units) {
            DeviceCommand *getSceneListCommand = [CommandFactory commandForType:CommandTypeGetSceneList];
            
            // set master device code
            getSceneListCommand.masterDeviceCode = unit.identifier;
            
            // set hash code
            getSceneListCommand.hashCode = unit.sceneHashCode;
            
            [[SMShared current].deliveryService executeDeviceCommand:getSceneListCommand];
        }
    }
}

@end
