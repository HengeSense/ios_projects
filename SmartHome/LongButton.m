//
//  LongButton.m
//  SmartHome
//
//  Created by hadoop user account on 16/08/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "LongButton.h"

@implementation LongButton {
    NSMutableDictionary *parameters;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        parameters = [NSMutableDictionary dictionary];
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

- (void)setParameter:(id)object forKey:(NSString *)key {
    if(parameters != nil) {
        [parameters setObject:object forKey:key];
    }
}

- (id)parameterForKey:(NSString *)key {
    if(parameters == nil) return nil;
    return [parameters objectForKey:key];
}

@end
