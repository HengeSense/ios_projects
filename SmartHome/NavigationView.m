//
//  NavigationView.m
//  SmartHome
//
//  Created by Zhao yang on 8/6/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "NavigationView.h"
#import "TopbarView.h"

@implementation NavigationView {
    TopbarView *topbar;
}

@synthesize ownerController;

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
      //  
}

- (void)initUI {
    topbar = [TopbarView topBarWithImage:[UIImage imageNamed:@"top.png"]];
    [topbar.leftButton setBackgroundImage:[UIImage imageNamed:@"left_btn.png"] forState:UIControlStateNormal];
    [topbar.leftButton addTarget:self.ownerController action:@selector(showLeftView) forControlEvents:UIControlEventTouchUpInside];
    //top bar for main view
    [self addSubview:topbar];
}

@end
