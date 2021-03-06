//
//  UnitSelectionDrawerView.h
//  SmartHome
//
//  Created by Zhao yang on 12/2/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"
#import "DeviceCommandGetUnitsHandler.h"

@interface UnitSelectionDrawerView : UIView<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) MainViewController *ownerController;

- (id)initWithFrame:(CGRect)frame owner:(MainViewController *)owner;

- (void)refresh;

@end
