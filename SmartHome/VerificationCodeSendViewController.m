//
//  VerificationCodeSendViewController.m
//  SmartHome
//
//  Created by Zhao yang on 8/5/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "VerificationCodeSendViewController.h"
#import "SMTextField.h"
#import "LongButton.h"
#import "UIColor+ExtentionForHexString.h"

#define LINE_HEIGHT 5

@interface VerificationCodeSendViewController ()

@end

@implementation VerificationCodeSendViewController{
    UITextField *phoneNumber;
    UITextField *verification;
    UIButton *sendButton;
    NSTimeInterval resendTimeInterval;
    NSString *accountPhone;
    @private NSString *verificationCode;

}

@synthesize sendTimer;


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
    
    [self registerTapGestureToResignKeyboard];
    
    UILabel *text = [[UILabel alloc] initWithFrame:CGRectMake(20, 60, 100, 20)];
    [text setText:NSLocalizedString(@"phone_number_register", @"")];
    text.font = [UIFont systemFontOfSize:12];
    text.backgroundColor = [UIColor clearColor];
    text.textColor = [UIColor whiteColor];
    [self.view addSubview:text];
    
    phoneNumber = [SMTextField textFieldWithPoint:CGPointMake(10, text.frame.origin.y+20+LINE_HEIGHT)];
    [self.view addSubview:phoneNumber];
    phoneNumber.keyboardType = UIKeyboardTypePhonePad;
    
    sendButton = [LongButton buttonWithPoint:CGPointMake(10, phoneNumber.frame.origin.y+phoneNumber.frame.size.height+LINE_HEIGHT)];
    [sendButton setTitle:NSLocalizedString(@"get_verification_code", @"") forState:UIControlStateNormal];
    [sendButton addTarget:self action:@selector(sendVerificationCode) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sendButton];
    
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
    
    resendTimeInterval = 60;
}

- (void)sendVerificationCode {
    [sendButton setEnabled:NO];
    sendTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(sendTimeCountDown) userInfo:nil repeats:YES];
    [self send];
    
}
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

-(void)send{
    [self.accountService sendVerificationCodeFor:phoneNumber.text success:@selector(handleSendSuccess:) failed:@selector(handleSendfailed:) target:self callback:nil];
}

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
-(void) handleSendSuccess:(RestResponse *) resp{

    NSLog(@"%d", resp.statusCode);
    if(resp.statusCode == 200) {
 NSString *str=       [[NSString alloc] initWithData:resp.body encoding:NSUTF8StringEncoding];
        NSLog(str);
        
    
    } else {
        [self handleSendfailed:resp];
    }
}
-(void) handleSendfailed:(RestResponse *) resp{
        NSLog(@"error %d", resp.statusCode);
         
}
- (int)randomIntBetween:(int)num1 andLargerInt:(int)num2 {
    int startVal = num1 * 10000;
    int endVal = num2 * 10000;
    int randomValue = startVal + (arc4random() % (endVal - startVal));
    return randomValue /10000;
}

@end
