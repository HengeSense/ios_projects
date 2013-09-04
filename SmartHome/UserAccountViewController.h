//
//  UserAccountViewController.h
//  SmartHome
//
//  Created by hadoop user account on 2/09/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "NavViewController.h"
#import "SMCell.h"
#import "ModifyInfoViewController.h"
@interface UserAccountViewController : NavViewController<UITableViewDataSource,UITableViewDelegate,TextViewDelegate,UIAlertViewDelegate>
@property (nonatomic,strong) NSMutableDictionary *infoDictionary;
@end
