//
//  UIViewController+UIViewControllerExtension.m
//  SmartHome
//
//  Created by hadoop user account on 8/08/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "UIViewController+UIViewControllerExtension.h"

@implementation UIViewController (UIViewControllerExtension)

- (GlobalSettings *)settings {
    return self.app.settings;
}

- (AccountService *)accountService {
    return self.app.accountService;
}

- (AppDelegate *)app {
    return [UIApplication sharedApplication].delegate;
}

@end
