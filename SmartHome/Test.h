//
//  Test.h
//  SmartHome
//
//  Created by Zhao yang on 8/15/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ClientSocketDelegate <NSObject>

@end

@interface Test : NSObject<NSStreamDelegate>

@property (assign, nonatomic) id<ClientSocketDelegate> delegate;
@property (strong, nonatomic) NSString *ipAddress;
@property (assign, nonatomic) NSInteger port;

@end
