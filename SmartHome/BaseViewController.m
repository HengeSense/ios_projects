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
        }
    }
}

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
    // Dispose of any resources that can be recreated.
}

- (void)initDefaults {
    
}

- (void)initUI {
//    UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:
//     CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 20)];
//    backgroundImageView.image = [UIImage imageNamed:@"bg.png"];
//    [self.view addSubview:backgroundImageView];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#3a3e47"];
}

@end
