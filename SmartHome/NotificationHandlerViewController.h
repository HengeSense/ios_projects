//
//  NotificationHandlerViewController.h
//  SmartHome
//
//  Created by hadoop user account on 9/09/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PopViewController.h"
#import "SMNotification.h"
#import "MessageCell.h"
#import <QuartzCore/QuartzCore.h>
@protocol DeleteNotificationDelegate<NSObject>
-(void) didWhenDeleted;
@end
@protocol CFNotificationDelegate <NSObject>
-(void) didAgreeOrRefuse:(NSString *) operation;
@end
@interface NotificationHandlerViewController : PopViewController
-(id) initWithMessage:(SMNotification *) smNotification;
@property (strong,nonatomic) SMNotification *message;
@property (assign,nonatomic) id<DeleteNotificationDelegate> deleteNotificationDelegate;
@property (assign,nonatomic) id<CFNotificationDelegate> cfNotificationDelegate;
@end
