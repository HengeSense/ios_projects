//
//  TVRemoteControlPanel.h
//  SmartHome
//
//  Created by Zhao yang on 9/4/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DirectionButton.h"
#import "SMButton.h"
#import "Device.h"

@protocol TVRemoteControlPanelDelegate <NSObject>

- (void)TVRemoteControlBunttonPressed:(NSString *)source;

@end

@interface TVRemoteControlPanel : UIView<DirectionButtonDelegate>

@property (strong, nonatomic) Device *device;

+ (TVRemoteControlPanel *)pannelWithPoint:(CGPoint)point;

@end
