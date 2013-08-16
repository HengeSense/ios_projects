//
//  ModifyInfoViewController.h
//  SmartHome
//
//  Created by hadoop user account on 16/08/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "NavViewController.h"

@protocol TextViewDelegate <NSObject>

- (void)textViewHasBeenSetting:(NSString *)string;

@end

@interface ModifyInfoViewController : NavViewController

@property (assign, nonatomic) id<TextViewDelegate> delegate;

@end
