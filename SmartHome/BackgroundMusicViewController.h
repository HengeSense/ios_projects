//
//  BackgroundMusicViewController.h
//  SmartHome
//
//  Created by hadoop user account on 25/11/2013.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PopViewController.h"
#import "Device.h"
#import "SMButton.h"
#import "DirectionButton.h"
#import "UIColor+ExtentionForHexString.h"


@interface BackgroundMusicViewController :PopViewController <DirectionButtonDelegate>
@property (strong, nonatomic) Device *device;
- (id)initWithDevice:(Device *) device_;
@end
