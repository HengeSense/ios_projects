//
//  DeviceCommandUpdateUnitNameHandler.m
//  SmartHome
//
//  Created by Zhao yang on 9/13/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "DeviceCommandUpdateUnitNameHandler.h"

@implementation DeviceCommandUpdateUnitNameHandler

- (void)handle:(DeviceCommand *)command {
    [super handle:command];
    if ([command isKindOfClass:[DeviceCommandUpdateUnitName class]]) {
        NSArray *subscriptorArr = [[SMShared current].memory getSubscriptionsFor:self.class];
        if (subscriptorArr&&subscriptorArr.count>0) {
            for (UIViewController *controller in subscriptorArr) {
                NSLog(@"-------->into updateunithandler");
                if([controller respondsToSelector:@selector(updateUnitName:)]){
                    [controller performSelector:@selector(updateUnitName:) withObject:command ];
                }
            }
        }
    }
}

@end
