//
//  TopbarView.h
//  SmartHome
//
//  Created by Zhao yang on 8/5/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIDevice+Extension.h"

#define TOP_BAR_HEIGHT 46.5

@interface TopbarView : UIView

@property (strong, nonatomic) UIButton *leftButton;
@property (strong, nonatomic) UIButton *rightButton;
@property (strong, nonatomic) UILabel *titleLabel;

+ (TopbarView *)topBarWithImage:(UIImage *)img shadow:(BOOL)needShadow;

@end
