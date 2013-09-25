//
//  TCPCommandService.h
//  SmartHome
//
//  Created by Zhao yang on 8/28/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommunicationMessage.h"
#import "SMCommandQueue.h"
#import "CommandExecutor.h"
#import "NSString+StringUtils.h"
#import "ExtranetClientSocket.h"

@interface TCPCommandService : NSObject<MessageHandler, CommandExecutor>

- (BOOL)isConnectted;
- (BOOL)isConnectting;

- (void)disconnect;
- (void)connect;

@end
