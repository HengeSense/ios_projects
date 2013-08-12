//
//  MainView.m
//  SmartHome
//
//  Created by Zhao yang on 8/5/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "MainView.h"

#define SPEECH_VIEW_TAG 46001

@implementation MainView {
    SpeechViewState speechViewState;
    SpeechRecognitionView *speechView;
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
    speechViewState = SpeechViewStateClosed;
}

- (void)initUI {
    [super initUI];
    self.backgroundColor = [UIColor lightGrayColor];

    UIButton *btnSpeech = [[UIButton alloc] initWithFrame:CGRectMake((self.frame.size.width-75/2)/2, self.frame.size.height-111/2 - 10, 75/2, 111/2)];
    [btnSpeech setBackgroundImage:[UIImage imageNamed:@"record_animate_00.png"] forState:UIControlStateNormal];
    [btnSpeech addTarget:self action:@selector(btnSpeechPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnSpeech];
}

#pragma mark -
#pragma mark speech view

- (void)showSpeechView {
    if(speechViewState != SpeechViewStateClosed) return;
    SpeechRecognitionView *view = (SpeechRecognitionView *)[self viewWithTag:SPEECH_VIEW_TAG];
    if(view == nil) {
        view = [self speechView];
        [self addSubview:view];
    }
    speechViewState = SpeechViewStateOpenning;
    [self.ownerController disableGestureForDrawerView];
    [UIView animateWithDuration:0.3f
                animations:^{
                    view.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
                }
                completion:^(BOOL finished) {
                    speechViewState = SpeechViewStateOpenned;
                    [self btnSpeechRecordingPressed:nil];
                }];
}

- (void)hideSpeechView {
    if(speechViewState != SpeechViewStateOpenned) return;
    CGFloat viewHeight = self.frame.size.height - 111/2 - 20;
    SpeechRecognitionView *view = [self speechView];
    speechViewState = SpeechViewStateClosing;
    [UIView animateWithDuration:0.3f
                     animations:^{
                         view.frame = CGRectMake(0, (0 - viewHeight), view.frame.size.width, view.frame.size.height);
                     }
                     completion:^(BOOL finished) {
                         [[self speechView] hideWelcomeMessage];
                         [[self speechView] removeFromSuperview];
                         [self.ownerController enableGestureForDrawerView];
                         speechViewState = SpeechViewStateClosed;
                     }];
}

#pragma mark -
#pragma mark speech control

- (void)btnSpeechPressed:(id)sender {
    if(speechViewState == SpeechViewStateClosed) {
        [self showSpeechView];
    } else if(speechViewState ==  SpeechViewStateOpenned) {
        [self btnSpeechRecordingPressed:sender];
    }
}

- (void)btnSpeechRecordingPressed:(id)sender {
    NSLog(@"换图片");
    //[speechView showWelcomeMessage];
    [speechView hideWelcomeMessage];
}

#pragma mark -
#pragma mark getter and setters

- (SpeechRecognitionView *)speechView {
    if(speechView == nil) {
        CGFloat viewHeight = self.frame.size.height - 111/2 - 20;
        speechView = [[SpeechRecognitionView alloc] initWithFrame:CGRectMake(0, (0 - viewHeight), self.frame.size.width, viewHeight) andContainerView:self];
        speechView.tag = SPEECH_VIEW_TAG;
    }
    return speechView;
}

@end
