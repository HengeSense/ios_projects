//
//  CurrentUnitChangedEventFilter.m
//  SmartHome
//
//  Created by Zhao yang on 12/12/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "CurrentUnitChangedEventFilter.h"

@implementation CurrentUnitChangedEventFilter

- (BOOL)apply:(XXEvent *)event {
    if(event != nil && [event isKindOfClass:[CurrentUnitChangedEvent class]]) {
        return YES;
    }
    return NO;
}

@end
