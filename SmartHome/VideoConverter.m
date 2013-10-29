//
//  VideoConverter.m
//  SmartHome
//
//  Created by Zhao yang on 10/28/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "VideoConverter.h"
#import "SMShared.h"

@implementation VideoConverter

- (void)checkVideosDirectory {
    BOOL exists = [[NSFileManager defaultManager] fileExistsAtPath:VIDEO_DIRECTORY];
    if(!exists) {
        NSError *error;
        BOOL createDirSuccess = [[NSFileManager defaultManager] createDirectoryAtPath:VIDEO_DIRECTORY withIntermediateDirectories:YES attributes:nil error:&error];
        if(!createDirSuccess) {
#ifdef DEBUG
            NSLog(@"[VIDEO CONVERTER] Create video directory failed, [%@].", error.description);
#endif
            return;
        }
    }
}

- (void)imagesToVideoAtPath {
    [self checkVideosDirectory];
    
    
    
    
}

@end
