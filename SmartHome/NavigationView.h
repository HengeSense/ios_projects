//
//  NavigationView.h
//  SmartHome
//
//  Created by Zhao yang on 8/6/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"
#import "TopbarView.h"

@interface NavigationView : UIView

@property (strong, nonatomic) MainViewController *ownerController;
@property (strong, nonatomic, readonly) TopbarView *topbar;

- (id)initWithFrame:(CGRect)frame owner:(MainViewController *)controller;

- (void)initDefaults;
- (void)initUI;

@end
