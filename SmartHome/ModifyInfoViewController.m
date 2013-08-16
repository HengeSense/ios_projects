//
//  ModifyInfoViewController.m
//  SmartHome
//
//  Created by hadoop user account on 16/08/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "ModifyInfoViewController.h"

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
}

- (void)btnDownPressed:(id)sender {
    if(self.delegate != nil && [self.delegate respondsToSelector:@selector(textViewHasBeenSetting:)]) {
        [self.delegate textViewHasBeenSetting:@"  "];
    }
    [self dismissModalViewControllerAnimated:YES];
}

@end
