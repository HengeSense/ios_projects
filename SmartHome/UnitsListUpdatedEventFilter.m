//
//  UnitsListUpdatedEventFilter.m
//  SmartHome
//
//  Created by Zhao yang on 12/12/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "UnitsListUpdatedEventFilter.h"

@implementation UnitsListUpdatedEventFilter

- (BOOL)apply:(XXEvent *)event {
    if(event != nil && [event isKindOfClass:[UnitsListUpdatedEvent class]]) {
        return YES;
    }
    return NO;
}

@end
