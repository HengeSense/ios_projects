//
//  NavViewController.h
//  SmartHome
//
//  Created by hadoop user account on 6/08/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopbarView.h"

@interface NavViewController : UIViewController

@property (strong, nonatomic) TopbarView *topbar;
@property (strong, nonatomic) UIViewController *preViewController;

- (void)generateTopbar;
- (void)backToPreViewController;

@end
