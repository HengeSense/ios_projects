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

#define MAX_NOTIFICATIONS_COUNT 50
#define DIRECTORY [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"smarthome-notifications"]

@implementation NotificationsFileManager


+ (NotificationsFileManager *)fileManager {
    static NotificationsFileManager *manager;
    if(manager == nil) {
        manager = [[NotificationsFileManager alloc] init];
    }
    return manager;
}

- (NSArray *)readFromDisk {
    @synchronized(self) {
        return [self readFromDiskInternal];
    }
}

- (NSArray *)readFromDiskInternal {
    NSString *filePath = [DIRECTORY stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.txt", [SMShared current].settings.account]];
    BOOL exists = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
    if(exists) {
        NSMutableArray *notifications = [NSMutableArray array];
        NSData *data = [[NSData alloc] initWithContentsOfFile:filePath];
        NSDictionary *json = [JsonUtils createDictionaryFromJson:data];
        if(json != nil) {
            NSArray *_notifications_ = [json notNSNullObjectForKey:@"notifications"];
            if(_notifications_ != nil) {
                for(NSDictionary *js in _notifications_) {
                    [notifications addObject:[[SMNotification alloc] initWithJson:js]];
                }
                return notifications;
            }
        }
    } else {
        NSLog(@"notifications file not exists");
    }
    return nil;
}

- (void)update:(NSArray *)notifications {
    @synchronized(self) {
        
        
        
        
        
    }
}

- (void)writeToDisk:(NSArray *)newNotifications {
    @synchronized(self) {
        @try {
            if(newNotifications == nil || newNotifications.count == 0) {
                return;
            }
            
            BOOL directoryExists = [[NSFileManager defaultManager] fileExistsAtPath:DIRECTORY];
            if(!directoryExists) {
                NSError *error;
                BOOL createDirSuccess = [[NSFileManager defaultManager] createDirectoryAtPath:DIRECTORY withIntermediateDirectories:YES attributes:nil error:&error];
                if(!createDirSuccess) {
                    NSLog(@"create directory failed , error >>> %@", error.description);
                    return;
                }
            }
            
            // save list
            NSMutableArray *notificationsToSave = [NSMutableArray array];
            
            // old notifications
            NSArray *oldNotifications = [self readFromDiskInternal];
            
            // 以前没有消息, 新消息全部存入
            if(oldNotifications == nil || oldNotifications.count == 0) {
                [notificationsToSave addObjectsFromArray:newNotifications];
            } else {
                // 新消息和老消息总数小于50条, 新老消息都可全部存入
                if(oldNotifications.count + newNotifications.count <= MAX_NOTIFICATIONS_COUNT) {
                    [notificationsToSave addObjectsFromArray:oldNotifications];
                    [notificationsToSave addObjectsFromArray:newNotifications];
                } else {
                    // 新消息总数大于50条,只存新消息和老的未读消息
                    if(newNotifications.count >= MAX_NOTIFICATIONS_COUNT) {
                        
                        for(SMNotification *noti in oldNotifications) {
                            if(!noti.hasRead) {
                                [notificationsToSave addObject:noti];
                            }
                        }
                        
                        [notificationsToSave addObjectsFromArray:newNotifications];
                    } else {
                        int hasReadCount = 0;
                        for(SMNotification *noti in oldNotifications) {
                            if(noti.hasRead) {
                                hasReadCount++;
                            }
                        }
                        // 新消息加未读消息大于50条,老的已读消息全删
                        if(hasReadCount >= MAX_NOTIFICATIONS_COUNT) {
                            for(SMNotification *noti in oldNotifications) {
                                if(!noti.hasRead) {
                                    [notificationsToSave addObject:noti];
                                }
                                [notificationsToSave addObjectsFromArray:newNotifications];
                            }
                        } else {
                            // 需要删除的已读老消息数量
                            int hasReadedNeedToDelCount = oldNotifications.count -  (MAX_NOTIFICATIONS_COUNT - hasReadCount - newNotifications.count);
                            
                            int deletedCount = 0;
                            for(SMNotification *noti in oldNotifications) {
                                if(noti.hasRead && deletedCount < hasReadedNeedToDelCount) {
                                    deletedCount++;
                                    continue;
                                }
                                [notificationsToSave addObject:noti];
                            }
                            [notificationsToSave addObjectsFromArray:newNotifications];
                        }
                    }
                }
            }
            
            NSString *filePath = [DIRECTORY stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.txt", [SMShared current].settings.account]];
            
            //
            NSMutableArray *_notifications_ = [NSMutableArray array];
            for(int i=0; i<notificationsToSave.count; i++) {
                SMNotification *smn = [notificationsToSave objectAtIndex:i];
                if(smn != nil) {
                    [_notifications_ addObject:[smn toJson]];
                }
            }
            
            NSData *data = [JsonUtils createJsonDataFromDictionary:[NSDictionary dictionaryWithObject:_notifications_ forKey:@"notifications"]];
            
            BOOL success = [data writeToFile:filePath atomically:YES];
            
            if(!success) {
                NSLog(@"save notifications failed ...");
            }
        }
        @catch (NSException *exception) {
            NSLog(@"exception in save notifications to disk >>> %@", exception.reason);
        }
        @finally {

        }
    }
}

@end
