//
//  DevicesViewController.h
//  SmartHome
//
//  Created by hadoop user account on 13/08/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavViewController.h"

@interface DevicesViewController :NavViewController<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSString *unitIdentifier;

@end
