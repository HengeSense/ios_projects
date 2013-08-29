//
//  AirconditionSwitchButton.m
//  SmartHome
//
//  Created by Zhao yang on 8/21/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "AirconditionSwitchButton.h"
#import "AirConditionViewController.h"

@implementation AirconditionSwitchButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)initDefaults {
    [super initDefaults];
}

- (void)initUI {
    [super initUI];
    [self registerImage:[UIImage imageNamed:@"icon_aircondition_off.png"] forStatus:@"off"];
    [self registerImage:[UIImage imageNamed:@"icon_aircondition_on.png"] forStatus:@"on"];
}

- (void)btnPressed:(id)sender {
    AirConditionViewController *airConditionViewController = [[AirConditionViewController alloc] init];
    airConditionViewController.delegate = [self findContainerView];
    [self.ownerController presentModalViewController:airConditionViewController animated:YES];
}

+ (SwitchButton *)buttonWithPoint:(CGPoint)point owner:(UIViewController *)owner {
    SwitchButton *switchButton = [[AirconditionSwitchButton alloc] initWithFrame:CGRectMake(point.x, point.y, 80, 52)];
    switchButton.ownerController = owner;
    return switchButton;
}

@end
