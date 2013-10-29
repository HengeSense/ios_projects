//
//  CameraScreenShotsSaver.m
//  SmartHome
//
//  Created by Zhao yang on 10/28/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "CameraScreenShotsSaver.h"

@implementation CameraScreenShotsSaver

+ (BOOL)saveToAlbumsWithImage:(UIImage *)image {
    if(image == nil) {
        
        return NO;
    }
    
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(ff), nil);
    
    return YES;
}

+ (void)ff {
    
}

@end
