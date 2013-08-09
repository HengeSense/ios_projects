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
    [self initUI];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initUI {
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    [self registerTapGestureToResignKeyboard];
    
    self.view.backgroundColor = [UIColor blueColor];
    UILabel *text = [[UILabel alloc] initWithFrame:CGRectMake(20, screenHeight/3, 100, 40)];
    [text setText:NSLocalizedString(@"phone.register", @"")];
    [text setBackgroundColor:[UIColor blueColor]];
    [self.view addSubview:text];
    
    phoneNumber = [[UITextField alloc] initWithFrame:CGRectMake(120, screenHeight/3, screenWidth-100, 40)];
    [phoneNumber setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:phoneNumber];
    
    sendButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 64)];
    sendButton.center = self.view.center;
    [sendButton setTitle:NSLocalizedString(@"send.verificationCode", @"") forState:UIControlStateNormal];
    [sendButton addTarget:self action:@selector(sendVerificationCode) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:sendButton];
    
    UILabel *text2 = [[UILabel alloc] initWithFrame:CGRectMake(20, screenHeight/2+20, 100, 40)];
    [text2 setText:NSLocalizedString(@"verificationCode", @"")];
    [text setBackgroundColor:[UIColor blueColor]];
    [self.view addSubview:text];
    
    verification = [[UITextField alloc] initWithFrame:CGRectMake(120, screenHeight/2+20, 100, 40)];
    [verification setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:verification];
    
    
    UIButton *okButton = [[UIButton alloc] initWithFrame:CGRectMake(screenWidth/2, screenHeight/2+40, 100, 64)];
    [okButton setTitle:NSLocalizedString(@"OK", @"") forState:UIControlStateNormal];
    [okButton addTarget:self action:@selector(sendVerificationCode) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:okButton];
    
    resendTimeInterval = 60;
}

- (void)sendVerificationCode {
    [sendButton setEnabled:NO];
    sendTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(sendTimeCountDown) userInfo:nil repeats:YES];
    [self send];
    
}
-(void) sendTimeCountDown{
    if(resendTimeInterval>0){
        [sendButton setTitle:[NSString stringWithFormat:@"%li",(long)resendTimeInterval-1] forState:UIControlStateNormal];
    }else{
        [sendButton setEnabled:YES];
    }
}
-(void) send{
    verificationCode = [NSString stringWithFormat:@"%i",[self randomIntBetween:100000 andLargerInt:999999]];
    SmsService *smsService = self.app.smsService;
    [smsService sendMessage:verificationCode for: phoneNumber.text success:@selector(handleSendSuccess:) failed:@selector(handleSendfailed:) target:self callback:nil];
}
-(void) handleSendSuccess:(RestResponse *) resp{
    if(resp.statusCode == 200){
        NSData *data = resp.body;
        GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:data options:0 error:NULL];
        NSString *result = [[doc rootElement] attributeForName:@"Result"].stringValue;
        if([result isEqualToString:@"1"]){
            [self.sendTimer invalidate];
            
        }else{
            
        }
        
    }
}
-(void) handleSendfailed:(RestResponse *) resp{
         
}
- (int)randomIntBetween:(int)num1 andLargerInt:(int)num2 {
    int startVal = num1 * 10000;
    int endVal = num2 * 10000;
    int randomValue = startVal + (arc4random() % (endVal - startVal));
    return randomValue /10000;
}

@end
