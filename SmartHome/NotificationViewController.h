//
//  NotificationViewController.h
//  SmartHome
//
//  Created by Zhao yang on 8/14/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavViewController.h"
#import "Message.h"
#import "MessageCell.h"
#import "NotificationHandlerViewController.h"
#import "MainView.h"
@interface NotificationViewController : NavViewController<UITableViewDataSource,UITableViewDelegate,DeleteNotificationDelegate,CFNotificationDelegate>
-(id) initFrom:(MainView *) where;
@end
