//
//  NSObject+SMExtension.h
//  SmartHome
//
//  Created by Zhao yang on 8/28/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "GlobalSettings.h"
#import "AccountService.h"

@interface NSObject (SMExtension)

@property (strong, nonatomic, readonly) AppDelegate *app;
@property (strong, nonatomic, readonly) GlobalSettings *settings;
@property (strong, nonatomic, readonly) AccountService *accountService;

@end
