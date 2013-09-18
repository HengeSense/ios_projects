//
//  LongButton.m
//  SmartHome
//
//  Created by hadoop user account on 16/08/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "LongButton.h"

@implementation LongButton {
    NSMutableDictionary *dic;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        dic = [NSMutableDictionary dictionary];
    }
    return self;
}

+ (UIButton *)buttonWithPoint:(CGPoint)point {
    LongButton *button = [[LongButton alloc] initWithFrame:CGRectMake(point.x, point.y, 622 / 2, 98 / 2)];
    [button setBackgroundImage:[UIImage imageNamed:@"btn_orange.png"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"btn_orange_highlight.png"] forState:UIControlStateHighlighted];
    return button;
}

+ (LongButton *)darkButtonWithPoint:(CGPoint)point {
    LongButton *button = [[LongButton alloc] initWithFrame:CGRectMake(point.x, point.y, 622 / 2, 98 / 2)];
    [button setBackgroundImage:[UIImage imageNamed:@"btn_dark.png"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"btn_dark.png"] forState:UIControlStateHighlighted];
    return button;
}

- (void)setObject:(id)object forKey:(NSString *)key {
    [dic setObject:object forKey:key];
}

- (id)objectForKey:(NSString *)key {
    return [dic objectForKey:key];
}

@end
