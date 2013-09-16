//
//  NetworkCheckerOperation.m
//  SmartHome
//
//  Created by Zhao yang on 9/16/13.
//  Copyright (c) 2013 hentre. All rights reserved.


#import "NetworkCheckerOperation.h"

@implementation NetworkCheckerOperation

- (void)main {
    for(int i=0; i<10; i++) {
    NSLog(@"main %d" , i);
    [NSThread sleepForTimeInterval:1.5];
    }
}

@end
