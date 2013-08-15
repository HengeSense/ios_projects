//
//  UnitsBindingViewController.m
//  SmartHome
//
//  Created by Zhao yang on 8/15/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "UnitsBindingViewController.h"
#import "QRCodeScannerViewController.h"


@interface UnitsBindingViewController ()

@end

@implementation UnitsBindingViewController {
    UIButton *btnDone;
    UIButton *btnQRCodeScanner;
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
    
    //QR Code scanner button
    if(btnQRCodeScanner == nil) {
        btnQRCodeScanner = [[UIButton alloc] initWithFrame:CGRectMake(120.0f, 150.0f, 150.0f, 40.0f)];
        [btnQRCodeScanner setTitle:NSLocalizedString(@"zbar_scanner", @"") forState:UIControlStateNormal];
        [btnQRCodeScanner addTarget:self action:@selector(btnQRCodeScannerPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnQRCodeScanner];
    }
    
    //Done button to main view
    if(btnDone == nil) {
        btnDone = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 120, 48)];
        [btnDone setTitle:NSLocalizedString(@"done", @"") forState:UIControlStateNormal];
        [btnDone addTarget:self action:@selector(btnDownPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnDone];
    }
}

- (void)btnDownPressed:(id)sender {
    self.app.rootViewController.needLoadMainViewController = YES;
    [self.navigationController popToRootViewControllerAnimated:NO];
}

- (void)btnQRCodeScannerPressed:(id)sender {
    [self presentModalViewController:[[QRCodeScannerViewController alloc] init] animated:YES];
}

@end
