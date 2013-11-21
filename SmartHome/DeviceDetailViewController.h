//
//  DeviceDetailViewController.h
//  SmartHome
//
//  Created by Zhao yang on 9/6/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavViewController.h"
#import "Device.h"
#import "SMCell.h"

@interface DeviceDetailViewController : NavViewController<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) Device *device;

@end
