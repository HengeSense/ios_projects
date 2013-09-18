//
//  ImageProvider.m
//  SmartHome
//
//  Created by Zhao yang on 9/17/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "ImageProvider.h"

#define IMAGE_ARRAY_COUNT 50

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

- (void)startDownloader:(NSString *)url imageIndex:(NSInteger)index {
    
    NSURL *_url_ = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@/%d.jpg", url, index]];
    
    // prepare
    NSError *error;
    NSURLResponse *response;
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:_url_ cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:20];
    
    // send request
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    // process response
    if(error == nil && response != nil && data != nil) {
        NSLog(@"%@", _url_.description);
        
        NSHTTPURLResponse *resp = (NSHTTPURLResponse *)response;
        if(resp.statusCode == 200) {
            UIImage *image = [UIImage imageWithData:data];
            NSMutableArray *arr = [self currentPointAtArray];
            if(arr != nil) {
                [arr addObject:image];
                if(arr.count == IMAGE_ARRAY_COUNT) {                    
                    [self performSelectorOnMainThread:@selector(notifyWith:) withObject:arr waitUntilDone:NO];
                    [self movePointer];
                }
                index++;
                [self startDownloader:url imageIndex:index];
            } else {
                NSLog(@"unknown exception at download image");
            }
        } else {
            NSLog(@"downloader image status code is %d", resp.statusCode);
            [self performSelectorOnMainThread:@selector(notifyWith:) withObject:[self currentPointAtArray] waitUntilDone:NO];
        }
    } else {
        NSLog(@"system error from downloader camera image code is %d", error.code);
    }
}

- (void)notifyWith:(NSArray *)imageList {
    [self.delegate imageProviderNotifyAvailable:imageList provider:self];
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
