//
//  SceneManagerService.h
//  SmartHome
//
//  Created by Zhao yang on 12/5/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "ServiceBase.h"
#import "ScenePlan.h"

@interface SceneManagerService : ServiceBase

- (void)saveScenePlan:(ScenePlan *)plan success:(SEL)s error:(SEL)e target:(id)t callback:(id)cb;
- (void)getAllScenePlans:(SEL)s error:(SEL)e target:(id)t callback:(id)cb;

@end
