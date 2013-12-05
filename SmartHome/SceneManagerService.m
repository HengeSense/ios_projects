//
//  SceneManagerService.m
//  SmartHome
//
//  Created by Zhao yang on 12/5/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "SceneManagerService.h"
#import "SMShared.h"

@implementation SceneManagerService

- (id)init {
    self = [super init];
    if(self) {
        [self setupWithUrl:[NSString stringWithFormat:@"%@/mgr/scene", [SMShared current].settings.restAddress]];
    }
    return self;
}

- (void)saveScenePlan:(ScenePlan *)plan success:(SEL)s error:(SEL)e target:(id)t callback:(id)cb {
    NSString *url = [NSString stringWithFormat:@"/%@?deviceCode=%@&appKey=%@&security=%@", plan.identifier, [SMShared current].settings.deviceCode, APP_KEY, [SMShared current].settings.secretKey];
    [self.client putForUrl:url acceptType:@"text/*" contentType:@"text/html" body:[JsonUtils createJsonDataFromDictionary:[plan toJson]] success:s error:e for:t callback:cb];
}

- (void)getAllScenePlans:(SEL)s error:(SEL)e target:(id)t callback:(id)cb {
    NSString *url = [NSString stringWithFormat:@"/list/%@?deviceCode=%@&appKey=%@&security=%@", [SMShared current].settings.deviceCode, [SMShared current].settings.deviceCode, APP_KEY, [SMShared current].settings.secretKey];
    [self.client getForUrl:url acceptType:@"text/*" success:s error:e for:t callback:cb];
}

@end
