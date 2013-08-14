//
//  RegisterViewController.m
//  SmartHome
//
//  Created by Zhao yang on 8/5/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "RegisterViewController.h"
#import "ZBarScanningViewController.h"
#import "UIViewController+UIViewControllerExtension.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController{
    UITextField *phoneNumber;
    UITextField *verification;
    UIButton *sendButton;
    NSTimeInterval resendTimeInterval;
    NSString *accountPhone;
    @private NSString *verificationCode;

}
@synthesize xmlParser = _xmlParser;
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
    
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    [self registerTapGestureToResignKeyboard];
    
    UILabel *text = [[UILabel alloc] initWithFrame:CGRectMake(20, screenHeight/3, 130, 30)];
    [text setText:NSLocalizedString(@"phone.register", @"")];
    [text setBackgroundColor:[UIColor blueColor]];
    [self.view addSubview:text];
    
    phoneNumber = [[UITextField alloc] initWithFrame:CGRectMake(150, screenHeight/3, screenWidth-160, 30)];
    [phoneNumber setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:phoneNumber];
    phoneNumber.keyboardType = UIKeyboardTypePhonePad;
    
    sendButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    sendButton.center = self.view.center;
    sendButton.backgroundColor = [UIColor whiteColor];
    [sendButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [sendButton setTitle:NSLocalizedString(@"send.verificationCode", @"") forState:UIControlStateNormal];
    [sendButton addTarget:self action:@selector(sendVerificationCode) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:sendButton];
    
    UILabel *text2 = [[UILabel alloc] initWithFrame:CGRectMake(20, screenHeight/2+20, 100, 40)];
    [text2 setText:NSLocalizedString(@"verificationCode", @"")];
    [text setBackgroundColor:[UIColor blueColor]];
    [self.view addSubview:text];
    
    verification = [[UITextField alloc] initWithFrame:CGRectMake(120, screenHeight/2+50, 100, 40)];
    [verification setBackgroundColor:[UIColor whiteColor]];
    verification.keyboardType = UIKeyboardTypePhonePad;
    [self.view addSubview:verification];
    
    
    UIButton *okButton = [[UIButton alloc] initWithFrame:CGRectMake(120, screenHeight/2+100, 100, 40)];
    okButton.backgroundColor = [UIColor whiteColor];
    [okButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [okButton setTitle:NSLocalizedString(@"OK", @"") forState:UIControlStateNormal];
    [okButton addTarget:self action:@selector(checkVerificationCode) forControlEvents:UIControlEventTouchDown];
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
-(void) send{
    verificationCode = [NSString stringWithFormat:@"%i",[self randomIntBetween:100000 andLargerInt:999999]];
    SmsService *smsService = self.smsService;
    accountPhone = phoneNumber.text;
    [smsService sendMessage:verificationCode for: accountPhone success:@selector(handleSendSuccess:) failed:@selector(handleSendfailed:) target:self callback:nil];
}
-(void) checkVerificationCode{
    
    NSString *input = verification.text;
    NSLog(@"verificationCode=%@ and input=%@",verificationCode,input);
    if(verificationCode == NULL){
        return ;
    }
    
    if ([input isEqualToString:verificationCode]) {
        
        [self.navigationController pushViewController:[[ZBarScanningViewController alloc] init] animated:YES];
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
       NSData *data = resp.body;
        GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:data options:0 error:NULL];
        NSArray *nodes =[doc nodesForXPath:@"//Result" error:nil];
        NSString *result = nil;
        for (GDataXMLElement *element in nodes) {
           
            result = element.stringValue;
            
        }
        if([result isEqualToString:@"1"]){
            NSLog(@"ok");
            
        }else if([@"" isEqualToString:result]){
            NSLog(@"wrong");
        }
        
    
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
