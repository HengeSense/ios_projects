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

- (DeviceCommand *)popup;
- (void)pushCommand:(DeviceCommand *)command;
- (BOOL)contains:(DeviceCommand *)command;

- (NSUInteger)count;

@end
