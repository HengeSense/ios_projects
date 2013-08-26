//
//  VerificationCodeValidationViewController.h
//  SmartHome
//
//  Created by Zhao yang on 8/23/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "NavViewController.h"

@interface VerificationCodeValidationViewController : NavViewController<UITextFieldDelegate>

@property (strong, nonatomic) NSString *phoneNumberToValidation;
@property (assign, nonatomic) NSUInteger countDown;

@end
