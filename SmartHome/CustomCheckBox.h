//
//  CustomCheckBox.h
//  SmartHome
//
//  Created by hadoop user account on 22/08/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CustomCheckBoxDelegate <NSObject>
-(void) checkBoxTouchInside;


@end

@interface CustomCheckBox : UIButton
@property (assign,nonatomic) id<CustomCheckBoxDelegate> delegate;
+(UIButton *) checkBoxWithPoint:(CGPoint)point;
@end
