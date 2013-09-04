//
//  TVRemoteControlPanel.m
//  SmartHome
//
//  Created by Zhao yang on 9/4/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "TVRemoteControlPanel.h"

@implementation TVRemoteControlPanel {
    UIButton *btnPower;
    UIButton *btnSignal;
    NSArray *btnDigitalGroups;
    UIButton *btnBack;
    UIButton *btnMenu;
    DirectionButton *btnDirection;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

+ (TVRemoteControlPanel *)pannelWithPoint:(CGPoint)point {
    return [[TVRemoteControlPanel alloc] initWithFrame:CGRectMake(point.x, point.y, [UIScreen mainScreen].bounds.size.width, 320)];
}

- (void)initUI {
    if(btnPower == nil) {
        btnPower = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    }
    
    if(btnSignal == nil) {
        btnSignal = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    }
    
    if(btnBack == nil) {
        btnBack = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    }
    
    if(btnMenu == nil) {
        btnMenu = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    }
    
    if(btnDirection == nil) {
        btnDirection = [DirectionButton tvDirectionButtonWithPoint:CGPointMake(100, 100)];
        [self addSubview:btnDirection];
    }
    
    if(btnDigitalGroups == nil) {
        btnDigitalGroups = [NSMutableArray array];
        for(int i=0; i<10; i++) {
            UIButton *btnDigital = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        }
    }
}

- (void)btnPressed:(id)sender {
    
}

#pragma mark -
#pragma mark direction button delegate

- (void)leftButtonClicked {
    
}

- (void)rightButtonClicked {
    
}

- (void)topButtonClicked {
    
}

- (void)bottomButtonClicked {
    
}

- (void)centerButtonClicked {
    
}

@end
