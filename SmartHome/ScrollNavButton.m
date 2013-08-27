//
//  ScrollNavButton.m
//  SmartHome
//
//  Created by hadoop user account on 26/08/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "ScrollNavButton.h"

@implementation ScrollNavButton

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
+(UIButton *) buttonWithNothing{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    [button setBackgroundColor:[UIColor clearColor]];
    [button setTitleColor:[UIColor lightTextColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    return button;
}
@end
