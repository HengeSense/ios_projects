//
//  DeviceCommandUpdateAccountHandler.h
//  SmartHome
//
//  Created by Zhao yang on 9/3/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "DeviceCommandHandler.h"
#import "DeviceCommandUpdateAccount.h"

@protocol DeviceCommandUpdateAccountDelegate<NSObject>
-(void) didEndUpdateAccount:(DeviceCommandUpdateAccount *) command;
@end

@interface DeviceCommandUpdateAccountHandler : DeviceCommandHandler

@end
