//
//  DeviceCommandGetAccountHandler.h
//  SmartHome
//
//  Created by Zhao yang on 9/3/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "DeviceCommandHandler.h"
#import "DeviceCommandUpdateAccount.h"
#import "DeviceCommandUpdateAccountHandler.h"

@protocol DeviceCommandGetAccountDelegate <NSObject>

- (void)getAccountOnComplete:(DeviceCommandUpdateAccount *)updateCommand;

@end

@interface DeviceCommandGetAccountHandler : DeviceCommandHandler

@end
