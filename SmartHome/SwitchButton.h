//
//  SwitchButton.h
//  SmartHome
//
//  Created by Zhao yang on 8/21/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SwitchButton : UIView

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *status;

+ (SwitchButton *)buttonWithTitle:(NSString *)t andStatus:(NSString *)status;

- (void)initDefaults;
- (void)initUI;

//
- (void)registerImage:(UIImage *)img forStatus:(NSString *)s;

// 
- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;

@end
