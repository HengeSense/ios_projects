//
//  ImageFactory.m
//  SmartHome
//
//  Created by Zhao yang on 8/12/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "ImageFactory.h"

@implementation ImageFactory {
    UIImage *imgBubbleTheirs;
    UIImage *imgBubbleMine;
}

- (UIImage *)imageForBubbleTheirs {
    if(imgBubbleTheirs == nil) {
        imgBubbleTheirs = [[UIImage imageNamed:@"bubble_theirs.png"] stretchableImageWithLeftCapWidth:8 topCapHeight:22];
    }
    return imgBubbleTheirs;
}

- (UIImage *)imageForBubbleMine {
    if(imgBubbleMine == nil) {
        imgBubbleTheirs = [UIImage imageNamed:@"bubble_mine.png"];
    }
    return imgBubbleMine;
}

+ (ImageFactory *)sharedImageFactory {
    static ImageFactory *factory = nil;
    if(factory == nil) {
        factory = [[ImageFactory alloc] init];
    }
    return factory;
}

@end
