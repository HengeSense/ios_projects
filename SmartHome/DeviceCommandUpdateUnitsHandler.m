//
//  DeviceCommandUpdateUnitsHandler.m
//  SmartHome
//
//  Created by hadoop user account on 30/08/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "DeviceCommandUpdateUnitsHandler.h"
#import "CommandFactory.h"
#import "Unit.h"

@implementation DeviceCommandUpdateUnitsHandler

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
            getSceneListCommand.masterDeviceCode = unit.identifier;
            if(unit.scenesModeList != nil && unit.scenesModeList.count > 0) {
                getSceneListCommand.updateTime = unit.sceneUpdateTime;
            }
            [[SMShared current].deliveryService executeDeviceCommand:getSceneListCommand];
        }
    }
}

@end
