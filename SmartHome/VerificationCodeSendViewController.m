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
#import "AboutUsViewController.h"
#import "CustomCheckBox.h"

@interface VerificationCodeSendViewController ()

@end

@implementation VerificationCodeSendViewController{
    UITextField *txtPhoneNumber;
    UILabel *lblPhoneNumber;
    UIButton *btnVerificationCodeSender;
    UILabel *lblModifyTip;
    
    UIButton *btnCheckBox;
    UILabel *lblAgree;
    UIButton *btnShowDeclare;
}

@synthesize isModify;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

-(id)initAsModify:(BOOL)modify{
    self = [super init];
    if (self) {
        self.isModify = modify;
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
        lblPhoneNumber = [[UILabel alloc] initWithFrame:CGRectMake(10, [UIDevice systemVersionIsMoreThanOrEuqal7] ? 80 : 60, 250, 20)];
        [lblPhoneNumber setText:[NSString stringWithFormat:@"%@:",(isModify?NSLocalizedString(@"enter_new_mobile", @""): NSLocalizedString(@"enter_mobile", @""))]];
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
    
    if(isModify) {
        if (lblModifyTip == nil) {
            lblModifyTip = [[UILabel alloc] initWithFrame:CGRectMake(6, txtPhoneNumber.frame.origin.y+txtPhoneNumber.frame.size.height+5, 311, 20)];
            lblModifyTip.font = [UIFont systemFontOfSize:16];
            lblModifyTip.backgroundColor = [UIColor clearColor];
            lblModifyTip.textColor = [UIColor lightGrayColor];
            lblModifyTip.lineBreakMode = NSLineBreakByWordWrapping;
            lblModifyTip.text = NSLocalizedString(@"modify_tip", @"");
            lblModifyTip.numberOfLines = 0;
            [lblModifyTip sizeThatFits:lblModifyTip.frame.size];
            [self.view addSubview:lblModifyTip];
        }
        if(btnVerificationCodeSender == nil) {
            btnVerificationCodeSender = [LongButton buttonWithPoint:CGPointMake(5, lblModifyTip.frame.origin.y +lblModifyTip.frame.size.height + 5)];
            [btnVerificationCodeSender setTitle:NSLocalizedString(@"next_step", @"") forState:UIControlStateNormal];
            [btnVerificationCodeSender addTarget:self action:@selector(sendVerificationCode) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:btnVerificationCodeSender];
        }
    } else {
        if(btnVerificationCodeSender == nil) {
            btnVerificationCodeSender = [LongButton buttonWithPoint:CGPointMake(5, txtPhoneNumber.frame.origin.y +txtPhoneNumber.frame.size.height + 5)];
            btnVerificationCodeSender.enabled = YES;
            [btnVerificationCodeSender setTitle:NSLocalizedString(@"next_step", @"") forState:UIControlStateNormal];
            [btnVerificationCodeSender addTarget:self action:@selector(sendVerificationCode) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:btnVerificationCodeSender];
        }
        if (btnCheckBox == nil) {
            btnCheckBox = [CustomCheckBox checkBoxWithPoint:CGPointMake(15, btnVerificationCodeSender.frame.size.height+btnVerificationCodeSender.frame.origin.y+20)];
            btnCheckBox.selected = YES;
            [btnCheckBox addTarget:self action:@selector(btnCheckBoxPressed) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:btnCheckBox];
        }
        if (lblAgree == nil) {
            lblAgree = [[UILabel alloc] initWithFrame:CGRectMake(25+btnCheckBox.frame.size.width, btnCheckBox.frame.origin.y, 120, btnCheckBox.frame.size.height)];
            lblAgree.backgroundColor = [UIColor clearColor];
            lblAgree.text = NSLocalizedString(@"read.and.agree", @"");
            lblAgree.textColor = [UIColor lightGrayColor];
            [self.view addSubview:lblAgree];
        }
        if (btnShowDeclare == nil) {
            btnShowDeclare = [[UIButton alloc] initWithFrame:CGRectMake(25+lblAgree.frame.size.width, lblAgree.frame.origin.y, 120, lblAgree.frame.size.height)];
            [btnShowDeclare setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
            [btnShowDeclare setTitleColor:[UIColor lightTextColor] forState:UIControlStateSelected];
            [btnShowDeclare setTitle:NSLocalizedString(@"declare", @"") forState:UIControlStateNormal];
            [btnShowDeclare addTarget:self action:@selector(btnShowDeclarePressed) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:btnShowDeclare];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [txtPhoneNumber becomeFirstResponder];
}

#pragma mark -
#pragma mark btn pressed

- (void)btnCheckBoxPressed{
    btnCheckBox.selected = !btnCheckBox.selected;
    btnVerificationCodeSender.enabled = btnCheckBox.selected;
}

- (void)btnShowDeclarePressed{
    [self.navigationController pushViewController:[[AboutUsViewController alloc] init] animated:YES];
}

#pragma mark -
#pragma mark service

- (void)sendVerificationCode {
    if([NSString isBlank:txtPhoneNumber.text] || [NSString trim:txtPhoneNumber.text].length != 11) {
        [[AlertView currentAlertView] setMessage:NSLocalizedString(@"phone_format_invalid", @"") forType:AlertViewTypeFailed];
        [[AlertView currentAlertView] alertAutoDisappear:YES lockView:self.view];
        return;
    }
    [[AlertView currentAlertView] setMessage:NSLocalizedString(@"please_wait", @"") forType:AlertViewTypeWaitting];
    [[AlertView currentAlertView] alertAutoDisappear:NO lockView:self.view];
    if(isModify) {
        [[[AccountService alloc] init] sendModifyUsernameVerificationCodeFor:txtPhoneNumber.text success:@selector(verificationCodeSendSuccess:) failed:@selector(verificationCodeSendError:) target:self callback:nil];
    } else {
        [[[AccountService alloc] init] sendVerificationCodeFor:txtPhoneNumber.text success:@selector(verificationCodeSendSuccess:) failed:@selector(verificationCodeSendError:) target:self callback:nil];
    }
}

- (void)verificationCodeSendSuccess:(RestResponse *)resp {
    if(resp.statusCode == 200) {
        NSDictionary *json = [JsonUtils createDictionaryFromJson:resp.body];
        if(json != nil) {
            NSString *result = [json notNSNullObjectForKey:@"id"];
            if(result != nil) {
                if([@"1" isEqualToString:result] || [@"-3" isEqualToString:result] || [@"-4" isEqualToString:result]) {
                    [[AlertView currentAlertView] dismissAlertView];
                    VerificationCodeValidationViewController *nextViewController = [self nextViewController];
                    nextViewController.phoneNumberToValidation = txtPhoneNumber.text;
                    if([@"1" isEqualToString:result]) {
                        nextViewController.countDown = 60;
                    } else {
                        NSNumber *num = (NSNumber *)[json notNSNullObjectForKey:@"wait"];
                        if(num != nil) {
                            nextViewController.countDown = num.integerValue;
                        } else {
                            nextViewController.countDown = 60;
                        }
                    }
                    [self.navigationController pushViewController:nextViewController animated:YES];
                    return;
                } else if([@"-1" isEqualToString:result]) {
                    [[AlertView currentAlertView] setMessage:NSLocalizedString(@"phone_format_invalid", @"") forType:AlertViewTypeSuccess];
                    [[AlertView currentAlertView] delayDismissAlertView];
                    return;
                } else if(([@"-2" isEqualToString:result] && !isModify)||([@"-7" isEqualToString:result] && isModify)) {
                    [[AlertView currentAlertView] setMessage:NSLocalizedString(@"phone_has_been_register", @"") forType:AlertViewTypeSuccess];
                    [[AlertView currentAlertView] delayDismissAlertView];
                    return;
                }
            }
        }
    }
    [self verificationCodeSendError:resp];
}

- (VerificationCodeValidationViewController *)nextViewController {
    return [[VerificationCodeValidationViewController alloc] initAsModify:self.isModify];
}

- (void)verificationCodeSendError:(RestResponse *)resp {
    if(abs(resp.statusCode) == 1001) {
        [[AlertView currentAlertView] setMessage:NSLocalizedString(@"request_timeout", @"") forType:AlertViewTypeSuccess];
    } else {
        [[AlertView currentAlertView] setMessage:NSLocalizedString(@"unknow_error", @"") forType:AlertViewTypeFailed];
    }
    [[AlertView currentAlertView] delayDismissAlertView];
}

#pragma mark -
#pragma mark text field delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return range.location < 11;
}

@end
