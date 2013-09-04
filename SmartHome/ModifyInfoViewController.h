//
//  ModifyInfoViewController.h
//  SmartHome
//
//  Created by hadoop user account on 16/08/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "PopViewController.h"
#import "NavViewController.h"
#import "SMTextField.h"
@protocol TextViewDelegate <NSObject>

- (void)textViewHasBeenSetting:(NSString *)string;

@end

@interface ModifyInfoViewController : PopViewController<UITextFieldDelegate>

@property (assign, nonatomic) id<TextViewDelegate> textDelegate;
@property (strong,nonatomic) NavViewController *lastView;
@property (strong,nonatomic) NSString *title;
@property (strong,nonatomic) NSString *value;

-(id) initWithKey:(NSString *) key forValue:(NSString *) v from:(NavViewController *) where;
@end
