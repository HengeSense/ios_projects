//
//  AppDelegate.h
//  SmartHome
//
//  Created by Zhao yang on 8/5/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalSettings.h"
#import "AccountService.h"
#import "DeviceCommandDeliveryService.h"
#import "Memory.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) AccountService *accountService;
@property (strong, nonatomic) GlobalSettings *settings;
@property (strong, nonatomic) UIViewController *rootViewController;
@property (strong, nonatomic) Memory *memory;
@property (strong, nonatomic) DeviceCommandDeliveryService *deviceCommandDeliveryService;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@end
