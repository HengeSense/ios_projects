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
@property (strong, nonatomic) UIViewController *ownerController;

+ (SwitchButton *)buttonWithPoint:(CGPoint)point owner:(UIViewController *)owner;

- (void)initDefaults;
- (void)initUI;

//
- (void)registerImage:(UIImage *)img forStatus:(NSString *)s;

//
- (void)btnPressed:(id)sender;

// 
- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;

@end
