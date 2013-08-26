//
//  VerificationCodeValidationViewController.m
//  SmartHome
//
//  Created by Zhao yang on 8/23/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "VerificationCodeValidationViewController.h"
#import "LongButton.h"
#import "SMTextField.h"

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
        btnResend = [[UIButton alloc] initWithFrame:CGRectMake(0, btnNext.frame.origin.y + btnNext.frame.size.height + 15, 120, 21)];
        btnResend.center = CGPointMake(self.view.center.x, btnResend.center.y);
//        [btnResend setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
//        [btnResend setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateHighlighted];
//        [btnResend setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateDisabled];
        [btnResend addTarget:self action:@selector(resendVerificationCode) forControlEvents:UIControlEventTouchUpInside];
        btnResend.titleLabel.font = [UIFont systemFontOfSize:14.f];
        [btnResend setTitle:NSLocalizedString(@"resend_verification_code", @"") forState:UIControlStateNormal];
        [self.view addSubview:btnResend];
    }
    
    if(lblCountDown == nil) {
        lblCountDown = [[UILabel alloc] initWithFrame:CGRectMake(btnResend.frame.origin.x + btnResend.frame.size.width + 10, btnNext.frame.origin.y + btnNext.frame.size.height + 14, 20, 21)];
        lblCountDown.font = [UIFont systemFontOfSize:14.f];
        lblCountDown.textAlignment = NSTextAlignmentCenter;
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
    if(countDown <= 2) {
        lblCountDown.text = [NSString emptyString];
        btnResend.enabled = YES;
    } else {
        btnResend.enabled = NO;
        countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(countDownTimer) userInfo:nil repeats:YES];
    }
}

- (void)countDownTimer {
    if(countDown > 1) {
        countDown--;
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
    NSLog(@"resend");
    
    //if success
    self.countDown = 60;
    lblCountDown.text = [NSString stringWithFormat:@"%d", self.countDown];
    [self startCountDown];
}

- (void)submitVerificationCode {

}

#pragma mark -
#pragma mark text field delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return range.location < 6;
}

@end
