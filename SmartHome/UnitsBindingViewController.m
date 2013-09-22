//
//  UnitsBindingViewController.m
//  SmartHome
//
//  Created by Zhao yang on 8/15/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "UnitsBindingViewController.h"
#import "LoginViewController.h"

@interface UnitsBindingViewController ()

@end

@implementation UnitsBindingViewController {
    UIButton *btnDone;
    UIButton *btnQRCodeScanner;
    UIButton *btnAutoSearch;
}

@synthesize topbar;

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
    [self generateTopbar];
    CGFloat y = [UIDevice systemVersionIsMoreThanOrEuqal7] ? 0 : 20;
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:
        CGRectMake(0, self.topbar.frame.size.height, [UIScreen mainScreen].bounds.size.width, ([UIScreen mainScreen].bounds.size.height - self.topbar.frame.size.height - y))];
    backgroundImageView.image = [UIImage imageNamed:@"bg_scanner.png"];
    [self.view addSubview:backgroundImageView];
    
    //QR Code scanner button
    if(btnQRCodeScanner == nil) {
        btnQRCodeScanner = [[UIButton alloc] initWithFrame:CGRectMake(25, 150, 253/2, 88/2)];
        [btnQRCodeScanner setBackgroundImage:[UIImage imageNamed:@"btn_scanner.png"] forState:UIControlStateNormal];
        [btnQRCodeScanner addTarget:self action:@selector(btnQRCodeScannerPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnQRCodeScanner];
    }
    
    if(btnAutoSearch == nil){
        btnAutoSearch = [[UIButton alloc] initWithFrame:CGRectMake(25+btnQRCodeScanner.frame.size.width+17, 150, 253/2, 88/2)];
        [btnAutoSearch setBackgroundImage:[UIImage imageNamed:@"btn_finder.png"] forState:UIControlStateNormal];
        [self.view addSubview:btnAutoSearch];
    }
    
    //add button shadow
    UIImageView *scannerShadow = [[UIImageView alloc] initWithFrame:CGRectMake(25, btnQRCodeScanner.frame.origin.y+btnQRCodeScanner.frame.size.height, 253/2, 88/2)];
    scannerShadow.image = [UIImage imageNamed:@"bg_scanner_shadow.png"];
    [self.view addSubview:scannerShadow];
    
    UIImageView *finderShadow = [[UIImageView alloc] initWithFrame:CGRectMake(25+scannerShadow.frame.size.width+17, scannerShadow.frame.origin.y, 253/2, 88/2)];
    finderShadow.image = [UIImage imageNamed:@"bg_finder_shadow.png"];
    [self.view addSubview:finderShadow];
    
    UILabel *lblForBtnScanner = [[UILabel alloc] initWithFrame:CGRectMake(25, scannerShadow.frame.origin.y+scannerShadow.frame.size.height, 253/2, 150)];
    lblForBtnScanner.numberOfLines = 4;
    lblForBtnScanner.backgroundColor = [UIColor clearColor];
    lblForBtnScanner.textColor = [UIColor whiteColor];
    lblForBtnScanner.font = [UIFont systemFontOfSize:12];
    lblForBtnScanner.text = NSLocalizedString(@"scanner_button_tips", @"");
    [self.view addSubview:lblForBtnScanner];
    
    UILabel *lblForBtnAutoSearch = [[UILabel alloc] initWithFrame:CGRectMake(25+lblForBtnScanner.frame.size.width+17, lblForBtnScanner.frame.origin.y, 253/2, 150)];
    lblForBtnAutoSearch.backgroundColor = [UIColor clearColor];
    lblForBtnAutoSearch.textColor = [UIColor whiteColor];
    lblForBtnAutoSearch.font = [UIFont systemFontOfSize:12];
    lblForBtnAutoSearch.numberOfLines = 5;
    lblForBtnAutoSearch.text = NSLocalizedString(@"auto_search_button_tips", @"");
    [self.view addSubview:lblForBtnAutoSearch];
}

- (void)generateTopbar {
    self.topbar = [TopbarView topBarWithImage:[UIImage imageNamed:@"bg_topbar.png"] shadow:NO];
    self.topbar.rightButton = [[UIButton alloc] initWithFrame:CGRectMake(self.topbar.frame.size.width - 101/2 - 8, [UIDevice systemVersionIsMoreThanOrEuqal7] ? 28 : 8, 101/2, 59/2)];
    [self.topbar addSubview:self.topbar.rightButton];
    [self.topbar.rightButton setBackgroundImage:[UIImage imageNamed:@"btn_done.png"] forState:UIControlStateNormal];
    [self.topbar.rightButton setTitle:NSLocalizedString(@"skip", @"") forState:UIControlStateNormal];
    self.topbar.rightButton.titleLabel.font = [UIFont systemFontOfSize:15.f];
    self.topbar.rightButton.titleLabel.textColor = [UIColor lightTextColor];
    [self.topbar.rightButton addTarget:self action:@selector(btnDownPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.topbar.rightButton.titleLabel.textColor = [UIColor lightGrayColor];
    [self.view addSubview:self.topbar];
    self.topbar.titleLabel.text = NSLocalizedString(@"unit_binding_view.title", @"btn_done.png");
}

#pragma mark -
#pragma mark services

- (void)showMainView {
    ((LoginViewController *)[SMShared current].app.rootViewController).hasLogin = YES;
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
