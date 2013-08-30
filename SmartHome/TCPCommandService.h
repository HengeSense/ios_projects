//
//  TCPCommandService.h
//  SmartHome
//
//  Created by Zhao yang on 8/28/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommunicationMessage.h"
#import "ExtranetClientSocket.h"

@interface TCPCommandService : NSObject<MessageHandler>

- (void)executeDeviceCommand:(DeviceCommand *)command;

@end
