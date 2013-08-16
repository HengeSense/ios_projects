//
//  ModifyInfoViewController.m
//  SmartHome
//
//  Created by hadoop user account on 16/08/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "ModifyInfoViewController.h"

#define DONE_BUTTON_WIDTH  44
#define DONE_BUTTON_HEIGHT 44

@interface ModifyInfoViewController ()

@end

@implementation ModifyInfoViewController

@synthesize delegate;

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initDefaults {
    
}

- (void)initUI {
    [super initUI];
    self.topbar.rightButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - DONE_BUTTON_WIDTH, 0, DONE_BUTTON_WIDTH, DONE_BUTTON_HEIGHT);
    [self.topbar.rightButton setTitle:NSLocalizedString(@"done", @"") forState:UIControlStateNormal];
    [self.topbar.rightButton addTarget:self action:@selector(btnDownPressed:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)btnDownPressed:(id)sender {
    if(self.delegate != nil && [self.delegate respondsToSelector:@selector(textViewHasBeenSetting:)]) {
        [self.delegate textViewHasBeenSetting:@"  "];
    }
    [self dismissModalViewControllerAnimated:YES];
}

@end
