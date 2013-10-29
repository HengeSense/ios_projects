//
//  AlbumsSaver.m
//  SmartHome
//
//  Created by Zhao yang on 10/28/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "AlbumsSaver.h"

@implementation AlbumsSaver {
    void (^success)();
    void (^failed)();
    BOOL isSaving;
}

- (void)saveToAlbumsWithImage:(UIImage *)image success:(void (^)())s failed:(void (^)())f {
    if(isSaving) {
        f();
        return;
    }
    
    if(image == nil) {
        f();
        return;
    }
    
    isSaving = YES;
    success = s;
    failed = f;
    
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(saveComplete:), nil);
}

- (void)saveComplete:(id)sender {
    isSaving = NO;
    success();
}

@end
