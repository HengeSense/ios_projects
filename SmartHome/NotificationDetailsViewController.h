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

@protocol DeleteNotificationDelegate<NSObject>

-(void) didWhenDeleted;

@end


@protocol CFNotificationDelegate <NSObject>

-(void) didAgreeOrRefuse:(NSString *) operation;

@end

@protocol SMNotificationDelegate <NSObject>

@end


@interface NotificationDetailsViewController : NavViewController

@property (strong,nonatomic) SMNotification *notification;
@property (assign, nonatomic) id<SMNotificationDelegate> delegate;

@property (assign,nonatomic) id<DeleteNotificationDelegate> deleteNotificationDelegate;
@property (assign,nonatomic) id<CFNotificationDelegate> cfNotificationDelegate;

- (id)initWithNotification:(SMNotification *)notification;

@end
