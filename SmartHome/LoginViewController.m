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
#import "MainViewController.h"
#import "UnitsBindingViewController.h"
#import "VerificationCodeSendViewController.h"
#import "UIColor+ExtentionForHexString.h"
#import "NSDictionary+NSNullUtility.h"
#import "JsonUtils.h"
#import "DeviceCommand.h"


#define LINE_HIGHT 5

@interface LoginViewController ()

@end

@implementation LoginViewController{
    UILabel *lblUserName;
    UILabel *lblPassword;
    
    UITextField *txtUserName;
    UITextField *txtPassword;
    
    UIButton *btnLogin;
    UIButton *btnRegister;
    UIButton *btnFindPassword;
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
    
    if(btnFindPassword == nil) {
        btnFindPassword = [[UIButton alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 34, 146 / 2, 26)];
        btnFindPassword.center = CGPointMake(self.view.center.x - 50, btnFindPassword.center.y);
        btnFindPassword.titleLabel.font = [UIFont systemFontOfSize:14];
        [btnFindPassword setTitle:NSLocalizedString(@"find_password", @"") forState:UIControlStateNormal];
        btnFindPassword.titleLabel.textColor = [UIColor whiteColor];
        [self.view addSubview:btnFindPassword];
    }
    
    if(btnRegister == nil) {
        btnRegister = [[UIButton alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 34, 146 / 2, 26)];
        btnRegister.center = CGPointMake(self.view.center.x + 50, btnRegister.center.y);
        btnRegister.titleLabel.font = [UIFont systemFontOfSize:14];
        [btnRegister setTitle:NSLocalizedString(@"register_new_user", @"") forState:UIControlStateNormal];
        btnRegister.titleLabel.textColor = [UIColor whiteColor];
        [btnRegister addTarget:self action:@selector(showRegisterViewController) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnRegister];
    }
    
    UILabel *lblSeperator = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 10, 26)];
    lblSeperator.center = CGPointMake(self.view.center.x, btnRegister.center.y);
    lblSeperator.text = @"|";
    lblSeperator.textColor = [UIColor whiteColor];
    lblSeperator.textAlignment = NSTextAlignmentCenter;
    lblSeperator.backgroundColor = [UIColor clearColor];
    [self.view addSubview:lblSeperator];
    
    //
    txtUserName.text = @"";
    txtPassword.text = @"";
}

#pragma mark -
#pragma mark services

//need to be deleted in production, only used for debug or test
- (void)fastLogin {
    [[AlertView currentAlertView] dismissAlertView];
    [self.navigationController pushViewController:[[UnitsBindingViewController alloc] init] animated:YES];
}

- (void)login {
    //need to be deleted in production, only used for debug or test
    if([@"" isEqualToString:txtUserName.text]) {
        if([@"" isEqualToString:txtPassword.text]) {
            [[AlertView currentAlertView] setMessage:NSLocalizedString(@"please_wait", @"") forType:AlertViewTypeWaitting];
            [[AlertView currentAlertView] alertAutoDisappear:NO lockView:self.view];
            [NSTimer scheduledTimerWithTimeInterval:0.2f target:self selector:@selector(fastLogin) userInfo:nil repeats:NO];
            return;
        }
    }
    
    NSString *userName = [NSString trim:txtUserName.text];
    NSString *password = [NSString trim:txtPassword.text];
    
    if([NSString isBlank:userName]) {
        [[AlertView currentAlertView] setMessage:NSLocalizedString(@"username_not_blank", @"") forType:AlertViewTypeFailed];
        [[AlertView currentAlertView] alertAutoDisappear:YES lockView:nil];
        return;
    }
    
    if([NSString isBlank:password]) {
        [[AlertView currentAlertView] setMessage:NSLocalizedString(@"password_not_blank", @"") forType:AlertViewTypeFailed];
        [[AlertView currentAlertView] alertAutoDisappear:YES lockView:nil];
        return;
    }
    
    [[AlertView currentAlertView] setMessage:NSLocalizedString(@"please_wait", @"") forType:AlertViewTypeWaitting];
    [[AlertView currentAlertView] alertAutoDisappear:NO lockView:self.view];
    [[SMShared current].accountService loginWithAccount:userName password:password success:@selector(loginSuccess:) failed:@selector(loginFailed:) target:self callback:nil];
}

- (void)loginSuccess:(RestResponse *)resp {
    if(resp.statusCode == 200) {
        NSDictionary *json = [JsonUtils createDictionaryFromJson:resp.body];
        if(json != nil) {
            DeviceCommand *command = [[DeviceCommand alloc] initWithDictionary:json];
            if(command != nil && ![NSString isBlank:command.result]) {
                if([@"1" isEqualToString:command.result]) {
                    if(![NSString isBlank:command.security] && ![NSString isBlank:command.tcpAddress]) {
                        [SMShared current].settings.account = txtUserName.text;
                        [SMShared current].settings.secretKey = command.security;
                        [SMShared current].settings.tcpAddress = command.tcpAddress;
                        [SMShared current].settings.deviceCode = command.deviceCode;
                        [[SMShared current].settings saveSettings];
                        [[AlertView currentAlertView] dismissAlertView];
                        if([SMShared current].settings.anyUnitsBinding) {
                            [SMShared current].app.rootViewController.needLoadMainViewController = YES;
                            [self.navigationController popToRootViewControllerAnimated:NO];
                        } else {
                            [self.navigationController pushViewController:[[UnitsBindingViewController alloc] init] animated:YES];
                        }
                        return;
                    }
                } else if([@"-1" isEqualToString:command.result] || [@"-2" isEqualToString:command.result]) {
                    [[AlertView currentAlertView] setMessage:NSLocalizedString(@"name_or_pwd_error", @"") forType:AlertViewTypeFailed];
                    [[AlertView currentAlertView] delayDismissAlertView];
                    return;
                } else if([@"-3" isEqualToString:command.result] || [@"-4" isEqualToString:command.result]) {
                    [[AlertView currentAlertView] setMessage:NSLocalizedString(@"login_later", @"") forType:AlertViewTypeFailed];
                    [[AlertView currentAlertView] delayDismissAlertView];
                    return;
                }
            } 
        }
    }
    [self loginFailed:resp];
}

- (void)loginFailed:(RestResponse *)resp {
    if(abs(resp.statusCode) == 1001) {
        [[AlertView currentAlertView] setMessage:NSLocalizedString(@"request_timeout", @"") forType:AlertViewTypeFailed];
    } else {
        [[AlertView currentAlertView] setMessage:NSLocalizedString(@"unknow_error", @"") forType:AlertViewTypeFailed];
    }
    [[AlertView currentAlertView] delayDismissAlertView];
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
