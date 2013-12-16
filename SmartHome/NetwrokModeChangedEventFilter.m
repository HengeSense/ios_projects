//
//  NetwrokModeChangedEventFilter.m
//  SmartHome
//
//  Created by Zhao yang on 12/12/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "NetwrokModeChangedEventFilter.h"

@implementation NetwrokModeChangedEventFilter

- (BOOL)apply:(XXEvent *)event {
    if(event != nil && [event isKindOfClass:[NetworkModeChangedEvent class]]) {
        return YES;
    }
    return NO;
}

@end
