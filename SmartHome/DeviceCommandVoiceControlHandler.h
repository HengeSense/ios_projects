//
//  DeviceCommandVoiceControlHandler.h
//  SmartHome
//
//  Created by Zhao yang on 9/5/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "DeviceCommandHandler.h"
#import "DeviceCommandVoiceControl.h"

@protocol DeviceCommandVoiceControlDelegate <NSObject>

- (void)notifyVoiceControlAccept:(DeviceCommandVoiceControl *)command;

@end

@interface DeviceCommandVoiceControlHandler : DeviceCommandHandler

@end
