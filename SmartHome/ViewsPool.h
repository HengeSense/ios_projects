//
//  ViewsPool.h
//  SmartHome
//
//  Created by Zhao yang on 8/5/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ViewsPool : NSObject

+ (ViewsPool *)sharedPool;

- (UIView *)viewWithIdentifier:(NSString *)identifier;
- (void)putView:(UIView *)view forIdentifier:(NSString *)identifier;
- (void)clear;

@end
