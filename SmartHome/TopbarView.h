//
//  TopbarView.h
//  SmartHome
//
//  Created by Zhao yang on 8/5/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopbarView : UIView

@property (strong, nonatomic) UIButton *leftButton;
@property (strong, nonatomic) UIButton *rightButton;
@property (strong, nonatomic) UILabel *titleLabel;

+ (TopbarView *)topBarWithImage:(UIImage *)img;

@end
