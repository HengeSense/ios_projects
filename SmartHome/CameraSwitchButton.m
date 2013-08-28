//
//  CameraSwitchButton.m
//  SmartHome
//
//  Created by Zhao yang on 8/21/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "CameraSwitchButton.h"
#import "CameraAdjustViewController.h"

@implementation CameraSwitchButton

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
    [self registerImage:[UIImage imageNamed:@"icon_device_off.png"] forStatus:@"off"];
    [self registerImage:[UIImage imageNamed:@"icon_device_on.png"] forStatus:@"on"];
}

- (void)btnPressed:(id)sender {
    CameraAdjustViewController *cameraView = [[CameraAdjustViewController alloc] init];
    cameraView.delegate = [self findContainerView];
    [self.ownerController presentModalViewController:cameraView animated:YES];
}

+ (SwitchButton *)buttonWithPoint:(CGPoint)point owner:(UIViewController *)owner {
    SwitchButton *switchButton = [[CameraSwitchButton alloc] initWithFrame:CGRectMake(point.x, point.y, 80, 52)];
    switchButton.ownerController = owner;
    return switchButton;
}

@end
