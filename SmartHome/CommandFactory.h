//
//  CommandFactory.h
//  SmartHome
//
//  Created by Zhao yang on 9/3/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DeviceCommand.h"

typedef NS_ENUM(NSUInteger, CommandType) {
    CommandTypeNone,
    CommandTypeUpdateAccount,
    CommandTypeGetAccount,
    CommandTypeUpdateUnits,
    CommandTypeGetNotifications,
};

@interface CommandFactory : NSObject

+ (DeviceCommand *)commandForType:(CommandType)type;
+ (DeviceCommand *)commandFromJson:(NSDictionary *)json;

@end
