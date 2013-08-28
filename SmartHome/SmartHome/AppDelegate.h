//
//  AppDelegate.h
//  SmartHome
//
//  Created by Zhao yang on 8/5/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalSettings.h"
#import "ExtranetClientSocket.h"
#import "AccountService.h"
#import "RootViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) AccountService *accountService;
@property (strong, nonatomic) GlobalSettings *settings;
@property (strong, nonatomic) RootViewController *rootViewController;

@end
