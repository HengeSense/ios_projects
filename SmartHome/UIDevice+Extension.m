//
//  UIDevice+Extension.m
//  SmartHome
//
//  Created by Zhao yang on 9/21/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "UIDevice+Extension.h"

@implementation UIDevice (Extension)

+ (BOOL)systemVersionIsMoreThanOrEuqal7 {
    return [UIDevice currentDevice].systemVersion.floatValue >= 7.0;
}

@end
