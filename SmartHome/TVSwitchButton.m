//
//  TVSwitchButton.m
//  SmartHome
//
//  Created by Zhao yang on 8/21/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "TVSwitchButton.h"
#import "TVViewController.h"

@implementation TVSwitchButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)initDefaults {
    [super initDefaults];
}

- (void)initUI {
    [super initUI];
    [self registerImage:[UIImage imageNamed:@"icon_tv_on.png"] forStatus:@"on"];
}

- (void)btnPressed:(id)sender {
    TVViewController *tvViewController = [[TVViewController alloc] init];
    tvViewController.delegate = [self findContainerView];
    [self.ownerController presentModalViewController:tvViewController animated:YES];
}

+ (SwitchButton *)buttonWithPoint:(CGPoint)point owner:(UIViewController *)owner {
    SwitchButton *switchButton = [[TVSwitchButton alloc] initWithFrame:CGRectMake(point.x, point.y, 80, 52)];
    switchButton.ownerController = owner;
    return switchButton;
}

@end
