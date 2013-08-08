//
//  RegisterViewController.m
//  SmartHome
//
//  Created by Zhao yang on 8/5/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "RegisterViewController.h"
#import "UIViewController+UIViewControllerExtension.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController{
    UITextField *phoneNumber;
@private NSString *un ;
@private NSString *pwd;
@private NSString *urlAsString;
@private NSString *mobile;
@private NSString *verificationCode;
}
@synthesize xmlParser = _xmlParser;
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
    [self initUI];
   

    
}
-(void) initUI{
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    self.view.backgroundColor = [UIColor blueColor];
    UILabel *text = [[UILabel alloc] initWithFrame:CGRectMake(20, screenHeight/3, 100, 40)];
    [text setText:NSLocalizedString(@"手机号注册", @"")];
    [text setBackgroundColor:[UIColor blueColor]];
    [self.view addSubview:text];
    
    phoneNumber = [[UITextField alloc] initWithFrame:CGRectMake(120, screenHeight/3, screenWidth-100, 40)];
    [phoneNumber setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:phoneNumber];
    
    UIButton *OKButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 64)];
    OKButton.center = self.view.center;
    [OKButton setTitle:NSLocalizedString(@"确认", @"") forState:UIControlStateNormal];
    [OKButton addTarget:self action:@selector(sendVerificationCode) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:OKButton];
    
    
}
-(void)sendVerificationCode{
    un = @"ctyswse-27";
    pwd = @"b3d2dd";
    urlAsString = @"http://si.800617.com:4400/SendLenSms.aspx";
    mobile = phoneNumber.text;
    verificationCode = [NSString stringWithFormat:@"%i",[self randomIntBetween:100000 andLargerInt:999999]];
    urlAsString = [urlAsString stringByAppendingFormat:@"?un=%@&pwd=%@&mobile=%@&msg=%@",un,pwd,mobile,verificationCode];
    NSURL *url = [NSURL URLWithString:urlAsString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setTimeoutInterval:30.0f];
    [request setHTTPMethod:@"POST"];
    NSOperationQueue *queue = [NSOperationQueue new];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(
        NSURLResponse *response,
        NSData *data,
        NSError *error){
       
        
        GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:data options:0 error:&error];
        NSLog(@"url=%@",urlAsString);
        NSLog(@"callback data  = %@",doc.rootElement);
        
    }
        
     ];
    

    
}
-(int)randomIntBetween:(int)num1 andLargerInt:(int)num2
{
    int startVal = num1*10000;
    int endVal = num2*10000;
    
    int randomValue = startVal +(arc4random()%(endVal - startVal));
    float a = randomValue;
    
    return(a /10000);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
