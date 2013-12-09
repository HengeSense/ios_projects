//
//  NotificationDetailsViewController.h
//  SmartHome
//
//  Created by hadoop user account on 9/09/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavViewController.h"
#import "SMNotification.h"
#import "MessageCell.h"
#import <QuartzCore/QuartzCore.h>


@protocol SMNotificationDelegate <NSObject>

- (void)smNotificationsWasUpdated;

@end


@interface NotificationDetailsViewController : NavViewController

@property (strong,nonatomic) SMNotification *notification;
@property (assign, nonatomic) id<SMNotificationDelegate> delegate;

- (id)initWithNotification:(SMNotification *)notification;

@end
