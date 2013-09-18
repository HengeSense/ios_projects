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
    NSUInteger pointerAt;
}

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
    pointerAt = 0;
}

- (void)addImage:(UIImage *)image {
    @synchronized(self) {

    }
}

//- (UIImage *)getImageUsingFps:(BOOL *)hasMore {
//
//    if(lastReadTime == -1) {
//        
//        
//        return nil;
//    } else {
//        NSDate *now = [NSDate date];
//        long long f = now.timeIntervalSince1970 * 1000 - lastReadTime;
//        if(f < 300) {
//            [NSThread sleepForTimeInterval:f];
//        }
//        


- (void)startDownloader {
    
NSURL *u =    [[NSURL alloc] initWithString:@"http://172.16.8.162/2013/8/17/e89fcbf1-7467-4143-85b4-f7ffd200c813/101/0.jpg"];
    
    // prepare
    NSError *error;
    NSURLResponse *response;
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:u cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:20];
    
    // send request
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    // process response
    if(error == nil && response != nil && data != nil) {
        NSHTTPURLResponse *resp = (NSHTTPURLResponse *)response;
        if(resp.statusCode == 200) {
            UIImage *image = [UIImage imageWithData:data];
            NSMutableArray *arr = [self currentPointAtArray];
            if(arr != nil) {
                [arr addObject:image];
                if(arr.count == IMAGE_ARRAY_COUNT) {
                    [self movePointer];
                }
                [self startDownloader];
            } else {
                NSLog(@"unknown exception at download image");
            }
        } else {
            NSLog(@"downloader image status code is %d", resp.statusCode);
        }
    } else {
        NSLog(@"system error from downloader camera image code is %d", error.code);
    }
    
    //[self.delegate imageProviderNotifyAvailable:[NSArray arrayWithObject:image] provider:self];
}

- (NSMutableArray *)currentPointAtArray {
    if(pointerAt == 0) {
        return imgList1;
    }
    if(pointerAt == 1) {
        return imgList2;
    }
    if(pointerAt == 2) {
        return imgList3;   
    }
    return nil;
}

- (void)movePointer {
    if(pointerAt < 2) {
        pointerAt++;
    } else {
        pointerAt = 0;
    }
}

@end
