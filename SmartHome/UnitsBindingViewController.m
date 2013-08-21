//
//  UnitsBindingViewController.m
//  SmartHome
//
//  Created by Zhao yang on 8/15/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "UnitsBindingViewController.h"

#import "ExtranetClientSocket.h"
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
    UIButton *autoSearchBtn;
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
    self.topbar.titleLabel.text = NSLocalizedString(@"scanner.and.finder", @"");
    self.topbar.titleLabel.font = [UIFont systemFontOfSize:18];
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:
        CGRectMake(0, self.topbar.frame.size.height, [UIScreen mainScreen].bounds.size.width, ([UIScreen mainScreen].bounds.size.height - self.topbar.frame.size.height - 20))];
    backgroundImageView.image = [UIImage imageNamed:@"bg_scanner.png"];
    [self.view addSubview:backgroundImageView];
    
    
    UIImageView *scannerShadow;
    UIImageView *finderShadow;
    //QR Code scanner button
    if(btnQRCodeScanner == nil) {
        btnQRCodeScanner = [[UIButton alloc] initWithFrame:CGRectMake(25, 150, 253/2, 88/2)];
        [btnQRCodeScanner setBackgroundImage:[UIImage imageNamed:@"btn_scanner.png"] forState:UIControlStateNormal];
        [btnQRCodeScanner addTarget:self action:@selector(btnQRCodeScannerPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnQRCodeScanner];
    }
    
    if(autoSearchBtn == nil){
        autoSearchBtn = [[UIButton alloc] initWithFrame:CGRectMake(25+btnQRCodeScanner.frame.size.width+17, 150, 253/2, 88/2)];
        [autoSearchBtn setBackgroundImage:[UIImage imageNamed:@"btn_finder.png"] forState:UIControlStateNormal];
        [self.view addSubview:autoSearchBtn];
    }
    //add button shadow
    scannerShadow = [[UIImageView alloc] initWithFrame:CGRectMake(25, btnQRCodeScanner.frame.origin.y+btnQRCodeScanner.frame.size.height, 253/2, 88/2)];
    scannerShadow.image = [UIImage imageNamed:@"bg_scanner_shadow.png"];
    [self.view addSubview:scannerShadow];
    
    finderShadow = [[UIImageView alloc] initWithFrame:CGRectMake(25+scannerShadow.frame.size.width+17, scannerShadow.frame.origin.y, 253/2, 88/2)];
    finderShadow.image = [UIImage imageNamed:@"bg_finder_shadow.png"];
    [self.view addSubview:finderShadow];
    
    
    //Done button to main view
    if(btnDone == nil) {
        btnDone = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 120, 48)];
        [btnDone setTitle:NSLocalizedString(@"done", @"") forState:UIControlStateNormal];
        [btnDone addTarget:self action:@selector(btnDownPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnDone];
    }
    
    UILabel *scannerText;
    UILabel *finderText;
    
    scannerText = [[UILabel alloc] initWithFrame:CGRectMake(25, scannerShadow.frame.origin.y+scannerShadow.frame.size.height, 253/2, 150)];
    scannerText.numberOfLines = 4;
    scannerText.backgroundColor = [UIColor clearColor];
    scannerText.textColor = [UIColor whiteColor];
    scannerText.font = [UIFont systemFontOfSize:12];
    scannerText.text = @"   在有无线网络的情况下，你可以采用功能扫一扫将主控设备录入手机。";
    [self.view addSubview:scannerText];
    
    finderText = [[UILabel alloc] initWithFrame:CGRectMake(25+scannerText.frame.size.width+17, scannerText.frame.origin.y, 253/2, 150)];
    finderText.backgroundColor = [UIColor clearColor];
    finderText.textColor = [UIColor whiteColor];
    finderText.font = [UIFont systemFontOfSize:12];
    finderText.numberOfLines = 5;
    finderText.text = @"    在没有无线网络的情况下，你可以采用自动寻找功能将主控录入手机。";
    [self.view addSubview:finderText];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(100, 50, 120, 21)];
    [btn addTarget:self action:@selector(fff) forControlEvents:UIControlEventTouchUpInside];
    
    [btn setTitle:@"test" forState:UIControlStateNormal];
    
    [self.view addSubview:btn];
}

- (void)fff {
    
    ExtranetClientSocket *socket = [[ExtranetClientSocket alloc] initWithIPAddress:@"127.0.0.1" andPort:8888];
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
