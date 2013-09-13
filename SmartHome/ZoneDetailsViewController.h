//
//  ZoneDetailsViewController.h
//  SmartHome
//
//  Created by Zhao yang on 9/12/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "NavViewController.h"
#import "Zone.h"
#import "SMCell.h"
@interface ZoneDetailsViewController : NavViewController<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) Zone *zone;

@end
