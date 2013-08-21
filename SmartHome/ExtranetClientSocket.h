//
//  ExtranetClientSocket.h
//  SmartHome
//
//  Created by Zhao yang on 8/20/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "ClientSocket.h"

@protocol MessageHandler <NSObject>



@end

@interface ExtranetClientSocket : ClientSocket

@property (assign, nonatomic) id<MessageHandler> messageHandlerDelegate;

@end
