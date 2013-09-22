//
//  TopbarView.m
//  SmartHome
//
//  Created by Zhao yang on 8/5/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "TopbarView.h"
#import "UIColor+ExtentionForHexString.h"

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

+ (TopbarView *)topBarWithImage:(UIImage *)img shadow:(BOOL)needShadow {
    CGFloat height = needShadow ? TOP_BAR_HEIGHT : 44;
    
    
    if([UIDevice systemVersionIsMoreThanOrEuqal7]) {
        height += 20;
    }
    
    TopbarView *topbar =
        [[TopbarView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, height)];
    
    if(img != nil) {
        UIImageView *backgroundImageView =
            [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, 44)];
        backgroundImageView.image = img;
        [topbar addSubview:backgroundImageView];
    }
    
    if(needShadow) {
        UIImageView *shadowView = [[UIImageView alloc] initWithFrame:CGRectMake(0, height, [UIScreen mainScreen].bounds.size.width, 5 / 2)];
        shadowView.image = [UIImage imageNamed:@"bg_shadow.png"];
        [topbar addSubview:shadowView];
    }
    
    return topbar;
}

- (UIButton *)leftButton {
    if(leftButton == nil) {
        leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, [UIDevice systemVersionIsMoreThanOrEuqal7] ? 20 : 0, 44, 44)];
        [self addSubview:leftButton];
    }
    return leftButton;
}

- (UIButton *)rightButton {
    if(rightButton == nil) {
        rightButton = [[UIButton alloc]
            initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - 44), [UIDevice systemVersionIsMoreThanOrEuqal7] ? 20 : 0, 44, 44)];
        [self addSubview:rightButton];
    }
    return rightButton;
}

- (UILabel *)titleLabel {
    if(titleLabel == nil) {
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, [UIDevice systemVersionIsMoreThanOrEuqal7] ? 20 : 0, 150, 44)];
        titleLabel.center = CGPointMake(self.center.x, titleLabel.center.y);
        titleLabel.textColor = [UIColor lightTextColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont systemFontOfSize:20.0f];
        [self addSubview:titleLabel];
    }
    return titleLabel;
}

@end
