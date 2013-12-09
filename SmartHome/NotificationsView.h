//
//  NotificationsView.h
//  SmartHome
//
//  Created by Zhao yang on 12/3/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "NavigationView.h"
#import "Message.h"
#import "MessageCell.h"
#import "DeviceCommandGetNotificationsHandler.h"
#import "NotificationDetailsViewController.h"

@interface NotificationsView : NavigationView<UITableViewDataSource, UITableViewDelegate, DeviceCommandGetNotificationsHandlerDelegate, SMNotificationDelegate>

@end
