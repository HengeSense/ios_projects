//
//  SwitchButton.h
//  SmartHome
//
//  Created by Zhao yang on 8/21/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SwitchButton : UIView

@property (strong, nonatomic) NSString *iconImageName;
@property (strong, nonatomic) NSString *title;

+ (SwitchButton *)buttonWithTitle:(NSString *)t andImageName:(NSString *)imageName;

- (void)initDefaults;
- (void)initUI;
// 
- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;

@end
