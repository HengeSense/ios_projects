//
//  SceneEditViewController.h
//  SmartHome
//
//  Created by Zhao yang on 12/2/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PopViewController.h"
#import "PortalView.h"
#import "ScenePlan.h"

@interface SceneEditViewController : PopViewController<UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate>

@property (strong, nonatomic) ScenePlan *scenePlan;

@end
