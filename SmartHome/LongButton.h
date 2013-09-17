//
//  LongButton.h
//  SmartHome
//
//  Created by hadoop user account on 16/08/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CameraPicPath.h"
@interface LongButton : UIButton
@property (strong,nonatomic) CameraPicPath *cameraPicPath;
+ (UIButton *)buttonWithPoint:(CGPoint)point;
+ (UIButton *)darkButtonWithPoint:(CGPoint)point;
-(id) initWithCameraPicPath:(CameraPicPath *) path atPoint:(CGPoint) point;
@end
