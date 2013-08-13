//
//  TopbarView.m
//  SmartHome
//
//  Created by Zhao yang on 8/5/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "TopbarView.h"

@implementation TopbarView

@synthesize leftButton;
@synthesize rightButton;
@synthesize titleLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

+ (TopbarView *)topBarWithImage:(UIImage *)img {
    TopbarView *topbar =
        [[TopbarView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, TOP_BAR_HEIGHT)];
    
    if(img != nil) {
        UIImageView *backgroundImageView =
            [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, TOP_BAR_HEIGHT)];
        backgroundImageView.image = img;
        [topbar addSubview:backgroundImageView];
    }
    
    return topbar;
}

- (UIButton *)leftButton {
    if(leftButton == nil) {
        leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, TOP_BAR_HEIGHT)];
        [self addSubview:leftButton];
    }
    return leftButton;
}

- (UIButton *)rightButton {
    if(rightButton == nil) {
        rightButton = [[UIButton alloc]
            initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - 44), 0, 44, TOP_BAR_HEIGHT)];
    }
    return rightButton;
}

- (UILabel *)titleLabel {
    if(titleLabel == nil) {
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, TOP_BAR_HEIGHT)];
        titleLabel.center = self.center;
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont boldSystemFontOfSize:22.0f];
        [self addSubview:titleLabel];
    }
    return titleLabel;
}

@end
