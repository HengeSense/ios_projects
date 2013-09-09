//
//  NotificationsFileManager.m
//  SmartHome
//
//  Created by Zhao yang on 9/5/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "NotificationsFileManager.h"
#import "SMNotification.h"

@implementation NotificationsFileManager

//按不同账号分离

+ (NotificationsFileManager *)fileManager {
    static NotificationsFileManager *manager;
    if(manager == nil) {
        manager = [[NotificationsFileManager alloc] init];
    }
    return manager;
}

- (NSArray *)readFromDisk {
    @synchronized(self) {
        
        return nil;
    }
}

- (void)writeToDisk:(NSArray *)notifications {
    @synchronized(self) {
        if(notifications == nil || notifications.count == 0) {
            return;
        }
        
        //保存50条  老的删除
    }
}
    
    

@end
