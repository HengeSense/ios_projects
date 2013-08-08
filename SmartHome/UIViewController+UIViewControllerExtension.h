//
//  UIViewController+UIViewControllerExtension.h
//  SmartHome
//
//  Created by hadoop user account on 8/08/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SmsService.h"
#import "AppDelegate.h"

@interface UIViewController (UIViewControllerExtension)

@property(strong, nonatomic, readonly) SmsService *smsService;
@property(strong, nonatomic, readonly) AppDelegate *app;

@end
