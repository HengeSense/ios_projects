//
//  DeviceCommandHandler.h
//  SmartHome
//
//  Created by Zhao yang on 8/29/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DeviceCommand.h"
#import "SMShared.h"


@interface DeviceCommandHandler : NSObject<NSCopying>

- (void)handle:(DeviceCommand *)command;

@end
