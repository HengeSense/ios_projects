//
//  UnitDetailsViewController.h
//  SmartHome
//
//  Created by hadoop user account on 13/08/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavViewController.h"
#import "Unit.h"
#import "ModifyInfoViewController.h"
#import "DeviceCommandNameEventFilter.h"
#import "XXEventSubscriptionPublisher.h"
#import "XXEventSubscriber.h"

@interface UnitDetailsViewController : NavViewController<UITableViewDataSource, UITableViewDelegate, TextViewDelegate, XXEventSubscriber>

@property (strong, nonatomic) NSString *unitIdentifier;

@end
