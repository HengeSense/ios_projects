//
//  DeviceCommandUpdateSceneMode.m
//  SmartHome
//
//  Created by Zhao yang on 9/6/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "DeviceCommandUpdateSceneMode.h"

@implementation DeviceCommandUpdateSceneMode

@synthesize scenesMode = _scenesMode;

- (id)initWithDictionary:(NSDictionary *)json {
    self = [super initWithDictionary:json];
    if(self) {
        if(json != nil) {
            NSArray *_scenes_ = [json arrayForKey:@"scenes"];
            if(_scenes_ != nil) {
                for(int i=0; i<_scenes_.count; i++) {
                    NSDictionary *_scene_ = [_scenes_ objectAtIndex:i];
                    if(_scene_ != nil) {
                        SceneMode *sceneMode = [[SceneMode alloc] initWithJson:_scene_];
                        if(sceneMode != nil) {
                            [self.scenesMode addObject:sceneMode];
                        }
                    }
                }
            }
        }
    }
    return self;
}

- (NSMutableArray *)scenesMode {
    if(_scenesMode == nil) {
        _scenesMode = [NSMutableArray array];
    }
    return _scenesMode;
}

@end
