//
//  CameraAdjustViewController.h
//  SmartHome
//
//  Created by hadoop user account on 21/08/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PopViewController.h"
#import "DirectionButton.h"

#import "ExtranetClientSocket.h"

@interface CameraAdjustViewController : PopViewController<DirectionButtonDelegate, MessageHandler>


@end
