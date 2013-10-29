//
//  VideoConverter.h
//  SmartHome
//
//  Created by Zhao yang on 10/28/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>

#define VIDEO_DIRECTORY [[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"smarthome-videos"] stringByAppendingString:[SMShared current].settings.account]

@interface VideoConverter : NSObject

@end
