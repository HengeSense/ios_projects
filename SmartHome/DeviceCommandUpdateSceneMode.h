//
//  DeviceCommandUpdateSceneMode.h
//  SmartHome
//
//  Created by Zhao yang on 9/6/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "DeviceCommand.h"
#import "SceneMode.h"

@interface DeviceCommandUpdateSceneMode : DeviceCommand

@property (strong, nonatomic) NSMutableArray *scenesMode;

@end
