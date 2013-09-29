//
//  AirConditionViewController.h
//  SmartHome
//
//  Created by Zhao yang on 8/5/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PopViewController.h"
#import "UIColor+ExtentionForHexString.h"
#import "Device.h"
@interface AirConditionViewController : PopViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong,nonatomic) Device *device;
-(id) initWithDevice:(Device *) device;
@end
