//
//  DeviceCommandGetCameraServerHandler.h
//  SmartHome
//
//  Created by Zhao yang on 9/23/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "DeviceCommandHandler.h"
#import "DeviceCommandReceivedCameraServer.h"

@protocol DeviceCommandGetCameraServerHandlerDelegate <NSObject>

- (void)receivedCameraServer:(DeviceCommandReceivedCameraServer *)command;

@end

@interface DeviceCommandGetCameraServerHandler : DeviceCommandHandler

@end
