//
//  LongButton.m
//  SmartHome
//
//  Created by hadoop user account on 16/08/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "LongButton.h"

@implementation LongButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

+ (UIButton *)buttonWithPoint:(CGPoint)point {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(point.x, point.y, 622 / 2, 98 / 2)];
    [button setBackgroundImage:[UIImage imageNamed:@"btn_orange.png"] forState:UIControlStateNormal];
    return button;
}

@end
