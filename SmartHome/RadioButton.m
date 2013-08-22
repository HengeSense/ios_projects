//
//  RadioButton.m
//  SmartHome
//
//  Created by hadoop user account on 22/08/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "RadioButton.h"

@implementation RadioButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
+(UIButton *)buttonWithPoint:(CGPoint)point{
    UIButton *radioButton = [[UIButton alloc] initWithFrame:CGRectMake(point.x, point.y, 40/2, 40/2)];
    [radioButton setBackgroundImage:[UIImage imageNamed:@"btn_off.png"] forState:UIControlStateNormal];
    [radioButton setBackgroundImage:[UIImage imageNamed:@"btn_on.png"] forState:UIControlStateSelected];
    return radioButton;
}

@end
