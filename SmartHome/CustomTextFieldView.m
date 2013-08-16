//
//  CustomTextFieldView.m
//  SmartHome
//
//  Created by hadoop user account on 16/08/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "CustomTextFieldView.h"

@implementation CustomTextFieldView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (UITextField *)textFieldWithPoint:(CGPoint)point{
    UITextField *text = [[UITextField alloc] initWithFrame:CGRectMake(point.x, point.y, 616/2, 96/2)];
    [text setBackground:[UIImage imageNamed:@"bg_text_field.png"]];
    return text;

    
}
@end
