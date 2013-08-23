//
//  LoginViewController.m
//  SmartHome
//
//  Created by hadoop user account on 16/08/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "LoginViewController.h"
#import "SMTextField.h"
#import "LongButton.h"
#import "KeychainItemWrapper.h"
#import "MainViewController.h"
#import "VerificationCodeSendViewController.h"
#import "UIColor+ExtentionForHexString.h"

#define LINE_HIGHT 5
#define INDENTIFER_KEY_WRAPPER @"rememberService"

@interface LoginViewController ()

@end

@implementation LoginViewController{
    UILabel *lblUserName;
    UILabel *lblPassword;
    UILabel *lblRemeberPassword;
    
    UITextField *txtUserName;
    UITextField *txtPassword;
    
    UIButton *btnLogin;
    UIButton *btnRegister;
    
    KeychainItemWrapper *keyWrapper;
}

#pragma mark -
#pragma initializations

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
    [self registerTapGestureToResignKeyboard];
    
    NSString *service = [NSString emptyString];
    
    if(keyWrapper == nil) {
        keyWrapper = [[KeychainItemWrapper alloc] initWithIdentifier:INDENTIFER_KEY_WRAPPER accessGroup:nil];
        service = [keyWrapper objectForKey:(__bridge_transfer id)kSecAttrService];
    }
    
    if(lblUserName == nil) {
        lblUserName = [[UILabel alloc] initWithFrame:CGRectMake(10, 90, 100, 20)];
        lblUserName.backgroundColor = [UIColor clearColor];
        lblUserName.text = NSLocalizedString(@"username", @"");
        lblUserName.font= [UIFont systemFontOfSize:16];
        lblUserName.textColor = [UIColor lightTextColor];
        [self.view addSubview:lblUserName];
    }
    
    if(txtUserName == nil) {
        txtUserName = [SMTextField textFieldWithPoint:CGPointMake(5, (lblUserName.frame.origin.y + LINE_HIGHT + 20))];
        txtUserName.keyboardType = UIKeyboardTypeASCIICapable;
        txtUserName.returnKeyType = UIReturnKeyNext;
        txtUserName.clearButtonMode = UITextFieldViewModeWhileEditing;
        txtUserName.delegate = self;
        [self.view addSubview:txtUserName];
    }
    
    if(lblPassword == nil) {
        lblPassword = [[UILabel alloc] initWithFrame:CGRectMake(10, (txtUserName.frame.origin.y + txtUserName.bounds.size.height + LINE_HIGHT), 100, 20)];
        lblPassword.text = NSLocalizedString(@"password", @"");
        lblPassword.textColor = [UIColor lightTextColor];
        lblPassword.backgroundColor = [UIColor clearColor];
        lblPassword.font= [UIFont systemFontOfSize:16];
        [self.view addSubview:lblPassword];
    }
    
    if(txtPassword == nil) {
        txtPassword = [SMTextField textFieldWithPoint:CGPointMake(5, (lblPassword.frame.origin.y + LINE_HIGHT + 20))];
        [txtPassword setSecureTextEntry:YES];
        txtPassword.returnKeyType = UIReturnKeyJoin;
        txtPassword.delegate =self;
        txtPassword.clearButtonMode = UITextFieldViewModeWhileEditing;
        [self.view addSubview:txtPassword];
    }
    
    if(btnLogin == nil) {
        btnLogin = [LongButton buttonWithPoint:CGPointMake(5, txtPassword.frame.origin.y + (txtPassword.bounds.size.height + LINE_HIGHT))];
        [btnLogin setTitle:NSLocalizedString(@"login", @"") forState:UIControlStateNormal];
        [btnLogin addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnLogin];
    }
    
    if(btnRegister == nil) {
        btnRegister = [[UIButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 5 - 146 / 2), 300, 146 / 2, 52 / 2)];
        [btnRegister setBackgroundImage:[UIImage imageNamed:@"btn_register.png"] forState:UIControlStateNormal];
        [btnRegister setBackgroundImage:[UIImage imageNamed:@"btn_register.png"] forState:UIControlStateHighlighted];
        btnRegister.titleLabel.font = [UIFont systemFontOfSize:13];
        [btnRegister setTitle:NSLocalizedString(@"register_new_user", @"") forState:UIControlStateNormal];
        btnRegister.titleLabel.textColor = [UIColor lightTextColor];
        [btnRegister addTarget:self action:@selector(showRegisterViewController) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnRegister];
    }
    
    txtUserName.text = @"admin";
    txtPassword.text = @"admin";
}

#pragma mark -
#pragma mark services

- (void)login {
    if(![txtUserName.text isEqualToString:@"admin"] && ![txtPassword.text isEqualToString:@"admin"]) {
        return;
    }
    [self.navigationController pushViewController:[[MainViewController alloc] init] animated:YES];
}

-(void)showRegisterViewController {
    [self.navigationController pushViewController:[[VerificationCodeSendViewController alloc] init] animated:YES];
}

#pragma mark -
#pragma mark text field delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if(textField == txtPassword) {
        [textField resignFirstResponder];
        [self login];
    } else if(textField == txtUserName) {
        [txtPassword becomeFirstResponder];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return range.location < 20;
}

@end
