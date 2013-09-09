//
//  NotificationsFileManager.m
//  SmartHome
//
//  Created by Zhao yang on 9/5/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "NotificationsFileManager.h"
#import "SMNotification.h"
#import "SMShared.h"

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
        
        NSURL *url = [[NSBundle mainBundle] URLForResource:[NSString stringWithFormat:@"%@-%@",[SMShared current].settings.account, @"notifications"] withExtension:@"sm"];
        NSData *data = [NSData dataWithContentsOfURL:url];
        
        if(data == nil) {
            NSLog(@"data is nil");
        } else {
       NSString *s=     [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@">>>>>>>>>%@", s);
        }
        
        
        return nil;
    }
}

- (NSArray *)readFromDiskInternal {
    return nil;
}

- (void)writeToDisk:(NSArray *)notifications {
    @synchronized(self) {
        if(notifications == nil || notifications.count == 0) {
            return;
        }
        
//        NSArray *oldNotifications = [self readFromDiskInternal];
      /*
        
        NSMutableArray *_notifications_ = [NSMutableArray array];
        for(int i=0; i<notifications.count; i++) {
            [_notifications_ addObject:[notifications objectAtIndex:i]];
        }
        
        NSLog(@"-111");
NSData *data =        [JsonUtils createJsonDataFromDictionary:
        [NSDictionary dictionaryWithObject:_notifications_ forKey:@"notifications"]];
    
        NSLog(@"000");
        NSURL *url = [[NSBundle mainBundle] URLForResource:[NSString stringWithFormat:@"%@-%@",[SMShared current].settings.account, @"notifications"] withExtension:@"sm"];
        
        NSLog(@"111");
        BOOL success = [data writeToURL:url atomically:YES];
        
        
        if(!success) {
            NSLog(@"write notifications to disk failed.");
        }
        
        
        
        
        */
        //保存50条  老的删除
    }
}
    
    

@end
