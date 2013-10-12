//
//  ViewsPool.m
//  SmartHome
//
//  Created by Zhao yang on 8/5/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "ViewsPool.h"
#import "NavigationView.h"
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
    @synchronized(self) {
        return [pool objectForKey:identifier];
    }
}

- (void)putView:(UIView *)view forIdentifier:(NSString *)identifier {
    @synchronized(self) {
        if([NSString isEmpty:identifier]) return;
        UIView *v = [self viewWithIdentifier:identifier];
        if(v) {
            if([v isKindOfClass:[NavigationView class]]) {
                NavigationView *view = (NavigationView *)v;
                [view destory];
            }
            [pool removeObjectForKey:identifier];
        }
        if(view) {
            [pool setObject:view forKey:identifier];
        }
    }
}

- (void)clear {
    @synchronized(self) {
        if(pool != nil) {
            for(NSString *key in pool.allKeys) {
                NavigationView *view = [pool objectForKey:key];
                if(view != nil) {
                    [view destory];
                }
            }
            [pool removeAllObjects];
        }
    }
}

@end
