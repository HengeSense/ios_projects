//
//  LongButton.h
//  SmartHome
//
//  Created by hadoop user account on 16/08/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParameterExtentions.h"

@interface LongButton : UIButton<ParameterExtentions>

+ (LongButton *)buttonWithPoint:(CGPoint)point;
+ (LongButton *)darkButtonWithPoint:(CGPoint)point;

@end
