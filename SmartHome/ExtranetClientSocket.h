//
//  ExtranetClientSocket.h
//  SmartHome
//
//  Created by Zhao yang on 8/20/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "ClientSocket.h"

typedef NS_ENUM(NSUInteger, DataError) {
    DataErrorBadHeader,
    DataErrorBadRequest
};

@protocol MessageHandler <NSObject>

- (void)clientSocketWithError:(DataError)error;
- (void)clientSocketWithWarning:(NSData *)dataDiscard;
- (void)clientSocketWithReceivedMessage:(NSString *)messages;

@end

@interface ExtranetClientSocket : ClientSocket

@property (assign, nonatomic) id<MessageHandler> messageHandlerDelegate;

@end
