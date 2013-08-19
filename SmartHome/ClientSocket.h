//
//  ClientSocket.h
//  SmartHome
//
//  Created by Zhao yang on 8/15/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ClientSocketDelegate <NSObject>

// maybe call twice, one for input stream another for output stream
- (void)streamConnectionDidOpen:(NSStream *)stream;

- (void)didReceiveData:(NSData *)data stream:(NSStream *)stream;

/*
- (void)outputStreamIsReady;
 */

- (void)connectionEnded;
- (void)connectionError:(NSError *)error;

@end

@interface ClientSocket : NSObject<NSStreamDelegate>

@property (assign, nonatomic) id<ClientSocketDelegate> delegate;
@property (strong, nonatomic) NSString *ipAddress;
@property (assign, nonatomic) NSInteger port;


- (id)initWithIPAddress:(NSString *)ip andPort:(NSInteger)portNumber;

- (void)connect;

@end
