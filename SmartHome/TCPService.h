//
//  TCPService.h
//  SmartHome
//
//  Created by Zhao yang on 8/28/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DeviceCommand.h"
#import "ExtranetClientSocket.h"

@interface TCPService : NSObject<MessageHandler>

- (void)executeCommand:(DeviceCommand *)command;

@end
