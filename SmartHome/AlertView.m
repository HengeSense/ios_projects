//
//  AlertView.m
//  SmartHome
//
//  Created by Zhao yang on 8/16/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "AlertView.h"

#define KEY_WINDOW [UIApplication sharedApplication].keyWindow

@implementation AlertView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

+ (AlertView *)currentAlertView {
    static AlertView *currentAlertView;
    if(currentAlertView == nil) {   
    }
    return currentAlertView;
}

@end
