//
//  ScenePlanFileManager.m
//  SmartHome
//
//  Created by Zhao yang on 12/4/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "ScenePlanFileManager.h"
#import "SMShared.h"

#define DIRECTORY [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"smarthome-scenePlans"]

@implementation ScenePlanFileManager

+ (ScenePlanFileManager *)fileManager {
    static ScenePlanFileManager *manager;
    if(manager == nil) {
        manager = [[ScenePlanFileManager alloc] init];
    }
    return manager;
}

- (void)syncToDisk:(ScenePlan *)scenePlan {
    BOOL directoryExists = [[NSFileManager defaultManager] fileExistsAtPath:DIRECTORY];
    if(!directoryExists) {
        NSError *error;
        BOOL createDirSuccess = [[NSFileManager defaultManager] createDirectoryAtPath:DIRECTORY withIntermediateDirectories:YES attributes:nil error:&error];
        if(!createDirSuccess) {
#ifdef DEBUG
            NSLog(@"[SCENE PLAN FILE MANAGER] Create directory failed , error >>> %@", error.description);
#endif
            return;
        }
    }
    
    NSData *data = [JsonUtils createJsonDataFromDictionary:nil];
    
    
    NSString *filePath = [DIRECTORY stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.txt", [SMShared current].settings.account]];
    BOOL success = [data writeToFile:filePath atomically:YES];
    
    if(!success) {
#ifdef DEBUG
        NSLog(@"[SCENE PLAN FILE MANAGER] Save notifications failed ...");
#endif
    }
    
}

- (ScenePlan *)readFromDisk {
    NSString *filePath = [DIRECTORY stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.txt", [SMShared current].settings.account]];
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSData *data = [[NSData alloc] initWithContentsOfFile:filePath];
        
        
    } else {
#ifdef DEBUG
        NSLog(@"[SCENE PLAN FILE MANAGER] Scene plan file not exists.");
#endif
    }
    return nil;
}

@end
