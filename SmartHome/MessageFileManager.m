//
//  MessageFileManager.m
//  SmartHome
//
//  Created by Zhao yang on 9/5/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "MessageFileManager.h"

@implementation MessageFileManager

//按不同账号分离

- (NSArray *)readFromDisk {
    @synchronized(self) {
        
        return nil;
    }
}

- (void)writeToDisk:(NSArray *)messages {
    @synchronized(self) {
        if(messages == nil || messages.count == 0) {
            return;
        }
        
        //保存50条  老的删除
    }
}

@end
