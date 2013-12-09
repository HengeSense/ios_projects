//
//  NotificationsViewController.h
//  SmartHome
//
//  Created by Zhao yang on 8/14/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavViewController.h"
#import "Message.h"
#import "MessageCell.h"
#import "NotificationDetailsViewController.h"
#import "MainView.h"
#import "SMNotification.h"

@interface NotificationsViewController : NavViewController<UITableViewDataSource, UITableViewDelegate, SMNotificationDelegate>

@end
