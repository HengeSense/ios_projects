//
//  VerificationCodeSendViewController.m
//  SmartHome
//
//  Created by Zhao yang on 8/5/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "VerificationCodeSendViewController.h"
#import "VerificationCodeValidationViewController.h"
#import "SMTextField.h"
#import "LongButton.h"
#import "JsonUtils.h"
#import "NSDictionary+NSNullUtility.h"


@interface VerificationCodeSendViewController ()

@end

@implementation VerificationCodeSendViewController{
    UITextField *txtPhoneNumber;
    UILabel *lblPhoneNumber;
    UIButton *btnVerificationCodeSender;
    VerificationCodeValidationViewController *verificationCodeValidationViewController;
    
    UITextField *verification;

    NSTimeInterval resendTimeInterval;
    NSString *accountPhone;
    @private NSString *verificationCode;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
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
    // Dispose of any resources that can be recreated.
}

- (void)initUI {
    [super initUI];
    
    self.topbar.titleLabel.text = NSLocalizedString(@"verification_code_send.title", @"");
    
    if(lblPhoneNumber == nil) {
        lblPhoneNumber = [[UILabel alloc] initWithFrame:CGRectMake(10, 60, 250, 20)];
        [lblPhoneNumber setText:NSLocalizedString(@"phone_number_register", @"")];
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
    
    if(btnVerificationCodeSender == nil) {
        btnVerificationCodeSender = [LongButton buttonWithPoint:CGPointMake(5, txtPhoneNumber.frame.origin.y +txtPhoneNumber.frame.size.height + 5)];
        [btnVerificationCodeSender setTitle:NSLocalizedString(@"next_step", @"") forState:UIControlStateNormal];
        [btnVerificationCodeSender addTarget:self action:@selector(sendVerificationCode) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnVerificationCodeSender];
    }
    
    [txtPhoneNumber becomeFirstResponder];
}

#pragma mark -
#pragma mark service

- (void)sendVerificationCode {
    
//    VerificationCodeValidationViewController *cc = [self nextViewController];
//    cc.phoneNumberToValidation = @"18692251910";
//    cc.countDown = 20;
//    [self.navigationController pushViewController:cc animated:YES];
//    
//    
//    return;
    
    [self.accountService sendVerificationCodeFor:txtPhoneNumber.text success:@selector(verificationCodeSendSuccess:) failed:@selector(verificationCodeSendError:) target:self callback:nil];
}

- (void)verificationCodeSendSuccess:(RestResponse *)resp {
    NSLog(@"%d", resp.statusCode);
    if(resp.statusCode == 200) {
        NSString *str=       [[NSString alloc] initWithData:resp.body encoding:NSUTF8StringEncoding];
        NSLog(str);
        
//        NSDictionary *json = [JsonUtils createDictionaryFromJson:resp.body];
//        if(json != nil) {
//            NSString *_id_ = [json notNSNullObjectForKey:@"id"];
//            if(_id_ != nil) {
//                if([@"1" isEqualToString:_id_]) {
//                    [self.navigationController pushViewController:[self nextViewController] animated:YES];
//                    return;
//                } else if([@"-3" isEqualToString:_id_] || [@"-4" isEqualToString:_id_]) {
//                    
//                } else if([@"-1" isEqualToString:_id_]) {
//                    
//                } else if([@"-2" isEqualToString:_id_]) {
//                    
//                } else {
//                    
//                }
//            }
//        }
        
        
        //error
        
    } else {
        [self verificationCodeSendError:resp];
    }
}

- (VerificationCodeValidationViewController *)nextViewController {
    return [[VerificationCodeValidationViewController alloc] init];
}

- (void)verificationCodeSendError:(RestResponse *)resp {
    NSLog(@"error %d", resp.statusCode);
}

#pragma mark -
#pragma mark text field delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return range.location < 11;
}

@end
