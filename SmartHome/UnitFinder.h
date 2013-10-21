//
//  UnitFinder.h
//  SmartHome
//
//  Created by Zhao yang on 8/27/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AsyncUdpSocket.h"

@protocol UnitFinderDelegate<NSObject>

- (void)findUnitFailed:(NSError *)error;
- (void)findUnitSuccessWithIdentifier:(NSString *)unitIdentifier url:(NSString *)unitUrl;

@end

@interface UnitFinder : NSObject<AsyncUdpSocketDelegate>

@property (assign, nonatomic) id<UnitFinderDelegate> delegate;

- (void)findUnit;

@end
