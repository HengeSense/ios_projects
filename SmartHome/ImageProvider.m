//
//  ImageProvider.m
//  SmartHome
//
//  Created by Zhao yang on 9/17/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "ImageProvider.h"

#define IMAGE_ARRAY_COUNT 9

@implementation ImageProvider {
    NSMutableArray *imgList1;
    NSMutableArray *imgList2;
    NSMutableArray *imgList3;
}

@synthesize fps;
@synthesize delegate;

- (id)init {
    self = [super init];
    if(self) {
        [self initDefaults];
    }
    return self;
}

- (void)initDefaults {
    imgList1 = [NSMutableArray arrayWithCapacity:IMAGE_ARRAY_COUNT];
    imgList2 = [NSMutableArray arrayWithCapacity:IMAGE_ARRAY_COUNT];
    imgList3 = [NSMutableArray arrayWithCapacity:IMAGE_ARRAY_COUNT];

}

- (void)addImage:(UIImage *)image {
    @synchronized(self) {

    }
}

//- (UIImage *)getImageUsingFps:(BOOL *)hasMore {
    /*
    if(lastReadTime == -1) {
        
        
        return nil;
    } else {
        NSDate *now = [NSDate date];
        long long f = now.timeIntervalSince1970 * 1000 - lastReadTime;
        if(f < 300) {
            [NSThread sleepForTimeInterval:f];
        }
        
        return nil;
    }*/

- (void)startDownloader {
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:nil cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:5];
    NSURLResponse *response;
    NSError *error;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if(error != nil && response != nil && data != nil) {
        // success
        NSHTTPURLResponse *resp = (NSHTTPURLResponse *)response;
        if(resp.statusCode == 200) {
            UIImage *image = [UIImage imageWithData:data];
        } else {
            
        }
    } else {
        NSLog(@"error %d", error.code);
    }
}

- (void)clearHasPlayedImage {
    @synchronized(self) {
    }
}

@end
