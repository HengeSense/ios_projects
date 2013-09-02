//
//  VerificationCodeValidationViewController.m
//  SmartHome
//
//  Created by Zhao yang on 8/23/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "VerificationCodeValidationViewController.h"
#import "NSDictionary+NSNullUtility.h"
#import "LongButton.h"
#import "MainViewController.h"
#import "UnitsBindingViewController.h"
#import "NSString+StringUtils.h"
#import "SMTextField.h"
#import "JsonUtils.h"

@interface VerificationCodeValidationViewController ()

@end

@implementation VerificationCodeValidationViewController {
    UILabel *lblVerificationCode;
    UITextField *txtVerificationCode;
    NSTimer *countDownTimer;
    UIButton *btnResend;
    UIButton *btnNext;
    UILabel *lblCountDown;
}

@synthesize phoneNumberToValidation;
@synthesize countDown;

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

- (void)initDefaults {
    [super initDefaults];
}

- (void)initUI {
    [super initUI];
    
    self.topbar.titleLabel.text = NSLocalizedString(@"verification_validation.title", @"");
    
    if(lblVerificationCode == nil) {
        lblVerificationCode = [[UILabel alloc] initWithFrame:CGRectMake(10, 60, 250, 20)];
        [lblVerificationCode setText:NSLocalizedString(@"verification_code_enter.tips", @"")];
        lblVerificationCode.font = [UIFont systemFontOfSize:16];
        lblVerificationCode.backgroundColor = [UIColor clearColor];
        lblVerificationCode.textColor = [UIColor lightTextColor];
        [self.view addSubview:lblVerificationCode];
    }
    
    if(txtVerificationCode == nil) {
        txtVerificationCode = [SMTextField textFieldWithPoint:CGPointMake(6, lblVerificationCode.frame.origin.y + 30)];
        txtVerificationCode.keyboardType = UIKeyboardTypeNumberPad;
        txtVerificationCode.clearButtonMode = UITextFieldViewModeWhileEditing;
        txtVerificationCode.delegate = self;
        [self.view addSubview:txtVerificationCode];
    }
    
    if(btnNext == nil) {
        btnNext = [LongButton buttonWithPoint:CGPointMake(5, txtVerificationCode.frame.origin.y + txtVerificationCode.frame.size.height + 5)];
        [btnNext setTitle:NSLocalizedString(@"next_step", @"") forState:UIControlStateNormal];
        [btnNext addTarget:self action:@selector(submitVerificationCode) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnNext];
    }
    
    if(btnResend == nil) {
        btnResend = [[UIButton alloc] initWithFrame:CGRectMake(0, btnNext.frame.origin.y + btnNext.frame.size.height + 15, 257/2, 48/2)];
        btnResend.center = CGPointMake(self.view.center.x, btnResend.center.y);
        [btnResend setBackgroundImage:[UIImage imageNamed:@"btn_dark_small.png"] forState:UIControlStateNormal];
        [btnResend setBackgroundImage:[UIImage imageNamed:@"btn_dark_small.png"] forState:UIControlStateHighlighted];
//        [btnResend setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateDisabled];
        [btnResend addTarget:self action:@selector(resendVerificationCode) forControlEvents:UIControlEventTouchUpInside];
        btnResend.titleLabel.font = [UIFont systemFontOfSize:12.f];
//btnResend.titleLabel.s
        
        [btnResend setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnResend setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
        [btnResend setTitle:NSLocalizedString(@"resend_verification_code", @"") forState:UIControlStateNormal];
        [self.view addSubview:btnResend];
    }
    
    if(lblCountDown == nil) {
        lblCountDown = [[UILabel alloc] initWithFrame:CGRectMake(btnResend.frame.origin.x + btnResend.frame.size.width + 10, btnNext.frame.origin.y + btnNext.frame.size.height + 15, 50, 21)];
        lblCountDown.font = [UIFont systemFontOfSize:14.f];
        lblCountDown.textAlignment = NSTextAlignmentLeft;
        lblCountDown.textColor = [UIColor lightTextColor];
        lblCountDown.backgroundColor = [UIColor clearColor];
        lblCountDown.text = [NSString emptyString];
        [self.view addSubview:lblCountDown];
    }
    
    [txtVerificationCode becomeFirstResponder];
    
    [self startCountDown];
}

#pragma mark -
#pragma mark service

- (void)startCountDown {
    if(self.countDown <= 1) {
        lblCountDown.text = [NSString emptyString];
        btnResend.enabled = YES;
    } else {
        btnResend.enabled = NO;
        countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(countDownTimer) userInfo:nil repeats:YES];
    }
}

- (void)countDownTimer {
    if(self.countDown > 1) {
        self.countDown--;
        lblCountDown.text = [NSString stringWithFormat:@"%d", self.countDown];
    } else {
        if(countDownTimer != nil) {
            [countDownTimer invalidate];
        }
        lblCountDown.text = [NSString emptyString];
        btnResend.enabled = YES;
    }
}

- (void)resendVerificationCode {
    [[AlertView currentAlertView] setMessage:NSLocalizedString(@"please_wait", @"") forType:AlertViewTypeWaitting];
    [[AlertView currentAlertView] alertAutoDisappear:NO lockView:self.view];
    [[SMShared current].accountService sendVerificationCodeFor:self.phoneNumberToValidation success:@selector(verificationCodeSendSuccess:) failed:@selector(verificationCodeSendError:) target:self callback:nil];
}

- (void)verificationCodeSendSuccess:(RestResponse *)resp {
    if(resp.statusCode == 200) {
        NSDictionary *json = [JsonUtils createDictionaryFromJson:resp.body];
        if(json != nil) {
            NSString *_id_ = [json notNSNullObjectForKey:@"id"];
            if(_id_ != nil) {
                if([@"1" isEqualToString:_id_]) {
                    [[AlertView currentAlertView] setMessage:NSLocalizedString(@"send_success", @"") forType:AlertViewTypeSuccess];
                    [[AlertView currentAlertView] delayDismissAlertView];
                    self.countDown = 60;
                    lblCountDown.text = [NSString stringWithFormat:@"%d", self.countDown];
                    [self startCountDown];
                    return;
                }
            }
        }
    }
    [self verificationCodeSendError:resp];
}

- (void)verificationCodeSendError:(RestResponse *)resp {
    if(resp.statusCode == 1001) {
        [[AlertView currentAlertView] setMessage:NSLocalizedString(@"request_timeout", @"") forType:AlertViewTypeSuccess];
    } else {
        [[AlertView currentAlertView] setMessage:NSLocalizedString(@"unknow_error", @"") forType:AlertViewTypeSuccess];
    }
    [[AlertView currentAlertView] delayDismissAlertView];
}

- (void)submitVerificationCode {
    if([NSString isBlank:txtVerificationCode.text] || txtVerificationCode.text.length != 6) {
        [[AlertView currentAlertView] setMessage:NSLocalizedString(@"verification_code_error", @"") forType:AlertViewTypeFailed];
        [[AlertView currentAlertView] alertAutoDisappear:YES lockView:self.view];
        return;
    }
    [[AlertView currentAlertView] setMessage:NSLocalizedString(@"please_wait", @"") forType:AlertViewTypeWaitting];
    [[AlertView currentAlertView] alertAutoDisappear:NO lockView:self.view];
    [[SMShared current].accountService registerWithPhoneNumber:self.phoneNumberToValidation checkCode:txtVerificationCode.text success:@selector(registerSuccessfully:) failed:@selector(registerFailed:) target:self callback:nil];
}

- (void)registerSuccessfully:(RestResponse *)resp {    
    if(resp.statusCode == 200) {
        NSDictionary *json = [JsonUtils createDictionaryFromJson:resp.body];
        if(json != nil) {
            DeviceCommand *command = [[DeviceCommand alloc] initWithDictionary:json];
            if(command != nil && ![NSString isBlank:command.result]) {
                if([@"1" isEqualToString:command.result]) {
                    if(![NSString isBlank:command.security] && ![NSString isBlank:command.tcpAddress]) {
                        [[AlertView currentAlertView] dismissAlertView];
                        [SMShared current].settings.secretKey = command.security;
                        [SMShared current].settings.account = self.phoneNumberToValidation;
                        [SMShared current].settings.tcpAddress = command.tcpAddress;
                        [SMShared current].settings.deviceCode = command.deviceCode;
                        [[SMShared current].settings saveSettings];
                        if([SMShared current].settings.anyUnitsBinding) {
                            [SMShared current].app.rootViewController.needLoadMainViewController = YES;
                            [self.navigationController popToRootViewControllerAnimated:NO];
                        } else {
                            [self.navigationController pushViewController:[[UnitsBindingViewController alloc] init] animated:YES];
                        }
                        return;
                    }
                } else if([@"-1" isEqualToString:command.result]) {
                    [[AlertView currentAlertView] setMessage:NSLocalizedString(@"none_verification_code", @"") forType:AlertViewTypeFailed];
                    [[AlertView currentAlertView] delayDismissAlertView];
                    return;
                } else if([@"-2" isEqualToString:command.result]) {
                    [[AlertView currentAlertView] setMessage:NSLocalizedString(@"verification_code_expire", @"") forType:AlertViewTypeFailed];
                    [[AlertView currentAlertView] delayDismissAlertView];
                    return;
                } else if([@"-3" isEqualToString:command.result]) {
                    [[AlertView currentAlertView] setMessage:NSLocalizedString(@"verification_code_error", @"") forType:AlertViewTypeFailed];
                    [[AlertView currentAlertView] delayDismissAlertView];
                    return;
                }
            }
        }
    }
    [self registerFailed:resp];
}

- (void)registerFailed:(RestResponse *)resp {
    if(abs(resp.statusCode) == 1001) {
        [[AlertView currentAlertView] setMessage:NSLocalizedString(@"request_timeout", @"") forType:AlertViewTypeFailed];
    } else {
        [[AlertView currentAlertView] setMessage:NSLocalizedString(@"unknow_error", @"") forType:AlertViewTypeFailed];
    }
    [[AlertView currentAlertView] delayDismissAlertView];
}

#pragma mark -
#pragma mark text field delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return range.location < 6;
}

@end
