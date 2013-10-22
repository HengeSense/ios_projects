//
//  BaseViewController.m
//  SmartHome
//
//  Created by Zhao yang on 8/9/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "BaseViewController.h"
#import "UIColor+ExtentionForHexString.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

#pragma mark -
#pragma mark About first responder

- (void)registerTapGestureToResignKeyboard {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] init];
    [tapGesture addTarget:self action:@selector(triggerTapGestureEventForResignKeyboard:)];
    [self.view addGestureRecognizer:tapGesture];
}

- (void)triggerTapGestureEventForResignKeyboard:(UIGestureRecognizer *)gesture {
    [self resignFirstResponderFor:self.view];
}

- (void)resignFirstResponderFor:(UIView *)view {
    for (UIView *v in view.subviews) {
        if([v isFirstResponder]) {
            [v resignFirstResponder];
            return;
        }
    }
}

#pragma mark -
#pragma mark Initializations

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initDefaults];
    [self initUI];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)initDefaults {
}

- (void)initUI {
    if([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    if([self respondsToSelector:@selector(setExtendedLayoutIncludesOpaqueBars:)]) {
        self.extendedLayoutIncludesOpaqueBars = NO;
    }
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#3a3e47"];
}

@end
