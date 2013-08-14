//
//  BaseViewController.h
//  SmartHome
//
//  Created by Zhao yang on 8/9/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

- (void)resignFirstResponderFor:(UIView *)view;
- (void)registerTapGestureToResignKeyboard;

- (void)initDefaults;
- (void)initUI;

@end
