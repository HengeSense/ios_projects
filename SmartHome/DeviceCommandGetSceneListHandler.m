//
//  DeviceCommandGetSceneListHandler.m
//  SmartHome
//
//  Created by Zhao yang on 9/5/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "DeviceCommandGetSceneListHandler.h"
#import "DeviceCommandUpdateSceneMode.h"

@implementation DeviceCommandGetSceneListHandler

- (void)handle:(DeviceCommand *)command {
    [super handle:command];
    if([command isKindOfClass:[DeviceCommandUpdateSceneMode class]]) {
        DeviceCommandUpdateSceneMode *updateSceneModeCommand = (DeviceCommandUpdateSceneMode *)command;
        [[SMShared current].memory updateSceneList:updateSceneModeCommand.masterDeviceCode sceneList:updateSceneModeCommand.scenesMode updateTime:updateSceneModeCommand.updateTime];
    }
}

@end
