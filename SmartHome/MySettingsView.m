//
//  MySettingsView.m
//  SmartHome
//
//  Created by Zhao yang on 8/5/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "MySettingsView.h"
#import "AlertView.h"

@implementation MySettingsView

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

    [self addSubview: [[UITextField alloc] initWithFrame:CGRectMake(100, 100, 120, 25)]];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(10, 30, 120, 25)];
    [btn setTitle:@"测试自动的Alert" forState:UIControlStateNormal];
    [btn addTarget:self  action:@selector(autoDis) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
}

- (void)autoDis {
    [[AlertView currentAlertView] setMessage:@"操作成功" forType:AlertViewTypeWaitting];
    [[AlertView currentAlertView] alertAutoDisappear:YES lockView:nil];
}

- (void)test {
    [[AlertView currentAlertView] setMessage:@"处理成功" forType:AlertViewTypeSuccess];
    [[AlertView currentAlertView] delayDismissAlertView];
}

@end
