//
//  UnitsBindingViewController.m
//  SmartHome
//
//  Created by Zhao yang on 8/15/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "UnitsBindingViewController.h"
#import "NSString+StringUtils.h"
#import "DeviceCommand.h"
#import "CommunicationMessage.h"
#import "ClientSocket.h"
#import "BitUtils.h"

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

#pragma mark -
#pragma mark initializations

- (void)initDefaults {
}

- (void)initUI {
    [super initUI];
    
    //QR Code scanner button
    if(btnQRCodeScanner == nil) {
        btnQRCodeScanner = [[UIButton alloc] initWithFrame:CGRectMake(120.0f, 150.0f, 150.0f, 40.0f)];
        [btnQRCodeScanner setTitle:NSLocalizedString(@"qr_code_scanner", @"") forState:UIControlStateNormal];
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
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(100, 50, 120, 21)];
    [btn addTarget:self action:@selector(fff) forControlEvents:UIControlEventTouchUpInside];
    
    [btn setTitle:@"test" forState:UIControlStateNormal];
    
    [self.view addSubview:btn];
}

- (void)fff {
    ClientSocket *socket = [[ClientSocket alloc] initWithIPAddress:@"172.16.8.123" andPort:6969];
    [socket connect];
}

#pragma mark -
#pragma mark services

- (void)showMainView {
    self.app.rootViewController.needLoadMainViewController = YES;
    [self.navigationController popToRootViewControllerAnimated:NO];
}

#pragma mark -
#pragma mark events

- (void)btnDownPressed:(id)sender {
    [self showMainView];
}

- (void)btnQRCodeScannerPressed:(id)sender {
    QRCodeScannerViewController *scannerViewController = [[QRCodeScannerViewController alloc] init];
    scannerViewController.delegate = self;
    [self presentModalViewController:scannerViewController animated:YES];
}

#pragma mark -
#pragma mark QR code delegate

- (void)qrCodeScannerSuccess:(NSString *)result scanner:(UIViewController *)scannerViewController {
    NSLog(@"processing qr code %@", result);
    [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(test:) userInfo:scannerViewController repeats:NO];
}

- (void)test:(NSTimer *)timer {
    UIViewController *viewController = timer.userInfo;
    [self showMainView];
    [viewController dismissModalViewControllerAnimated:YES];
}

@end
