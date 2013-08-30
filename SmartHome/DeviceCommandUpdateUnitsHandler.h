//
//  DeviceCommandUpdateUnitsHandler.h
//  SmartHome
//
//  Created by hadoop user account on 30/08/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "DeviceCommandHandler.h"
#import "DeviceCommandUpdateUnits.h"
@protocol UpdateUnitsHandlerDelegate<NSObject>
- (void) updateUnits:(NSArray *) uints;
@end
@interface DeviceCommandUpdateUnitsHandler : DeviceCommandHandler
@property (assign,nonatomic) id<UpdateUnitsHandlerDelegate> delegate;
-(void) registerUsersForUnitsUpdate:(id) user;
@end
