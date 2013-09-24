//
//  CameraLoadingView.m
//  SmartHome
//
//  Created by Zhao yang on 9/24/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "CameraLoadingView.h"
#import "NSString+StringUtils.h"

@implementation CameraLoadingView {
    UIActivityIndicatorView *indicatorView;
    UILabel *lblTitle;
}

@synthesize message = _message_;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initDefaults];
        [self initUI];
    }
    return self;
}

+ (CameraLoadingView *)viewWithPoint:(CGPoint)point {
    
    CameraLoadingView *view = [[CameraLoadingView alloc] initWithFrame:CGRectMake(point.x, point.y, 180, 50)];
    
    return view;
}

- (void)initDefaults {
    
}

- (void)initUI {
    self.backgroundColor = [UIColor blackColor];
    
    if(indicatorView == nil) {
        indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(5, 3, 44, 44)];
        indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        [self addSubview:indicatorView];
    }
    
    if(lblTitle == nil) {
        lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(60, 3, 100, 44)];
        lblTitle.text = NSLocalizedString(@"loading", @"");
        lblTitle.textColor = [UIColor whiteColor];
        lblTitle.textAlignment = NSTextAlignmentCenter;
        lblTitle.backgroundColor = [UIColor clearColor];
        
        [self addSubview:lblTitle];
    }
    
    [self show];
}

- (void)show {
    self.hidden = NO;
    if(!indicatorView.isAnimating) {
        [indicatorView startAnimating];
    }
}

- (void)hide {
    if(indicatorView.isAnimating) {
        [indicatorView stopAnimating];
    }
    self.hidden = YES;
}

- (void)setMessage:(NSString *)message {
    _message_ = message;
    if([NSString isBlank:_message_]) {
        lblTitle.text = [NSString emptyString];
    } else {
        lblTitle.text = _message_;
    }
}

@end
