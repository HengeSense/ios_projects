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
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 200, 80)];
    [btn setTitle:@"hello" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(test) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    
    UIButton *regbtn = [[UIButton alloc] initWithFrame:CGRectMake(100,240, 200, 80)];
    [regbtn setTitle:@"register" forState:UIControlStateNormal];
    [regbtn addTarget:self action:@selector(goReg) forControlEvents:UIControlEventTouchDown];
    [self addSubview:regbtn];
    
}

- (void)test {
    ZBarScanningViewController *zbarScanningViewController = [[ZBarScanningViewController alloc] init];
    
    zbarScanningViewController.preViewController = self.ownerController;
    [self.ownerController.navigationController pushViewController:zbarScanningViewController animated:YES];
}

- (void)goReg {
    RegisterViewController *regViewController = [[RegisterViewController alloc] init];
    
//    regViewController.preViewController = self.ownerController;
    [self.ownerController.navigationController pushViewController:regViewController animated:YES];
}

@end
