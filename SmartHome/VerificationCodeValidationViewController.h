//
//  VerificationCodeValidationViewController.h
//  SmartHome
//
//  Created by Zhao yang on 8/23/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "NavViewController.h"
#import "DeviceCommand.h"

@interface VerificationCodeValidationViewController : NavViewController<UITextFieldDelegate,UIAlertViewDelegate>

@property (strong, nonatomic) NSString *phoneNumberToValidation;
@property (assign, nonatomic) NSUInteger countDown;
@property (assign, nonatomic) BOOL isModify;

- (id)initAsModify:(BOOL)modify;

@end
