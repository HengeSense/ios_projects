//
//  UIView+Extensions.m
//  SmartHome
//
//  Created by Zhao yang on 9/27/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "UIView+Extensions.h"

@implementation UIView (Extensions)

- (void)clearSubviews {
    for(UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
}

@end
