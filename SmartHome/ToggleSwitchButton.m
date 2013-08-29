//
//  ToggleSwitchButton.m
//  SmartHome
//
//  Created by Zhao yang on 8/21/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "ToggleSwitchButton.h"

@implementation ToggleSwitchButton

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
    [self registerImage:[UIImage imageNamed:@"icon_device_off.png"] forStatus:@"off"];
    [self registerImage:[UIImage imageNamed:@"icon_device_on.png"] forStatus:@"on"];
}

+ (SwitchButton *)buttonWithPoint:(CGPoint)point owner:(UIViewController *)owner {
    SwitchButton *switchButton = [[ToggleSwitchButton alloc] initWithFrame:CGRectMake(point.x, point.y, 80, 52)];
    switchButton.ownerController = owner;
    return switchButton;
}

- (void)btnPressed:(id)sender {
    
}

@end
