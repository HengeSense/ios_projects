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
        // Initialization code
    }
    return self;
}

+ (TVRemoteControlPanel *)pannelWithPoint:(CGPoint)point {
    
    
    
    
    return nil;
}

- (void)initUI {
    if(btnPower == nil) {
        
    }
    
    if(btnSignal == nil) {
        
    }
    
    if(btnBack == nil) {
        
    }
    
    if(btnMenu == nil) {
        
    }
    
    if(btnDirection == nil) {
        
    }
    
    if(btnDigitalGroups == nil) {
        
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
