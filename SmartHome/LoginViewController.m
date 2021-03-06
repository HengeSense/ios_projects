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
#import "PasswordForgotViewController.h"
#import "UnitsBindingViewController.h"
#import "VerificationCodeSendViewController.h"
#import "UIColor+ExtentionForHexString.h"
#import "JsonUtils.h"
#import "UIDevice+Extension.h"
#import "DeviceCommand.h"
#import "ScenePlanFileManager.h"
#import "SceneManagerService.h"

#define LINE_HIGHT 5

@interface LoginViewController ()

@end

@implementation LoginViewController{
    UIImageView *imgLogo;
    
    UILabel *lblUserName;
    UILabel *lblPassword;
    
    UITextField *txtUserName;
    UITextField *txtPassword;
    
    UIButton *btnLogin;
    UIButton *btnRegister;
    UIButton *btnFindPassword;
}

@synthesize hasLogin;

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

- (void)viewWillAppear:(BOOL)animated {
    //
    txtUserName.text = [NSString emptyString];
    txtPassword.text = [NSString emptyString];
}

- (void)initUI {
    [super initUI];
    
    [self registerTapGestureToResignKeyboard];
    
    if(imgLogo == nil) {
        imgLogo = [[UIImageView alloc] initWithFrame:CGRectMake(0, 40, 262/2, 114/2)];
        imgLogo.center = CGPointMake(self.view.center.x, imgLogo.center.y);
        imgLogo.image = [UIImage imageNamed:@"logo2.png"];
        [self.view addSubview:imgLogo];
    }
        
    if(lblUserName == nil) {
        lblUserName = [[UILabel alloc] initWithFrame:CGRectMake(10, [UIDevice systemVersionIsMoreThanOrEuqal7] ? 108 : 88, 100, 20)];
        lblUserName.backgroundColor = [UIColor clearColor];
        lblUserName.text = [NSString stringWithFormat:@"%@:", NSLocalizedString(@"username", @"")];
        lblUserName.font= [UIFont systemFontOfSize:16];
        lblUserName.textColor = [UIColor lightTextColor];
        [self.view addSubview:lblUserName];
    }
    
    if(txtUserName == nil) {
        txtUserName = [SMTextField textFieldWithPoint:CGPointMake(5, (lblUserName.frame.origin.y + LINE_HIGHT + 20))];
        txtUserName.keyboardType = UIKeyboardTypeNumberPad;
        txtUserName.returnKeyType = UIReturnKeyNext;
        txtUserName.clearButtonMode = UITextFieldViewModeWhileEditing;
        txtUserName.delegate = self;
        [self.view addSubview:txtUserName];
    }
    
    if(lblPassword == nil) {
        lblPassword = [[UILabel alloc] initWithFrame:CGRectMake(10, (txtUserName.frame.origin.y + txtUserName.bounds.size.height + LINE_HIGHT), 100, 20)];
        lblPassword.text = [NSString stringWithFormat:@"%@:", NSLocalizedString(@"password", @"")];
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
        [btnFindPassword addTarget:self action:@selector(showFindPasswordViewController) forControlEvents:UIControlEventTouchUpInside];
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
}

#pragma mark -
#pragma mark services

- (void)login {
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
    
    [[[AccountService alloc] init] loginWithAccount:userName password:password success:@selector(loginSuccess:) failed:@selector(loginFailed:) target:self callback:nil];
}

- (void)loginSuccess:(RestResponse *)resp {
    if(resp.statusCode == 200) {
        NSDictionary *json = [JsonUtils createDictionaryFromJson:resp.body];
        if(json != nil) {
            DeviceCommand *command = [[DeviceCommand alloc] initWithDictionary:json];
            if(command != nil && ![NSString isBlank:command.result]) {
                if([@"1" isEqualToString:command.result]) {
                    // login success
                    if(![NSString isBlank:command.security] && ![NSString isBlank:command.tcpAddress]) {
                        // save account info
                        [SMShared current].settings.account = txtUserName.text;
                        [SMShared current].settings.secretKey = command.security;
                        [SMShared current].settings.tcpAddress = command.tcpAddress;
                        [SMShared current].settings.deviceCode = command.deviceCode;
                        [SMShared current].settings.restAddress = command.restAddress;
                        [[SMShared current].settings saveSettings];
                        
                        // start service
                        if(![SMShared current].deliveryService.isService) {
                            [[SMShared current].deliveryService startService];
                        }
                        
                        txtPassword.text = [NSString emptyString];
                        [[SMShared current].app registerForRemoteNotifications];
                        
                        // get scene plan
                        SceneManagerService *sceneService = [[SceneManagerService alloc] init];
                        [sceneService getAllScenePlans:@selector(getScenePlansSuccess:) error:@selector(getScenePlansFailed:) target:self callback:nil];
                        
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

- (void)toMainPage {
    if([[SMShared current].memory hasUnit]) {
        [self.navigationController pushViewController:[[MainViewController alloc] init] animated:NO];
    } else {
        [self.navigationController pushViewController:[[UnitsBindingViewController alloc] init] animated:YES];
    }
}

- (void)loginFailed:(RestResponse *)resp {
    if(abs(resp.statusCode) == 1001) {
        [[AlertView currentAlertView] setMessage:NSLocalizedString(@"request_timeout", @"") forType:AlertViewTypeFailed];
    } else {
        [[AlertView currentAlertView] setMessage:NSLocalizedString(@"unknow_error", @"") forType:AlertViewTypeFailed];
    }
    [[AlertView currentAlertView] delayDismissAlertView];
}

- (void)showRegisterViewController {
    [self.navigationController pushViewController:[[VerificationCodeSendViewController alloc] init] animated:YES];
}

- (void)showFindPasswordViewController {
    [self.navigationController pushViewController:[[PasswordForgotViewController alloc] init] animated:YES];
}

#pragma mark -
#pragma mark Scene plan rest call back

- (void)getScenePlansSuccess:(RestResponse *)resp {
    if(resp.statusCode == 200) {
        NSDictionary *json = [JsonUtils createDictionaryFromJson:resp.body];
        if(json != nil) {
            if([json integerForKey:@"i"] == 1) {
//                NSString *str = [[NSString alloc] initWithData:resp.body encoding:NSUTF8StringEncoding];
//                NSLog(@"%@", str);
                NSArray *plans = [json arrayForKey:@"m"];
                [[ScenePlanFileManager fileManager] deleteAllScenePlan];
                for(int i=0; i<plans.count; i++) {
                    ScenePlan *plan = [[ScenePlan alloc] initWithJson:[plans objectAtIndex:i]];
                    [[ScenePlanFileManager fileManager] saveScenePlan:plan];
                }
                [[AlertView currentAlertView] setMessage:NSLocalizedString(@"login_success", @"") forType:AlertViewTypeSuccess];
                [[AlertView currentAlertView] delayDismissAlertView];
                [self toMainPage];
            }
            return;
        }
    }
    [self getScenePlansFailed:resp];
}

- (void)getScenePlansFailed:(RestResponse *)resp {
#ifdef DEBUG
    NSLog(@"[LOGIN VIEW CONTROLLER] Get Scene Plan Failed . [Code %d]", resp.statusCode);
#endif
    [[AlertView currentAlertView] setMessage:NSLocalizedString(@"login_success", @"") forType:AlertViewTypeSuccess];
    [[AlertView currentAlertView] delayDismissAlertView];
    [self toMainPage];
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

#pragma mark -
#pragma mark navigation view controller delegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if(viewController == self && self.hasLogin) {
        self.hasLogin = NO;
        [self.navigationController pushViewController:[[MainViewController alloc] init] animated:NO];
    }
}

@end
