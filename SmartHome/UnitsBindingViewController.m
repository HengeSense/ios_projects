//
//  UnitsBindingViewController.m
//  SmartHome
//
//  Created by Zhao yang on 8/15/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "UnitsBindingViewController.h"
#import "LoginViewController.h"
#import "DeviceCommandGetUnitsHandler.h"
#import "MainViewController.h"
@interface UnitsBindingViewController ()

@end

@implementation UnitsBindingViewController {
    UIButton *btnDone;
    UIButton *btnQRCodeScanner;
    UIButton *btnAutoSearch;
    
    DeviceFinder *finder;
    
    UIAlertView *alertBinding;
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
-(id) initWithType:(NSUInteger) type{
    self = [super init];
    if (self) {
        self.topBarType = type;
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
    if (finder == nil) {
        finder = [[DeviceFinder alloc] init];
        finder.delegate = self;
    }
}

- (void)initUI {
    [self generateTopbar];
    CGFloat y = [UIDevice systemVersionIsMoreThanOrEuqal7] ? 0 : 20;
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:
        CGRectMake(0, self.topbar.frame.size.height, [UIScreen mainScreen].bounds.size.width, ([UIScreen mainScreen].bounds.size.height - self.topbar.frame.size.height - y))];
    backgroundImageView.image = [UIImage imageNamed:@"bg_scanner.png"];
    [self.view addSubview:backgroundImageView];
    
    //QR Code scanner button
//    if(btnQRCodeScanner == nil) {
//        btnQRCodeScanner = [[UIButton alloc] initWithFrame:CGRectMake(25, 150, 253/2, 88/2)];
//        [btnQRCodeScanner setBackgroundImage:[UIImage imageNamed:@"btn_scanner.png"] forState:UIControlStateNormal];
//        [btnQRCodeScanner addTarget:self action:@selector(btnQRCodeScannerPressed:) forControlEvents:UIControlEventTouchUpInside];
//        [self.view addSubview:btnQRCodeScanner];
//    }
    
    if(btnAutoSearch == nil){
        btnAutoSearch = [[UIButton alloc] initWithFrame:CGRectMake(0, 150, 253/2, 88/2)];
        btnAutoSearch.center = CGPointMake(self.view.center.x, btnAutoSearch.center.y);
        [btnAutoSearch setBackgroundImage:[UIImage imageNamed:@"btn_finder.png"] forState:UIControlStateNormal];
        [btnAutoSearch addTarget:self action:@selector(btnAutoSearchPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnAutoSearch];
    }
    
    //add button shadow
//    UIImageView *scannerShadow = [[UIImageView alloc] initWithFrame:CGRectMake(25, btnQRCodeScanner.frame.origin.y+btnQRCodeScanner.frame.size.height, 253/2, 88/2)];
//    scannerShadow.image = [UIImage imageNamed:@"bg_scanner_shadow.png"];
//    [self.view addSubview:scannerShadow];
    
    UIImageView *finderShadow = [[UIImageView alloc] initWithFrame:CGRectMake(btnAutoSearch.frame.origin.x, btnAutoSearch.frame.origin.y+btnAutoSearch.frame.size.height, 253/2, 88/2)];
    finderShadow.image = [UIImage imageNamed:@"bg_finder_shadow.png"];
    [self.view addSubview:finderShadow];
    
//    UILabel *lblForBtnScanner = [[UILabel alloc] initWithFrame:CGRectMake(25, scannerShadow.frame.origin.y+scannerShadow.frame.size.height, 253/2, 150)];
//    lblForBtnScanner.numberOfLines = 4;
//    lblForBtnScanner.backgroundColor = [UIColor clearColor];
//    lblForBtnScanner.textColor = [UIColor whiteColor];
//    lblForBtnScanner.font = [UIFont systemFontOfSize:12];
//    lblForBtnScanner.text = NSLocalizedString(@"scanner_button_tips", @"");
//    [self.view addSubview:lblForBtnScanner];
    
    UILabel *lblForBtnAutoSearch = [[UILabel alloc] initWithFrame:CGRectMake(btnAutoSearch.frame.origin.x,finderShadow.frame.origin.y+finderShadow.frame.size.height, 253/2, 100)];
    lblForBtnAutoSearch.backgroundColor = [UIColor clearColor];
    lblForBtnAutoSearch.textColor = [UIColor whiteColor];
    lblForBtnAutoSearch.font = [UIFont systemFontOfSize:12];
    lblForBtnAutoSearch.numberOfLines = 5;
    lblForBtnAutoSearch.text = NSLocalizedString(@"auto_search_button_tips", @"");
    [self.view addSubview:lblForBtnAutoSearch];
    
    if (alertBinding == nil) {
        alertBinding = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"tips", @"") message:NSLocalizedString(@"found_new_unit", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"no", @"") otherButtonTitles:NSLocalizedString(@"binding", @""), nil];
        [alertBinding dismissWithClickedButtonIndex:0 animated:YES];
    }
}

- (void)generateTopbar {
    self.topbar = [TopbarView topBarWithImage:[UIImage imageNamed:@"bg_topbar.png"] shadow:NO];
    self.topbar.rightButton = [[UIButton alloc] initWithFrame:CGRectMake(self.topbar.frame.size.width - 101/2 - 8, [UIDevice systemVersionIsMoreThanOrEuqal7] ? 28 : 8, 101/2, 59/2)];
    [self.topbar addSubview:self.topbar.rightButton];
    [self.topbar.rightButton setBackgroundImage:[UIImage imageNamed:@"btn_done.png"] forState:UIControlStateNormal];
    [self.topbar.rightButton setBackgroundImage:[UIImage imageNamed:@"btn_done.png"] forState:UIControlStateHighlighted];
    if (self.topBarType==TopBarTypeDone) {
        [self.topbar.rightButton setTitle:NSLocalizedString(@"done", @"") forState:UIControlStateNormal];
        [self.topbar.rightButton addTarget:self action:@selector(btnDonePressed:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [self.topbar.rightButton setTitle:NSLocalizedString(@"skip", @"") forState:UIControlStateNormal];
        [self.topbar.rightButton addTarget:self action:@selector(btnSkipPressed:) forControlEvents:UIControlEventTouchUpInside];

    }
    
    self.topbar.rightButton.titleLabel.font = [UIFont systemFontOfSize:15.f];
    self.topbar.rightButton.titleLabel.textColor = [UIColor lightTextColor];
    
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

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [finder requestForBindingUnit];
        if (self.topBarType == TopBarTypeSkip) {
            [self.navigationController pushViewController:[[MainViewController alloc] init] animated:YES];
        } else if(self.topBarType == TopBarTypeDone){
            [self dismissModalViewControllerAnimated:YES];
        }

    }
}
- (void)btnSkipPressed:(id)sender {
    [self showMainView];
}

- (void)btnDonePressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)btnQRCodeScannerPressed:(id)sender {
    QRCodeScannerViewController *scannerViewController = [[QRCodeScannerViewController alloc] init];
    scannerViewController.delegate = self;
    [self presentViewController:scannerViewController animated:YES completion:^{}];
}

-(void) btnAutoSearchPressed:(UIButton *) sender{
    [finder startFindingDevice];
    [[AlertView currentAlertView] setMessage:NSLocalizedString(@"searching_unit", @"") forType:AlertViewTypeWaitting];
    [[AlertView currentAlertView] alertAutoDisappear:NO lockView:nil];
    
    [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(delayDismiss) userInfo:nil repeats:NO];
}

- (void)delayDismiss {
    if ([AlertView currentAlertView].alertViewState != AlertViewStateReady) {
        [[AlertView currentAlertView] setMessage:NSLocalizedString(@"no_unit_found", @"") forType:AlertViewTypeFailed];
        [[AlertView currentAlertView] delayDismissAlertView];
    }
}

- (void)askwhetherBinding {
    if ([AlertView currentAlertView].alertViewState != AlertViewStateReady) {
        [[AlertView currentAlertView] dismissAlertView];
    }
    [alertBinding show];
}

#pragma mark -
#pragma mark QR code delegate

- (void)qrCodeScannerSuccess:(NSString *)result scanner:(UIViewController *)scannerViewController {
    [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(test:) userInfo:scannerViewController repeats:NO];
}

- (void)test:(NSTimer *)timer {
    UIViewController *viewController = timer.userInfo;
    [self showMainView];
    [viewController dismissViewControllerAnimated:YES completion:nil];
}

@end
