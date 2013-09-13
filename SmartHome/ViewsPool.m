//
//  ViewsPool.m
//  SmartHome
//
//  Created by Zhao yang on 8/5/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "ViewsPool.h"
#import "NSString+StringUtils.h"

@implementation ViewsPool {
    NSMutableDictionary *pool;
}

- (id)init {
    self = [super init];
    if(self) {
        [self initDefaults];
    }
    return self;
}

+ (ViewsPool *)sharedPool {
    static ViewsPool *instance = nil;
    if(instance == nil) {
        instance = [[ViewsPool alloc] init];
    }
    return instance;
}

- (void)initDefaults {
    if(pool == nil) {
        pool = [NSMutableDictionary dictionary];
    }
}

- (UIView *)viewWithIdentifier:(NSString *)identifier {
    return [pool objectForKey:identifier];
}

- (void)putView:(UIView *)view forIdentifier:(NSString *)identifier {
    if([NSString isEmpty:identifier]) return;
    UIView *v = [self viewWithIdentifier:identifier];
    if(v) {
        [pool removeObjectForKey:identifier];
    }
    if(view) {
        [pool setObject:view forKey:identifier];
    }
}

- (void)clear {
    if(pool != nil) {
        [pool removeAllObjects];
    }
}

@end
