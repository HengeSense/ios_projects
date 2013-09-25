//
//  RestfulCommandService.m
//  SmartHome
//
//  Created by Zhao yang on 9/2/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "RestfulCommandService.h"
#import "NSString+StringUtils.h"
#import "SMShared.h"

@implementation RestfulCommandService

- (id)init {
    self = [super init];
    if(self) {
        [super setupWithUrl:[NSString emptyString]];
    }
    return self;
}

- (void)getUnitByIdentifier:(NSString *)unitIdentifier {
    Unit *unit = [[SMShared current].memory findUnitByIdentifier:unitIdentifier];
    if(unit != nil) {
        NSString *url = [NSString stringWithFormat:@"http://%@:%d/gatewaycfg?hashCode=1", unit.localIP, unit.localPort];
        [self getUnitByUrl:url];
    }
}

- (void)getUnitByUrl:(NSString *)url {
    [self.client getForUrl:url acceptType:@"application/json" success:@selector(getUnitSucess:) error:@selector(getUnitFailed:) for:[SMShared current].deliveryService callback:nil];
}

@end
