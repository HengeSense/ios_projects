//
//  ScenePlanFileManager.h
//  SmartHome
//
//  Created by Zhao yang on 12/4/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ScenePlan.h"

@interface ScenePlanFileManager : NSObject

+ (ScenePlanFileManager *)fileManager;

- (void)saveScenePlan:(ScenePlan *)scenePlan;
- (ScenePlan *)syncScenePlan:(ScenePlan *)scenePlan;
- (void)deleteAllScenePlan;

@end
