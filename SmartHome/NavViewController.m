//
//  NavViewController.m
//  SmartHome
//
//  Created by hadoop user account on 6/08/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "NavViewController.h"

@interface NavViewController ()

@end

@implementation NavViewController

@synthesize topbar;
@synthesize preViewController;

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
    [self generateTopbar];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] init];
    [tapGesture addTarget:self action:@selector(resignKeyBoardInView:)];
    [self.view addGestureRecognizer:tapGesture];

}
- (void)resignKeyBoardInView:(id)sender
{
    UIView *view = self.view;
    
    for (UIView *v in view.subviews) {
            
        if ([v isKindOfClass:[UITextView class]] || [v isKindOfClass:[UITextField class]]) {
            [v resignFirstResponder];
        } 
    } 
    
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)generateTopbar {
    self.topbar = [TopbarView topBarWithImage:[UIImage imageNamed:@"top.png"]];
    [self.topbar.leftButton setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [self.topbar.leftButton addTarget:self action:@selector(backToPreViewController) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.topbar];
}

- (void)backToPreViewController {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
