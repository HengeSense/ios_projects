//
//  VerificationCodeSendViewController.h
//  SmartHome
//
//  Created by Zhao yang on 8/5/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavViewController.h"
#import "UnitsBindingViewController.h"

@interface VerificationCodeSendViewController : NavViewController<UITextFieldDelegate>

@property(assign,nonatomic) BOOL isModify;

- (id)initAsModify:(BOOL)modify;

@end
