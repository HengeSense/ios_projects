//
//  MessageFileManager.h
//  SmartHome
//
//  Created by Zhao yang on 9/5/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageFileManager : NSObject

- (NSArray *)readFromDisk;
- (void)writeToDisk:(NSArray *)messages;

@end
