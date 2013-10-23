//
//  DeviceCommandCheckVersionHandler.h
//  SmartHome
//
//  Created by hadoop user account on 23/10/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "DeviceCommandHandler.h"
@protocol DeviceCommandCheckVersionHandlerDelegate<NSObject>
-(void)didCheckVersionComplete:(DeviceCommand *) command;
@end
@interface DeviceCommandCheckVersionHandler : DeviceCommandHandler

@end
