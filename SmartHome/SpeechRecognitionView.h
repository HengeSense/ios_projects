//
//  SpeechRecognitionView.h
//  SmartHome
//
//  Created by Zhao yang on 8/7/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SpeechViewTextMessage.h"

@interface SpeechRecognitionView : UIView<UITableViewDataSource, UITableViewDelegate>

- (id)initWithFrame:(CGRect)frame andContainerView:(UIView *)cv;

- (void)showWelcomeMessage;
- (void)hideWelcomeMessage;

- (void)addMessage:(SpeechViewMessage *)message;

@end
