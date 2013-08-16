//
//  LoginViewController.m
//  SmartHome
//
//  Created by hadoop user account on 16/08/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController{
    UILabel *username;
    UILabel *password;
    UILabel *rememberPassword;
    
    UITextField *usernameField;
    UITextField *passwordField;
    
    UIButton *rememberBtn;
    UIButton *loginBtn;
    UIButton *registerBtn;
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
    //CGFloat screenHight = self.view.bounds.size.height;
    CGFloat screenWidth = self.view.bounds.size.width;
    username = [[UILabel alloc] initWithFrame:CGRectMake(10, 100, 100, 20)];
    username.backgroundColor = [UIColor clearColor];
    username.text = NSLocalizedString(@"username:", @"");
    username.textColor = [UIColor whiteColor];
    [self.view addSubview:username];
    
    usernameField = [[UITextField alloc] initWithFrame:CGRectMake(5, 120, 616/2, 96/2)];
    [usernameField setBackground:[UIImage imageNamed:@"bg_text_field.png"]];
    [self.view addSubview:usernameField];
    
    password = [[UILabel alloc] initWithFrame:CGRectMake(10, 230, 100, 20)];
    password.text = NSLocalizedString(@"password:", @"");
    password.textColor = [UIColor whiteColor];
    password.backgroundColor = [UIColor clearColor];
    [self.view addSubview:password];
    
    
    
}
@end
