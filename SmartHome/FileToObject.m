//
//  FileToObject.m
//  SmartHome
//
//  Created by hadoop user account on 6/09/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "FileToObject.h"

@implementation FileToObject
+(id) fileToObjectForKey:(NSString *) key{
    NSData *dataArea = [NSData dataWithContentsOfFile:@"smarthomeArchiver"];
    NSKeyedUnarchiver *unarchiver;
    if (!dataArea) {
        return nil;
    }
    unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:dataArea];
    id result = [unarchiver decodeObjectForKey:key];
    [unarchiver finishDecoding];
    return result;
}
@end
