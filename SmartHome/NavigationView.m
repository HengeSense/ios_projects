//
//  NavigationView.m
//  SmartHome
//
//  Created by Zhao yang on 8/6/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "NavigationView.h"
#import "UIColor+ExtentionForHexString.h"

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
    self.backgroundColor = [UIColor colorWithHexString:@"#3a3e47"];
}

- (TopbarView *)topbar {
    if(topbar == nil) {
        topbar = [TopbarView topBarWithImage:[UIDevice systemVersionIsMoreThanOrEuqal7] ? [UIImage imageNamed:@"bg_topbar.png"] : [UIImage imageNamed:@"bg_topbar.png"] shadow:YES];
        //topbar.leftButton.frame = CGRectMake(0, 0, 44, 44);
        [topbar.leftButton setBackgroundImage:[UIImage imageNamed:@"btn_drawer_nav.png"] forState:UIControlStateNormal];
        [topbar.leftButton addTarget:self.ownerController action:@selector(showLeftView) forControlEvents:UIControlEventTouchUpInside];
        [topbar.leftButton addTarget:self.ownerController action:@selector(showLeftView) forControlEvents:UIControlEventTouchUpInside];
    }
    return topbar;
}

/*
- (void)refreshTopbarEvent {
    if(topbar != nil) {
        [topbar.leftButton removeTarget:self.ownerController action:@selector(showLeftView) forControlEvents:UIControlEventTouchUpInside];
        [topbar.leftButton addTarget:self.ownerController action:@selector(showLeftView) forControlEvents:UIControlEventTouchUpInside];
    }
}*/

- (void)notifyViewUpdate {
    
}

@end
