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

- (void)executeCommand:(DeviceCommand *)command {
    
}

- (NSString *)executorName {
    return @"RESTFUL SERVICE";
}

- (void)getUnitByIdentifier:(NSString *)unitIdentifier {
    Unit *unit = [[SMShared current].memory findUnitByIdentifier:unitIdentifier];
    if(unit != nil) {
        NSString *url = [NSString stringWithFormat:@"http://%@:%d/gatewaycfg?hashCode=1", unit.localIP, unit.localPort];
        [self getUnitByUrl:url];
    }
}

- (void)getUnitByUrl:(NSString *)url {
    [self.client getForUrl:url acceptType:@"application/json" success:@selector(getUnitSucess:) error:@selector(getUnitFailed:) for:self callback:nil];
}

- (void)getUnitSucess:(RestResponse *)resp {
    if(resp.statusCode == 200) {
        NSDictionary *json = [JsonUtils createDictionaryFromJson:resp.body];
        if(json != nil) {
            Unit *unit = [[Unit alloc] initWithJson:json];
            if(unit != nil) {
                DeviceCommandUpdateUnits *updateUnit = [[DeviceCommandUpdateUnits alloc] init];
                updateUnit.commandName = @"FindZKListCommand";
                updateUnit.masterDeviceCode = unit.identifier;
                [updateUnit.units addObject:unit];
                [[SMShared current].deliveryService handleDeviceCommand:updateUnit];
            }
        }
        return;
    } else if(resp.statusCode == 204) {
        NSLog(@"rest get unit is last version");
    }
    [self getUnitFailed:resp];
}

- (void)getUnitFailed:(RestResponse *)resp {
    NSLog(@"failed status code is %d", resp.statusCode);
}

@end
