//
//  SMTextField.h
//  SmartHome
//
//  Created by hadoop user account on 16/08/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "SMTextField.h"

@implementation SMTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (UITextField *)textFieldWithPoint:(CGPoint)point{
    SMTextField *text = [[SMTextField alloc] initWithFrame:CGRectMake(point.x, point.y, 616 / 2, 96 / 2)];
    [text setBackground:[UIImage imageNamed:@"txt_main.png"]];
    text.font = [UIFont systemFontOfSize:18.f];
    text.textColor = [UIColor darkTextColor];
    text.borderStyle = UITextBorderStyleNone;
    text.clearButtonMode = UITextFieldViewModeWhileEditing;
    return text;
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectMake(bounds.origin.x + 10, bounds.origin.y + 12, bounds.size.width - 15, bounds.size.height);
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectMake(bounds.origin.x + 10, bounds.origin.y + 12, bounds.size.width - 15, bounds.size.height);
}

- (CGRect)clearButtonRectForBounds:(CGRect)bounds {
    return CGRectMake(bounds.origin.x + 135, bounds.origin.y - 1, bounds.size.width, bounds.size.height);
}

@end
