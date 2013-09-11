//
//  UnitsFileManager.m
//  SmartHome
//
//  Created by Zhao yang on 9/5/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "UnitsFileManager.h"
#import "SMShared.h"

#define DIRECTORY [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"smarthome-units"]

@implementation UnitsFileManager

+ (UnitsFileManager *)fileManager {
    static UnitsFileManager *manager;
    if(manager == nil) {
        manager = [[UnitsFileManager alloc] init];
    }
    return manager;
}

- (void)writeToDisk:(NSArray *)units {
    @synchronized(self) {
        @try {
            BOOL directoryExists = [[NSFileManager defaultManager] fileExistsAtPath:DIRECTORY];
            if(!directoryExists) {
                NSError *error;
                BOOL createDirSuccess = [[NSFileManager defaultManager] createDirectoryAtPath:DIRECTORY withIntermediateDirectories:YES attributes:nil error:&error];
                if(!createDirSuccess) {
                    NSLog(@"create directory for units failed , error >>> %@", error.description);
                    return;
                }
            }
            
            NSString *filePath = [DIRECTORY stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.txt", [SMShared current].settings.account]];
            
            if(units == nil || units.count == 0) {
                BOOL exists = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
                if(exists) {
                    NSError *error;
                    [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
                    if(error) {
                        NSLog(@"remove unit file failed. error >>>>  %@", error.description);
                    }
                }
                return;
            }
            
            NSMutableArray *unitsToSave = [NSMutableArray array];
            for(Unit *unit in units) {
                [unitsToSave addObject:[unit toJson]];
            }
            
            NSData *data = [JsonUtils createJsonDataFromDictionary:[NSDictionary dictionaryWithObject:unitsToSave forKey:@"units"]];
            
            BOOL success = [data writeToFile:filePath atomically:YES];
            
            if(!success) {
                NSLog(@"save units failed ...");
            }
        }
        @catch (NSException *exception) {
            NSLog(@"save units exception reason %@", exception.reason);
        }
        @finally {

        }
    }
}

- (NSArray *)readFromDisk {
    @synchronized(self) {
        NSString *filePath = [DIRECTORY stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.txt", [SMShared current].settings.account]];
        if(![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
            return nil;
        }
        
        NSData *data = [[NSData alloc] initWithContentsOfFile:filePath];
        NSDictionary *json = [JsonUtils createDictionaryFromJson:data];
        NSArray *_units_ = [json objectForKey:@"units"];
        if(_units_ != nil) {
            NSMutableArray *units = [NSMutableArray array];
            for(NSDictionary *_unit in _units_) {
                [units addObject:[[Unit alloc] initWithJson:_unit]];
            }
            return units;
        }
        return nil;
    }
}

@end
