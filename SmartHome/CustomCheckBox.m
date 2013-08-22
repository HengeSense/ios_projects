//
//  CustomCheckBox.m
//  SmartHome
//
//  Created by hadoop user account on 22/08/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "CustomCheckBox.h"

@implementation CustomCheckBox

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
+(UIButton *) checkBoxWithPoint:(CGPoint)point{
    UIButton *checkBox = [[UIButton alloc] initWithFrame:CGRectMake(point.x,point.y, 40/2, 38/2)];
    [checkBox setBackgroundImage:[UIImage imageNamed:@"cbx_unchecked.png"] forState:UIControlStateNormal];
    [checkBox setBackgroundImage:[UIImage imageNamed:@"cbx_checked.png"] forState:UIControlStateSelected];
    return checkBox;
}
@end
