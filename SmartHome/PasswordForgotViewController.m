//
//  PasswordForgotViewController.m
//  SmartHome
//
//  Created by Zhao yang on 9/13/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "PasswordForgotViewController.h"
#import "SMTextField.h"
#import "LongButton.h"

@interface PasswordForgotViewController ()

@end

@implementation PasswordForgotViewController {
    UITextField *txtPhoneNumber;
    UILabel *lblPhoneNumber;
    UIButton *btnSendPassword;
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

- (void)initUI {
    [super initUI];
    
    self.topbar.titleLabel.text = NSLocalizedString(@"find_password.title", @"");
    
    if(lblPhoneNumber == nil) {
        lblPhoneNumber = [[UILabel alloc] initWithFrame:CGRectMake(10, 60, 250, 20)];
        [lblPhoneNumber setText:NSLocalizedString(@"phone_for_receive_pwd", @"")];
        lblPhoneNumber.font = [UIFont systemFontOfSize:16];
        lblPhoneNumber.backgroundColor = [UIColor clearColor];
        lblPhoneNumber.textColor = [UIColor lightTextColor];
        [self.view addSubview:lblPhoneNumber];
    }
    
    if(txtPhoneNumber == nil) {
        txtPhoneNumber = [SMTextField textFieldWithPoint:CGPointMake(6, lblPhoneNumber.frame.origin.y + 30)];
        txtPhoneNumber.keyboardType = UIKeyboardTypeNumberPad;
        txtPhoneNumber.clearButtonMode = UITextFieldViewModeWhileEditing;
        txtPhoneNumber.delegate = self;
        [self.view addSubview:txtPhoneNumber];
    }
    
    if(btnSendPassword == nil) {
        btnSendPassword = [LongButton buttonWithPoint:CGPointMake(5, txtPhoneNumber.frame.origin.y +txtPhoneNumber.frame.size.height + 5)];
        [btnSendPassword setTitle:NSLocalizedString(@"send_password", @"") forState:UIControlStateNormal];
        [btnSendPassword addTarget:self action:@selector(sendPassword:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnSendPassword];
    }
    
    [txtPhoneNumber becomeFirstResponder];
}

#pragma mark -
#pragma mark services 

- (void)sendPassword:(id)sender {
    NSString *phoneNumber = [NSString trim:txtPhoneNumber.text];
    if([NSString isBlank:phoneNumber] || phoneNumber.length != 11) {
        [[SMShared current].accountService sendPasswordToMobile:phoneNumber success:@selector(sendPasswordSuccess:) failed:@selector(sendPasswordFailed:) target:self callback:nil];
        [[AlertView currentAlertView] setMessage:NSLocalizedString(@"phone_format_invalid", @"") forType:AlertViewTypeFailed];
        [[AlertView currentAlertView] alertAutoDisappear:YES lockView:self.view];
    }
    
    [[SMShared current].accountService sendPasswordToMobile:phoneNumber success:@selector(sendPasswordSuccess:) failed:@selector(sendPasswordFailed:) target:self callback:nil];
    [[AlertView currentAlertView] setMessage:NSLocalizedString(@"please_wait", @"") forType:AlertViewTypeWaitting];
    [[AlertView currentAlertView] alertAutoDisappear:NO lockView:self.view];
}

- (void)sendPasswordSuccess:(RestResponse *)resp {
    if(resp.statusCode == 200) {
        NSDictionary *json = [JsonUtils createDictionaryFromJson:resp.body];
        if(json != nil) {
            NSString *result = [json stringForKey:@"id"];
            if(result != nil) {
                if([@"1" isEqualToString:result]) {
                    [[AlertView currentAlertView] setMessage:NSLocalizedString(@"send_success", @"") forType:AlertViewTypeSuccess];
                    [[AlertView currentAlertView] delayDismissAlertView];
                    [self.navigationController popViewControllerAnimated:YES];
                    return;
                } else if([@"-1" isEqualToString:result]) {
                    [[AlertView currentAlertView] setMessage:NSLocalizedString(@"phone_format_invalid", @"") forType:AlertViewTypeFailed];
                    [[AlertView currentAlertView] delayDismissAlertView];
                    return;
                } else if([@"-2" isEqualToString:result]) {
                    [[AlertView currentAlertView] setMessage:NSLocalizedString(@"phone_not_exists", @"") forType:AlertViewTypeFailed];
                    [[AlertView currentAlertView] delayDismissAlertView];
                    return;
                } else if([@"-3" isEqualToString:result] || [@"-4" isEqualToString:result]) {
                    [[AlertView currentAlertView] setMessage:NSLocalizedString(@"delay_send", @"") forType:AlertViewTypeFailed];
                    [[AlertView currentAlertView] delayDismissAlertView];
                    return;
                } else if([@"-5" isEqualToString:result] || [@"-6" isEqualToString:result]) {
                    [[AlertView currentAlertView] setMessage:NSLocalizedString(@"send_failed", @"") forType:AlertViewTypeFailed];
                    [[AlertView currentAlertView] delayDismissAlertView];
                    return;
                }
            }
        }
    }
    [self sendPasswordFailed:resp];
}

- (void)sendPasswordFailed:(RestResponse *)resp {
    if(abs(resp.statusCode) == 1001) {
        [[AlertView currentAlertView] setMessage:NSLocalizedString(@"request_timeout", @"") forType:AlertViewTypeSuccess];
    } else {
        [[AlertView currentAlertView] setMessage:NSLocalizedString(@"unknow_error", @"") forType:AlertViewTypeSuccess];
    }
    [[AlertView currentAlertView] delayDismissAlertView];
}

#pragma mark -
#pragma mark text field delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return range.location < 11;
}

@end
