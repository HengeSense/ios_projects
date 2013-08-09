//
//  MainView.m
//  SmartHome
//
//  Created by Zhao yang on 8/5/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "MainView.h"

@implementation MainView {
    BOOL speechViewIsOpenning;
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)initDefaults {
    [super initDefaults];
}

- (void)initUI {
    [super initUI];
    self.backgroundColor = [UIColor lightGrayColor];

    UIButton *btnSpeech = [[UIButton alloc] initWithFrame:CGRectMake((self.frame.size.width-75/2)/2, self.frame.size.height-111/2 - 10, 75/2, 111/2)];
    [btnSpeech setBackgroundImage:[UIImage imageNamed:@"record_animate_00.png"] forState:UIControlStateNormal];
    [btnSpeech addTarget:self action:@selector(btnSpeechPressed) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnSpeech];
}

- (void)btnSpeechPressed {
    
    [self showSpeechView];
}

- (void)showSpeechView {
    CGFloat viewHeight = self.frame.size.height - 111/2 - 20;
    SpeechRecognitionView *view = [[SpeechRecognitionView alloc] initWithFrame:CGRectMake(0, 0 - viewHeight, self.frame.size.width, viewHeight)];
    view.backgroundColor = [UIColor blackColor];
    view.alpha = 0.8f;
    [self addSubview:view];
    [UIView animateWithDuration:0.3f
                animations:^{
                    view.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
                }
                completion:^(BOOL finished) {
                }];
}

@end
