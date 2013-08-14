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
    [self generateTopbar];
    [self generateBackgroundView];
}

- (void)generateTopbar {
    self.topbar = [TopbarView topBarWithImage:[UIImage imageNamed:@"bg_topbar_second_level.png"]];
    self.topbar.leftButton.frame = CGRectMake(0, 0, 61, 30);
    self.topbar.leftButton.center = CGPointMake(37.5, 22);
    [self.topbar.leftButton setBackgroundImage:[UIImage imageNamed:@"btn_back.png"] forState:UIControlStateNormal];
    [self.topbar.leftButton setBackgroundImage:[UIImage imageNamed:@"btn_back.png"] forState:UIControlStateHighlighted];
    [self.topbar.leftButton addTarget:self action:@selector(backToPreViewController) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.topbar];
}

- (void)generateBackgroundView {
    UIImageView *backgroundImageView = [[UIImageView alloc]
        initWithFrame:CGRectMake(0, self.topbar.frame.size.height, [UIScreen mainScreen].bounds.size.width,
        ([UIScreen mainScreen].bounds.size.height - self.topbar.frame.size.height - 20))];
    backgroundImageView.image = [UIImage imageNamed:@"bg.png"];
    [self.view addSubview:backgroundImageView];
}

- (void)backToPreViewController {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
