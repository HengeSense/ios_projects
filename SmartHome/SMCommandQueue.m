//
//  SMCommandQueue.m
//  SmartHome
//
//  Created by Zhao yang on 9/2/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "SMCommandQueue.h"

@implementation SMCommandQueue {
    NSMutableArray *queue;
}

- (id)init {
    self = [super init];
    if(self) {
        queue = [NSMutableArray array];
    }
    return self;
}

- (NSUInteger)count {
    @synchronized(self) {
        return queue.count;
    }
}

- (void)pushCommand:(DeviceCommand *)command {
    @synchronized(self) {
        [queue addObject:command];
    }
}

- (BOOL)contains:(DeviceCommand *)command {
    @synchronized(self) {
        if(queue == nil || queue.count == 0) return NO;
        for(DeviceCommand *cmd in queue) {
            if([cmd isEqual:command]) {
                return YES;
            }
        }
        return NO;
    }
}

- (DeviceCommand *)popup {
    @synchronized(self) {
        if(queue.count > 0) {
            DeviceCommand *command = [queue objectAtIndex:0];
            if(command != nil) {
                [queue removeObjectAtIndex:0];
                return command;
            }
        }
        return nil;
    }
}

@end
