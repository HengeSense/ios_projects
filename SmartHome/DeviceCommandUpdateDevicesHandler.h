//
//  DeviceCommandUpdateDevicesHandler.h
//  SmartHome
//
//  Created by Zhao yang on 9/5/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "DeviceCommandHandler.h"

@protocol DevicecommandUpdateDevicesDelegate <NSObject>

- (void)notifyDevicesStatusWasUpdate;

@end

@interface DeviceCommandUpdateDevicesHandler : DeviceCommandHandler

@end
