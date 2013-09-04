//
//  TVRemoteControlPanel.m
//  SmartHome
//
//  Created by Zhao yang on 9/4/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "TVRemoteControlPanel.h"

@implementation TVRemoteControlPanel {
    SMButton *btnPower;
    SMButton *btnSignal;
    NSMutableArray *btnDigitalGroups;
    SMButton *btnBack;
    SMButton *btnMenu;
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
    return [[TVRemoteControlPanel alloc] initWithFrame:CGRectMake(point.x, point.y, [UIScreen mainScreen].bounds.size.width, 380)];
}

- (void)initUI {
    if(btnPower == nil) {
        btnPower = [[SMButton alloc] initWithFrame:CGRectMake(32, 15, 75/2, 78/2)];
        [btnPower setBackgroundImage:[UIImage imageNamed:@"btn_rc_power.png"] forState:UIControlStateNormal];
        [btnPower setBackgroundImage:[UIImage imageNamed:@"btn_rc_power.png"] forState:UIControlStateHighlighted];
        [btnPower addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
        btnPower.source = [NSNumber numberWithInteger:1];
        [self addSubview:btnPower];
    }
    
    if(btnSignal == nil) {
        btnSignal = [[SMButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 146/2 - 32, 18, 146/2, 62/2)];
        [btnSignal setBackgroundImage:[UIImage imageNamed:@"btn_rc.png"] forState:UIControlStateNormal];
        [btnSignal setBackgroundImage:[UIImage imageNamed:@"btn_rc.png"] forState:UIControlStateHighlighted];
        [btnSignal addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
        btnSignal.source = [NSNumber numberWithInteger:35];
        [self addSubview:btnSignal];
    }
    
    if(btnDigitalGroups == nil) {
        btnDigitalGroups = [NSMutableArray array];
        for(int i=0; i<10; i++) {
            CGFloat x = i<5 ? ((75/2) * i + i*23 + 20) : ((75/2) * (i-5) + (i-5)*23 + 20);
            CGFloat y = i<5 ? 80 : 135;
            SMButton *btnDigital = [[SMButton alloc] initWithFrame:CGRectMake(x, y, 75/2, 78/2)];
            btnDigital.source = [NSNumber numberWithInteger:i+2];
            [btnDigital setBackgroundImage:[UIImage imageNamed:@"btn_rc_number.png"] forState:UIControlStateNormal];
            [btnDigital setBackgroundImage:[UIImage imageNamed:@"btn_rc_number.png"] forState:UIControlStateHighlighted];
            [btnDigital addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btnDigital];
        }
    }

    if(btnBack == nil) {
        btnBack = [[SMButton alloc] initWithFrame:CGRectMake(20, 320, 146/2, 62/2)];
        [btnBack setBackgroundImage:[UIImage imageNamed:@"btn_rc.png"] forState:UIControlStateNormal];
        [btnBack setBackgroundImage:[UIImage imageNamed:@"btn_rc.png"] forState:UIControlStateHighlighted];
        [btnBack addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
        btnBack.source = [NSNumber numberWithInteger:30];
        [self addSubview:btnBack];
    }
    
    if(btnMenu == nil) {
        btnMenu = [[SMButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 20 - 146/2, 320, 146/2, 62/2)];
        [btnMenu setBackgroundImage:[UIImage imageNamed:@"btn_rc.png"] forState:UIControlStateNormal];
        [btnMenu setBackgroundImage:[UIImage imageNamed:@"btn_rc.png"] forState:UIControlStateHighlighted];
        btnMenu.source = [NSNumber numberWithInteger:13];
        [btnMenu addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnMenu];
    }
   
    if(btnDirection == nil) {
        btnDirection = [DirectionButton tvDirectionButtonWithPoint:CGPointMake(100, 190)];
        btnDirection.center = CGPointMake(self.bounds.size.width/2, btnDirection.center.y);
        btnDirection.delegate = self;
        [self addSubview:btnDirection];
    }
}

- (void)btnPressed:(SMButton *)sender {
    if(sender != nil) {
        NSNumber *number = sender.source;
        NSLog(@"%d", number.integerValue);
    }
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
