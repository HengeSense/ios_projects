//
//  PasswordPopupViewController.m
//  SmartHome
//
//  Created by hadoop user account on 6/09/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "PasswordPopupViewController.h"
#import "UIViewController+MJPopupViewController.h"
@interface PasswordPopupViewController ()

@end

@implementation PasswordPopupViewController{
    UIButton *cancelBtn;
    UIButton *okBtn;
    UITextField *passwordField;
    UILabel *title;
    UILabel *message;
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
    self.view.layer.cornerRadius = 10;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
