//
//  SwitchButton.m
//  SmartHome
//
//  Created by Zhao yang on 8/21/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "SwitchButton.h"

@implementation SwitchButton {
    UIButton *btn;
    UILabel *lblTitle;
}

@synthesize iconImageName;
@synthesize title;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initDefaults];
        [self initUI];
    }
    return self;
}

- (void)initDefaults {
    
}

- (void)initUI {
    if(btn == nil) {
        btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    }
    
    if(lblTitle == nil) {
        lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    }
}

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents {
    if(btn != nil) {
        [btn addTarget:target action:action forControlEvents:controlEvents];
    }
}

+ (SwitchButton *)buttonWithTitle:(NSString *)t andImageName:(NSString *)imageName {
    SwitchButton *switchButton = [[SwitchButton alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    switchButton.iconImageName = imageName;
    switchButton.title = t;
    return switchButton;
}

@end
