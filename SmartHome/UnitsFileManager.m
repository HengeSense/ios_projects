//
//  UnitsFileManager.m
//  SmartHome
//
//  Created by Zhao yang on 9/5/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "UnitsFileManager.h"

@implementation UnitsFileManager

//根据不同账号隔离

- (void)writeToDisk:(NSArray *)units {
    @synchronized(self) {
        if(units == nil || units.count == 0) {
            //删除或者清空这个账号下的units
            return;
        }
    }
}

- (NSArray *)readFromDisk {
    @synchronized(self) {
        
        return nil;
    }
}

@end
