//
//  TVRemoteControlPanel.m
//  SmartHome
//
//  Created by Zhao yang on 9/4/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "TVRemoteControlPanel.h"
#import "UIColor+ExtentionForHexString.h"

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
        btnSignal.titleLabel.font = [UIFont systemFontOfSize:15.f];
        [btnSignal setTitleEdgeInsets:UIEdgeInsetsMake(-1, 0, 0, 0)];
        [btnSignal setTitle:NSLocalizedString(@"signal_source", @"") forState:UIControlStateNormal];
        [btnSignal setTitleColor:[UIColor colorWithHexString:@"b8642d"] forState:UIControlStateNormal];
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
            [btnDigital setTitleColor:[UIColor colorWithHexString:@"b8642d"] forState:UIControlStateNormal];
            [btnDigital setTitle:[NSString stringWithFormat:@"%d", i>=9 ? 0 : (i+1)] forState:UIControlStateNormal];
            btnDigital.source = [NSNumber numberWithInteger:i+2];
            [btnDigital setBackgroundImage:[UIImage imageNamed:@"btn_rc_number.png"] forState:UIControlStateNormal];
            [btnDigital setBackgroundImage:[UIImage imageNamed:@"btn_rc_number.png"] forState:UIControlStateHighlighted];
            [btnDigital addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btnDigital];
            [btnDigitalGroups addObject:btnDigital];
        }
    }

    if(btnBack == nil) {
        btnBack = [[SMButton alloc] initWithFrame:CGRectMake(20, 320, 146/2, 62/2)];
        btnBack.titleLabel.font = [UIFont systemFontOfSize:15.f];
        [btnBack setTitleEdgeInsets:UIEdgeInsetsMake(-1, 0, 0, 0)];
        [btnBack setTitle:NSLocalizedString(@"back", @"") forState:UIControlStateNormal];
        [btnBack setTitleColor:[UIColor colorWithHexString:@"b8642d"] forState:UIControlStateNormal];
        [btnBack setBackgroundImage:[UIImage imageNamed:@"btn_rc.png"] forState:UIControlStateNormal];
        [btnBack setBackgroundImage:[UIImage imageNamed:@"btn_rc.png"] forState:UIControlStateHighlighted];
        [btnBack addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
        btnBack.source = [NSNumber numberWithInteger:30];
        [self addSubview:btnBack];
    }
    
    if(btnMenu == nil) {
        btnMenu = [[SMButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 20 - 146/2, 320, 146/2, 62/2)];
        [btnMenu setTitle:NSLocalizedString(@"menu", @"") forState:UIControlStateNormal];
        [btnMenu setTitleEdgeInsets:UIEdgeInsetsMake(-1, 0, 0, 0)];
        btnMenu.titleLabel.font = [UIFont systemFontOfSize:15.f];
        [btnMenu setTitleColor:[UIColor colorWithHexString:@"b8642d"] forState:UIControlStateNormal];
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

- (void)btnPressed:(id)sender {
    if(sender != nil) {
        NSNumber *number = nil;
        if([sender isKindOfClass:[SMButton class]]) {
            number = ((SMButton *)sender).source;
        } else if([sender isKindOfClass:[NSNumber class]]) {
            number = sender;
        }
        if(number != nil) {
            NSLog(@"remote control %d was pressed.", number.integerValue);
        }
    }
}

#pragma mark -
#pragma mark direction button delegate

- (void)leftButtonClicked {
    [self btnPressed:[NSNumber numberWithInteger:16]];
}

- (void)rightButtonClicked {
    [self btnPressed:[NSNumber numberWithInteger:17]];
}

- (void)topButtonClicked {
    [self btnPressed:[NSNumber numberWithInteger:14]];
}

- (void)bottomButtonClicked {
    [self btnPressed:[NSNumber numberWithInteger:15]];
}

- (void)centerButtonClicked {
    [self btnPressed:[NSNumber numberWithInteger:18]];
}

@end