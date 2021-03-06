//
//  ConversationView.h
//  SmartHome
//
//  Created by Zhao yang on 8/7/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConversationTextMessage.h"

@interface ConversationView : UIView<UITableViewDataSource, UITableViewDelegate>

@property (assign, nonatomic, readonly) NSUInteger messageCount;

- (id)initWithFrame:(CGRect)frame andContainer:(id)cv;

- (void)showWelcomeMessage;
- (void)hideWelcomeMessage;

- (void)addMessage:(ConversationMessage *)message;
- (void)clearMessages;

@end
