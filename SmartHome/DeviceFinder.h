//
//  DeviceFinder.h
//  SmartHome
//
//  Created by Zhao yang on 8/27/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AsyncUdpSocket.h"
@protocol DeviceFinderDelegate<NSObject>
-(void) askwhetherBinding;
@end
@interface DeviceFinder : NSObject<AsyncUdpSocketDelegate>
@property (strong,nonatomic) NSString *deviceIdentifier;
@property (assign,nonatomic) id<DeviceFinderDelegate> delegate;
- (void)startFindingDevice;
-(void)requestForBindingUnit;
@end
