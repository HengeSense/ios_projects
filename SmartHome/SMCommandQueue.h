//
//  SMCommandQueue.h
//  SmartHome
//
//  Created by Zhao yang on 9/2/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DeviceCommand.h"

@interface SMCommandQueue : NSObject

- (NSUInteger)count;
- (void)pushCommand:(DeviceCommand *)command;
- (DeviceCommand *)popup;

- (BOOL)contains:(DeviceCommand *)command;

@end
