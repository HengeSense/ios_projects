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
}

- (TopbarView *)topbar {
    if(topbar == nil) {
        topbar = [TopbarView topBarWithImage:[UIImage imageNamed:@"top.png"]];
        [topbar.leftButton setBackgroundImage:[UIImage imageNamed:@"left_btn.png"] forState:UIControlStateNormal];
        [topbar.leftButton addTarget:self.ownerController action:@selector(showLeftView) forControlEvents:UIControlEventTouchUpInside];
    }
    return topbar;
}

@end
