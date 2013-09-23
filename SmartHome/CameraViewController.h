//
//  CameraViewController.h
//  SmartHome
//
//  Created by hadoop user account on 21/08/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PopViewController.h"
#import "DeviceCommandGetCameraServerHandler.h"
#import "CameraSocket.h"
#import "DirectionButton.h"
#import "DeviceCommandGetCameraServer.h"
#import "CommandFactory.h"

@interface CameraViewController : PopViewController<DirectionButtonDelegate, DeviceCommandGetCameraServerHandlerDelegate, CameraMessageDelegate>

@property (strong, nonatomic) Device *cameraDevice;

@end
