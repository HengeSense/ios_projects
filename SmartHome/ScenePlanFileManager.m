//
//  ScenePlanFileManager.m
//  SmartHome
//
//  Created by Zhao yang on 12/4/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "ScenePlanFileManager.h"
#import "SMShared.h"
#import "ScenePlanZone.h"
#import "ScenePlanDevice.h"

#define DIRECTORY [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"smarthome-scenePlans"]

@implementation ScenePlanFileManager

+ (ScenePlanFileManager *)fileManager {
    static ScenePlanFileManager *manager = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        manager = [[ScenePlanFileManager alloc] init];
    });
    return manager;
}

- (void)deleteAllScenePlan {
    NSString *path = [DIRECTORY stringByAppendingPathComponent:[SMShared current].settings.account];
    if([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    }
}

- (void)saveScenePlan:(ScenePlan *)scenePlan {
    NSString *path = [[DIRECTORY stringByAppendingPathComponent:[SMShared current].settings.account] stringByAppendingPathComponent:scenePlan.unitIdentifier];
    BOOL directoryExists = [[NSFileManager defaultManager] fileExistsAtPath:path];
    if(!directoryExists) {
        NSError *error;
        BOOL createDirSuccess = [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
        if(!createDirSuccess) {
#ifdef DEBUG
            NSLog(@"[SCENE PLAN FILE MANAGER] Create directory failed , error >>> %@", error.description);
#endif
            return;
        }
    }
    
    NSString *filePath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.txt", scenePlan.scenePlanIdentifier]];
    NSData *data = [JsonUtils createJsonDataFromDictionary:[scenePlan toJson]];
    BOOL success = [data writeToFile:filePath atomically:YES];
    
    if(!success) {
#ifdef DEBUG
        NSLog(@"[SCENE PLAN FILE MANAGER] Save notifications failed ...");
#endif
    }
}

- (ScenePlan *)syncScenePlan:(ScenePlan *)newScenePlan {
    NSString *filePath = [[[DIRECTORY stringByAppendingPathComponent:[SMShared current].settings.account] stringByAppendingPathComponent:newScenePlan.unitIdentifier] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.txt", newScenePlan.scenePlanIdentifier]];
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSData *data = [[NSData alloc] initWithContentsOfFile:filePath];
        ScenePlan *plan = [[ScenePlan alloc] initWithJson:[JsonUtils createDictionaryFromJson:data]];
        if(newScenePlan == nil) return plan;
        newScenePlan.securityIdentifier = plan.securityIdentifier;
        for(int i=0; i<newScenePlan.scenePlanZones.count; i++) {
            ScenePlanZone *newZonePlan = [newScenePlan.scenePlanZones objectAtIndex:i];
            ScenePlanZone *diskZonePlan = [plan zonePlanForIdentifier:newZonePlan.zoneIdentifier];
            if(diskZonePlan != nil) {
                for(int j=0; j<newZonePlan.scenePlanDevices.count; j++) {
                    ScenePlanDevice *newDevicePlan = [newZonePlan.scenePlanDevices objectAtIndex:j];
                    ScenePlanDevice *diskDevicePlan = [diskZonePlan devicePlanForIdentifier:newDevicePlan.deviceIdentifier];
                    if(diskDevicePlan != nil) {
                        newDevicePlan.status = diskDevicePlan.status;
                    }
                }
            }
        }
        return newScenePlan;
    } else {
#ifdef DEBUG
        NSLog(@"[SCENE PLAN FILE MANAGER] Scene plan file not exists.");
#endif
    }
    return nil;
}

@end
