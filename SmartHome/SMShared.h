//
//  SMShared.h
//  SmartHome
//
//  Created by Zhao yang on 8/29/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

@interface SMShared : NSObject

@property (strong, nonatomic, readonly) AppDelegate *app;
@property (strong, nonatomic, readonly) Memory *memory;
@property (strong, nonatomic, readonly) GlobalSettings *settings;
@property (strong, nonatomic, readonly) AccountService *accountService;
@property (strong, nonatomic, readonly) DeviceCommandDeliveryService *deliveryService;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
+ (SMShared *)current;

@end
