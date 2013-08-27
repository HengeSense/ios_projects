//
//  AirConditionViewController.m
//  SmartHome
//
//  Created by Zhao yang on 8/5/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "AirConditionViewController.h"
#import "RadioButton.h"
#import <QuartzCore/QuartzCore.h>

#define RADIO_MARGIN 60
#define LABEL_MARGIN_TOP 20
#define RADIO_CENTER 10

@interface AirConditionViewController ()

@end

@implementation AirConditionViewController{
    UIView *backgroundView;
    
    UILabel *lblHot;
    UILabel *lblCool;
    UILabel *lblClose;
    
    UIButton *btnHot;
    UIButton *btnCool;
    UIButton *btnClose;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) initUI{
    [super initUI];
    
    self.topbar.titleLabel.text = NSLocalizedString(@"aircondition_setting.title",@"");
    
    if(backgroundView == nil) {
        backgroundView = [[UIView alloc] initWithFrame:CGRectMake(3, self.topbar.frame.size.height, (self.view.frame.size.width - 6), (self.view.frame.size.height - self.topbar.frame.size.height) / 4)];
        backgroundView.layer.cornerRadius = 8;
        backgroundView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:backgroundView];
    }
    
    if(btnHot == nil) {
        btnHot = [RadioButton buttonWithPoint:CGPointMake(RADIO_MARGIN, RADIO_MARGIN)];
        [btnHot addTarget:self action:@selector(radioTouchInside:) forControlEvents:UIControlEventTouchUpInside];
        btnHot.selected = YES;
        [backgroundView addSubview:btnHot];
    }
    
    if(lblHot == nil) {
        lblHot = [[UILabel alloc] initWithFrame:CGRectMake(btnHot.frame.origin.x-RADIO_CENTER, LABEL_MARGIN_TOP, 40, 20)];
        lblHot.text = NSLocalizedString(@"heating", @"");
        lblHot.textColor = [UIColor blackColor];
        lblHot.textAlignment = UITextAlignmentCenter;
        lblHot.backgroundColor = [UIColor clearColor];
        [backgroundView addSubview:lblHot];
    }
    
    if(btnCool==nil){
        btnCool = [RadioButton buttonWithPoint:CGPointMake(btnHot.frame.origin.x+btnHot.frame.size.width+RADIO_MARGIN, RADIO_MARGIN)];
        [btnCool addTarget:self action:@selector(radioTouchInside:) forControlEvents:UIControlEventTouchUpInside];
        [backgroundView addSubview:btnCool];
    }
    
    if(lblCool == nil) {
        lblCool = [[UILabel alloc] initWithFrame:CGRectMake(btnCool.frame.origin.x-RADIO_CENTER, LABEL_MARGIN_TOP, 40, 20)];
        lblCool.text = NSLocalizedString(@"refrigeration", @"");
        lblCool.textColor = [UIColor blackColor];
        lblCool.textAlignment = UITextAlignmentCenter;
        lblCool.backgroundColor = [UIColor clearColor];
        [backgroundView addSubview:lblCool];
    }
    
    if(btnClose == nil){
        btnClose = [RadioButton buttonWithPoint:CGPointMake(btnCool.frame.origin.x+btnCool.frame.size.width+RADIO_MARGIN, RADIO_MARGIN)];
        [btnClose addTarget:self action:@selector(radioTouchInside:) forControlEvents:UIControlEventTouchUpInside];
        [backgroundView addSubview:btnClose];
    }
    
    if(lblClose == nil) {
        lblClose = [[UILabel alloc] initWithFrame:CGRectMake(btnClose.frame.origin.x-RADIO_CENTER, LABEL_MARGIN_TOP, 40, 20)];
        lblClose.text = NSLocalizedString(@"close", @"");
        lblClose.textColor = [UIColor blackColor];
        lblClose.textAlignment = UITextAlignmentCenter;
        lblClose.backgroundColor = [UIColor clearColor];
        [backgroundView addSubview:lblClose];
    }
}

- (void)radioTouchInside:(UIButton *)radio {
    btnHot.selected =NO;
    btnCool.selected = NO;
    btnClose.selected = NO;
    radio.selected =!radio.selected;
}

@end
