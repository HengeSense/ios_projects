//
//  SMButton.h
//  SmartHome
//
//  Created by Zhao yang on 9/4/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParameterExtentions.h"

@interface SMButton : UIButton<ParameterExtentions>

@property (strong, nonatomic) id source;

@end
