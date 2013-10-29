//
//  CameraScreenShotsSaver.h
//  SmartHome
//
//  Created by Zhao yang on 10/28/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CameraScreenShotsSaver : NSObject

+ (BOOL)saveToAlbumsWithImage:(UIImage *)image;

@end
