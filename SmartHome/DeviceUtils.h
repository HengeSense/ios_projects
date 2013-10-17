//
//  NetworkHandler.h
//  SmartHome
//
//  Created by hadoop user account on 16/10/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AlertView.h"
#import "Device.h"
#import "SMShared.h"

@interface DeviceUtils : NSObject

+ (BOOL)checkDeviceIsAvailable:(Device *)device;

@end
