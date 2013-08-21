//
//  DirectionButton.h
//  SmartHome
//
//  Created by Zhao yang on 8/21/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DirectionButtonDelegate <NSObject>

- (void)leftButtonClicked;
- (void)rightButtonClicked;
- (void)centerButtonClicked;
- (void)topButtonClicked;
- (void)bottomButtonClicked;

@end

@interface DirectionButton : UIView

@property (assign, nonatomic) id<DirectionButtonDelegate> delegate;

+ (DirectionButton *)directionButtonWithPoint:(CGPoint)point;

@end
