//
//  AlbumsSaver.h
//  SmartHome
//
//  Created by Zhao yang on 10/28/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlbumsSaver : NSObject

- (void)saveToAlbumsWithImage:(UIImage *)image success:(void (^)())s failed:(void (^)())f;

@end
