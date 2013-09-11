//
//  UnitsFileManager.h
//  SmartHome
//
//  Created by Zhao yang on 9/5/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UnitsFileManager : NSObject

- (NSArray *)readFromDisk;
- (void)writeToDisk:(NSArray *)units;

+ (UnitsFileManager *)fileManager;

@end
