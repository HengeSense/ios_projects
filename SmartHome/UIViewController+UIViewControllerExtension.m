//
//  UIViewController+UIViewControllerExtension.m
//  SmartHome
//
//  Created by hadoop user account on 8/08/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "UIViewController+UIViewControllerExtension.h"

@implementation UIViewController (UIViewControllerExtension)

- (SmsService *)smsService {
    return self.app.smsService;
}

- (AppDelegate *)app {
    return [UIApplication sharedApplication].delegate;
}


@end
