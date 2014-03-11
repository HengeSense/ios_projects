//
//  SMButton.h
//  SmartHome
//
//  Created by Zhao yang on 9/4/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParameterExtentions.h"

@protocol LongPressDelegate;

@interface SMButton : UIButton<ParameterExtentions>

@property (strong, nonatomic) NSString *identifier;
@property (strong, nonatomic) id userObject;
@property (strong, nonatomic) NSMutableDictionary *parameters;
@property (weak, nonatomic) id<LongPressDelegate> longPressDelegate;

@end

@protocol LongPressDelegate <NSObject>

- (void)smButtonLongPressed:(SMButton *)button;

@end


