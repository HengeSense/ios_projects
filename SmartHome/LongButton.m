//
//  LongButton.m
//  SmartHome
//
//  Created by hadoop user account on 16/08/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "LongButton.h"

@implementation LongButton
@synthesize cameraPicPath;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}
-(id) initWithCameraPicPath:(CameraPicPath *)path atPoint:(CGPoint)point{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(point.x, point.y, 622 / 2, 98 / 2);
        [self setBackgroundImage:[UIImage imageNamed:@"btn_orange.png"] forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage imageNamed:@"btn_orange_highlight.png"] forState:UIControlStateHighlighted];
    }
    return self;


}
+ (UIButton *)buttonWithPoint:(CGPoint)point {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(point.x, point.y, 622 / 2, 98 / 2)];
    [button setBackgroundImage:[UIImage imageNamed:@"btn_orange.png"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"btn_orange_highlight.png"] forState:UIControlStateHighlighted];
    return button;
}

+ (UIButton *)darkButtonWithPoint:(CGPoint)point {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(point.x, point.y, 622 / 2, 98 / 2)];
    [button setBackgroundImage:[UIImage imageNamed:@"btn_dark.png"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"btn_dark.png"] forState:UIControlStateHighlighted];
    return button;
}

@end
