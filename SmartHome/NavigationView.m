//
//  NavigationView.m
//  SmartHome
//
//  Created by Zhao yang on 8/6/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "NavigationView.h"

@implementation NavigationView {
    TopbarView *topbar;
    UILabel *lblTitle;
}

@synthesize ownerController;
@synthesize topbar;
@synthesize backgroundImageView;

- (id)initWithFrame:(CGRect)frame owner:(MainViewController *)controller {
    self = [super initWithFrame:frame];
    if (self) {
        ownerController = controller;
        [self initDefaults];
        [self initUI];
    }
    return self;
}

- (void)initDefaults {
}

- (void)initUI {
    //top bar for main view
    [self addSubview:self.topbar];
    [self addSubview:self.backgroundImageView];
}

- (TopbarView *)topbar {
    if(topbar == nil) {
        topbar = [TopbarView topBarWithImage:[UIImage imageNamed:@"bg_topbar_first_level.png"]];
        topbar.leftButton.frame = CGRectMake(0, 0, 44, 44);
        [topbar.leftButton setBackgroundImage:[UIImage imageNamed:@"btn_drawer_nav.png"] forState:UIControlStateNormal];
        [topbar.leftButton addTarget:self.ownerController action:@selector(showLeftView) forControlEvents:UIControlEventTouchUpInside];
    }
    return topbar;
}

- (UIImageView *)backgroundImageView {
    if(backgroundImageView == nil) {
        backgroundImageView = [[UIImageView alloc]
            initWithFrame:CGRectMake(0, topbar.frame.size.height, [UIScreen mainScreen].bounds.size.width,
            ([UIScreen mainScreen].bounds.size.height - topbar.frame.size.height))];
        backgroundImageView.image = [UIImage imageNamed:@"bg.png"];
    }
    return backgroundImageView;
}

@end
