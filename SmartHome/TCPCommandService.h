//
//  TCPCommandService.h
//  SmartHome
//
//  Created by Zhao yang on 8/28/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DeviceCommandDeliveryService.h"
#import "CommunicationMessage.h"
#import "ExtranetClientSocket.h"

@interface TCPCommandService : DeviceCommandDeliveryService<MessageHandler>


@end
