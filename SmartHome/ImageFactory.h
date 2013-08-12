//
//  ImageFactory.h
//  SmartHome
//
//  Created by Zhao yang on 8/12/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageFactory : NSObject

+ (ImageFactory *)sharedImageFactory;

- (UIImage *)imageForBubbleMine;
- (UIImage *)imageForBubbleTheirs;

@end
