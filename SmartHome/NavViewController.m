//
//  NavViewController.m
//  SmartHome
//
//  Created by hadoop user account on 6/08/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "NavViewController.h"

@interface NavViewController ()

@end

@implementation NavViewController

@synthesize topbar;
@synthesize preViewController;

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)initUI {
    [super initUI];
    [self generateTopbar];
}

- (void)generateTopbar {
    self.topbar = [TopbarView topBarWithImage:[UIImage imageNamed:@"bg_topbar.png"] shadow:YES];
    self.topbar.leftButton.frame = CGRectMake(0, 0, 61, 30);
    self.topbar.leftButton.center = CGPointMake(37.5, 22);
    [self.topbar.leftButton setBackgroundImage:[UIImage imageNamed:@"btn_back.jpg"] forState:UIControlStateNormal];
    [self.topbar.leftButton setBackgroundImage:[UIImage imageNamed:@"btn_back.jpg"] forState:UIControlStateHighlighted];
    self.topbar.leftButton.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 1, 0);
    [self.topbar.leftButton setTitle:NSLocalizedString(@"back", @"") forState:UIControlStateNormal];

    self.topbar.leftButton.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [self.topbar.leftButton addTarget:self action:@selector(backToPreViewController) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.topbar];
}

- (void)backToPreViewController {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
