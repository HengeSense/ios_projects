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
    
    /*
    UILabel *text2 = [[UILabel alloc] initWithFrame:CGRectMake(20,sendButton.frame.origin.y+sendButton.frame.size.height+LINE_HEIGHT, 150, 20)];
    [text2 setText:NSLocalizedString(@"verification_code", @"")];
    [text2 setBackgroundColor:[UIColor clearColor]];
    text2.font = [UIFont systemFontOfSize:12];
    text2.textColor = [UIColor whiteColor];
    [self.view addSubview:text2];
    
    verification = [SMTextField textFieldWithPoint:CGPointMake(10, text2.frame.size.height+text2.frame.origin.y+LINE_HEIGHT)];
    [self.view addSubview:verification];
    verification.keyboardType = UIKeyboardTypeNamePhonePad;
    
    UIButton *okButton = [LongButton buttonWithPoint:CGPointMake(10, verification.frame.size.height+verification.frame.origin.y+LINE_HEIGHT)];
    [okButton setTitle:NSLocalizedString(@"done", @"") forState:UIControlStateNormal];
    [okButton addTarget:self action:@selector(checkVerificationCode) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:okButton];
    
    resendTimeInterval = 60;*/
}
/*
- (void)sendVerificationCode {
    [sendButton setEnabled:NO];
    sendTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(sendTimeCountDown) userInfo:nil repeats:YES];
    [self send];
    
}*/

/*
-(void) sendTimeCountDown{
    if((long)resendTimeInterval>0){
       resendTimeInterval = resendTimeInterval-1;
        [sendButton setTitle:[NSString stringWithFormat:@"%li",(long)resendTimeInterval] forState:UIControlStateNormal];
    }else{
        [sendButton setTitle:@"resend" forState:UIControlStateNormal];
        [sendTimer invalidate];
        [sendButton setEnabled:YES];
        resendTimeInterval = 60;
    }
}

*/

#pragma mark -
#pragma mark service

- (void)sendVerificationCode {
    [self.accountService sendVerificationCodeFor:txtPhoneNumber.text success:@selector(verificationCodeSendSuccess:) failed:@selector(verificationCodeSendError:) target:self callback:nil];
}

- (void)verificationCodeSendSuccess:(RestResponse *)resp {
    NSLog(@"%d", resp.statusCode);
    if(resp.statusCode == 200) {
        NSString *str=       [[NSString alloc] initWithData:resp.body encoding:NSUTF8StringEncoding];
        NSLog(str);
        [self.navigationController pushViewController:[self nextViewController] animated:YES];
    } else {
        [self verificationCodeSendError:resp];
    }
}

- (VerificationCodeValidationViewController *)nextViewController {
    if(verificationCodeValidationViewController == nil) {
        verificationCodeValidationViewController = [[VerificationCodeValidationViewController alloc] init];
    }
    return verificationCodeValidationViewController;
}

- (void)verificationCodeSendError:(RestResponse *)resp {
    NSLog(@"error %d", resp.statusCode);
}

#pragma mark -
#pragma mark text field delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return range.location < 11;
}

/*
-(void) checkVerificationCode{
    
    NSString *input = verification.text;
    NSLog(@"verificationCode=%@ and input=%@",verificationCode,input);
    if(verificationCode == NULL){
        return ;
    }
    
    if ([input isEqualToString:verificationCode]) {
        
        [self.navigationController pushViewController:[[UnitsBindingViewController alloc] init] animated:YES];
        self.settings.isValid = YES;
        self.settings.accountPhone = accountPhone;
        [self.settings saveSettings];
    }else{
        UIAlertView *checkAlert = [[UIAlertView alloc] initWithTitle:@"error" message:@"check.verification.code.error" delegate:nil cancelButtonTitle:NSLocalizedString(@"retry", @"") otherButtonTitles:nil];
        [checkAlert show];
    }
}
*/




/*
- (int)randomIntBetween:(int)num1 andLargerInt:(int)num2 {
    int startVal = num1 * 10000;
    int endVal = num2 * 10000;
    int randomValue = startVal + (arc4random() % (endVal - startVal));
    return randomValue /10000;
}*/

@end
