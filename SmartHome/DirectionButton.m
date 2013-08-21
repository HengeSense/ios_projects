//
//  DirectionButton.m
//  SmartHome
//
//  Created by Zhao yang on 8/21/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "DirectionButton.h"

@implementation DirectionButton {
    UIImageView *backgroundImageView;
    UIImageView *imgLeftButton;
    UIImageView *imgRightButton;
    UIImageView *imgTopButton;
    UIImageView *imgBottomButton;
    UIImageView *imgCenterButton;
    UITapGestureRecognizer *tapGesture;
}

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initDefaults];
        [self initUI];
    }
    return self;
}

+ (DirectionButton *)directionButtonWithPoint:(CGPoint)point {
    return [[DirectionButton alloc] initWithFrame:CGRectMake(point.x, point.y, 281/2, 282/2)];
}

- (void)initDefaults {
    
}

- (void)initUI {
    if(backgroundImageView == nil) {
        backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        backgroundImageView.image = [UIImage imageNamed:@"bg_camera.png"];
        [self addSubview:backgroundImageView];
    }
    
    if(imgLeftButton == nil) {
        imgLeftButton = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 81/2, 182/2)];
        imgLeftButton.center = CGPointMake(imgLeftButton.center.x, backgroundImageView.center.y);
        imgLeftButton.image = [UIImage imageNamed:@"btn_camera_left.png"];
        [self addSubview:imgLeftButton];
    }
    
    if(imgRightButton == nil) {
        imgRightButton = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width-81/2, 0, 81/2, 182/2)];
        imgRightButton.center = CGPointMake(imgRightButton.center.x, backgroundImageView.center.y);
        imgRightButton.image = [UIImage imageNamed:@"btn_camera_right.png"];
        [self addSubview:imgRightButton];
    }
    
    if(imgTopButton == nil) {
        imgTopButton = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 182/2, 81/2)];
        imgTopButton.center = CGPointMake(backgroundImageView.center.x, imgTopButton.center.y);
        imgTopButton.image = [UIImage imageNamed:@"btn_camera_top.png"];
        [self addSubview:imgTopButton];
    }
    
    if(imgBottomButton == nil) {
        imgBottomButton = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-81/2, 182/2, 81/2)];
        imgBottomButton.center = CGPointMake(backgroundImageView.center.x, imgBottomButton.center.y);
        imgBottomButton.image = [UIImage imageNamed:@"btn_camera_bottom.png"];
        [self addSubview:imgBottomButton];
    }
    
    if(imgCenterButton == nil) {
        imgCenterButton = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 126/2, 126/2)];
        imgCenterButton.center = backgroundImageView.center;
        imgCenterButton.image = [UIImage imageNamed:@"btn_camera_center.png"];
        [self addSubview:imgCenterButton];
    }
    
    if(tapGesture == nil) {
        tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
        [self addGestureRecognizer:tapGesture];
    }
}

- (void)handleTapGesture:(UITapGestureRecognizer *)gesture {
//    if(self.delegate == nil) return;
    
    CGPoint point = [gesture locationInView:self];
    NSLog(@"x=%f y=%f", point.x, point.y);
    
//    if is clicked on left button
//    if([self.delegate respondsToSelector:@selector(leftButtonClicked)]) {
//        [self.delegate leftButtonClicked];
//    }
}


@end
