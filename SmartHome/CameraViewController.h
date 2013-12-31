//
//  CameraViewController.h
//  SmartHome
//
//  Created by hadoop user account on 21/08/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PopViewController.h"
#import "CameraSocket.h"
#import "DirectionButton.h"
#import "DeviceCommandGetCameraServer.h"
#import "CommandFactory.h"
#import "XXEventSubscriber.h"

@interface CameraViewController : PopViewController<DirectionButtonDelegate, CameraMessageDelegate, XXEventSubscriber>

@property (strong, nonatomic) Device *cameraDevice;

@end
