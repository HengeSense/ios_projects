//
//  SwitchButton.m
//  SmartHome
//
//  Created by Zhao yang on 8/21/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "SwitchButton.h"
#import "NSString+StringUtils.h"

@implementation SwitchButton {
    UIButton *btn;
    UILabel *lblTitle;
    NSMutableDictionary *statusImage;
}

@synthesize title;
@synthesize status;

#pragma mark -
#pragma mark initializations

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initDefaults];
        [self initUI];
    }
    return self;
}

- (void)initDefaults {
    if(statusImage == nil) {
        statusImage = [NSMutableDictionary dictionary];
    }
}

- (void)initUI {
    if(btn == nil) {
        btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    }
    
    if(lblTitle == nil) {
        lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    }
}

+ (SwitchButton *)buttonWithPoint:(CGPoint)point {
    SwitchButton *switchButton = [[SwitchButton alloc] initWithFrame:CGRectMake(point.x, point.y, 0, 0)];
    return switchButton;
}

#pragma mark -
#pragma mark services

- (void)registerImage:(UIImage *)img forStatus:(NSString *)s {
    if(statusImage == nil) return;
    [statusImage setObject:img forKey:s];
}

- (void)setStatus:(NSString *)s {
    if([NSString isEmpty:status]) return;
    if(statusImage == nil) return;
    UIImage *image = [statusImage objectForKey:s];
    if(image == nil || btn == nil) return;
    [btn setBackgroundImage:image forState:UIControlStateNormal];
    [btn setBackgroundImage:image forState:UIControlStateHighlighted];
}


- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents {
    if(btn != nil) {
        [btn addTarget:target action:action forControlEvents:controlEvents];
    }
}

@end
