//
//  ObjectToFile.m
//  SmartHome
//
//  Created by hadoop user account on 6/09/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "ObjectToFile.h"

@implementation ObjectToFile
+(BOOL) objectToFile:(id) object forKey:(NSString *) key{
    NSMutableData *dataArea = [NSMutableData data];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:dataArea];
    [archiver encodeObject:object forKey:key];
    [archiver finishEncoding];
    
    return  [dataArea writeToFile:@"smarthomeArchiver" atomically:NO];
}
@end
