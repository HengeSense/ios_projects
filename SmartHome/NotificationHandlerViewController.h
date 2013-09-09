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

@interface NotificationHandlerViewController : PopViewController
-(id) initWithMessage:(SMNotification *) smNotification;

@property (strong,nonatomic) SMNotification *message;
@end
