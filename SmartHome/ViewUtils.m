//
//  ViewUtils.m
//  SmartHome
//
//  Created by Zhao yang on 8/9/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "ViewUtils.h"

@implementation ViewUtils

+ (UIImage *)captureScreen:(UIView *)view {
    if(view == nil) return nil;
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

@end
