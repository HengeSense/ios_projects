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
    UIButton *btnNext;
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
        btnNext = [LongButton buttonWithPoint:CGPointMake(5, txtVerificationCode.frame.origin.y +txtVerificationCode.frame.size.height + 5)];
        [btnNext setTitle:NSLocalizedString(@"next_step", @"") forState:UIControlStateNormal];
        [btnNext addTarget:self action:@selector(sendVerificationCode) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnNext];
    }
    
    [txtVerificationCode becomeFirstResponder];
}

#pragma mark -
#pragma mark text field delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return range.location < 6;
}

@end
