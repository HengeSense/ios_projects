//
//  DeviceFinder.h
//  SmartHome
//
//  Created by Zhao yang on 8/27/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AsyncUdpSocket.h"

@interface DeviceFinder : NSObject<AsyncUdpSocketDelegate>

+ (void)startFindingDevice;

@end