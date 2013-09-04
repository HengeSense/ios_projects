//
//  MainViewController.h
//  SmartHome
//
//  Created by Zhao yang on 8/5/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrawerViewController.h"
#import "DrawerView.h"

@interface MainViewController : DrawerViewController<DrawerNavigationItemChangedDelegate,AccountInfoDelegate>

@end
