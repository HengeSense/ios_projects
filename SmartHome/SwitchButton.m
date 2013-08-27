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
@synthesize ownerController;

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
        btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 28, 28)];
        btn.center = CGPointMake(self.bounds.size.width / 2, btn.center.y);
        [btn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
    
    if(lblTitle == nil) {
        lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 31, 70, 21)];
        lblTitle.center = CGPointMake(self.bounds.size.width / 2, lblTitle.center.y);
        lblTitle.font = [UIFont systemFontOfSize:13.f];
        lblTitle.textAlignment = NSTextAlignmentCenter;
        lblTitle.textColor = [UIColor lightTextColor];
        lblTitle.backgroundColor = [UIColor clearColor];
        [self addSubview:lblTitle];
    }
}

+ (SwitchButton *)buttonWithPoint:(CGPoint)point owner:(UIViewController *)owner {
    SwitchButton *switchButton = [[SwitchButton alloc] initWithFrame:CGRectMake(point.x, point.y, 70, 52)];
    switchButton.ownerController = owner;
    return switchButton;
}

#pragma mark -
#pragma mark services

- (void)registerImage:(UIImage *)img forStatus:(NSString *)s {
    if(statusImage == nil) return;
    [statusImage setObject:img forKey:s];
}

- (void)setStatus:(NSString *)s {
    if([NSString isEmpty:s]) return;
    status = s;
    if(statusImage == nil) return;
    UIImage *image = [statusImage objectForKey:s];
    if(image == nil || btn == nil) return;
    [btn setBackgroundImage:image forState:UIControlStateNormal];
    [btn setBackgroundImage:image forState:UIControlStateHighlighted];
}

- (void)setTitle:(NSString *)t {
    if([NSString isBlank:t]) t = [NSString emptyString];
    if(lblTitle == nil) return;
    lblTitle.text = t;
}

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents {
    if(btn != nil) {
        [btn addTarget:target action:action forControlEvents:controlEvents];
    }
}

#pragma mark -
#pragma mark event

- (void)btnPressed:(id)sender {
    
}

@end
