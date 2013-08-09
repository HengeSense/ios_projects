//
//  DevicesView.m
//  SmartHome
//
//  Created by Zhao yang on 8/5/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "DevicesView.h"

@implementation DevicesView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initDefaults {
    [super initDefaults];
}

- (void)initUI {
    [super initUI];
    
    self.backgroundColor = [UIColor lightGrayColor];
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 25)];
    lbl.text = @"设备列表页面";
    lbl.center = CGPointMake(160, 240);
    [self addSubview:lbl];
}

@end
