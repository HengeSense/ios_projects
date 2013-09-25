//
//  CommandFactory.h
//  SmartHome
//
//  Created by Zhao yang on 9/3/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DeviceCommand.h"
#import "DeviceCommandUpdateAccount.h"
#import "DeviceCommandUpdateUnits.h"
#import "DeviceCommandUpdateNotifications.h"
#import "DeviceCommandUpdateSceneMode.h"
#import "DeviceCommandVoiceControl.h"
#import "DeviceCommandUpdateDevices.h"
#import "DeviceCommandUpdateUnitName.h"
#import "DeviceCommandUpdateDevice.h"
#import "DeviceCommandGetCameraServer.h"
#import "DeviceCommandReceivedCameraServer.h"
#import "DeviceCommandGetUnit.h"

typedef NS_ENUM(NSUInteger, CommandType) {
    CommandTypeNone,
    CommandTypeUpdateAccount,
    CommandTypeGetAccount,
    CommandTypeGetUnits,
    CommandTypeGetNotifications,
    CommandTypeGetSceneList,
    CommandTypeUpdateDeviceViaVoice,
    CommandTypeUpdateDevice,
    CommandTypeUpdateUnitName,
    CommandTypeGetCameraServer,
};

@interface CommandFactory : NSObject

+ (DeviceCommand *)commandForType:(CommandType)type;
+ (DeviceCommand *)commandFromJson:(NSDictionary *)json;

@end
