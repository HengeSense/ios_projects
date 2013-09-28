//
//  QRCodeScannerViewController.m
//  SmartHome
//
//  Created by Zhao yang on 8/5/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "QRCodeScannerViewController.h"
#import "NSString+StringUtils.h"
#import "UIDevice+Extension.h"

#define SCANNER_VIEW_LENGTH 235
#define INDICATOR_VIEW_TAG 10012

typedef NS_ENUM(NSUInteger, MoveDirection) {
    MoveDirectionDown,
    MoveDirectionUp
};

@interface QRCodeScannerViewController ()

@end

@implementation QRCodeScannerViewController {
    ZBarReaderView *readerView;
    UIImageView *scannerFrame;
    UIImageView *scannerLine;
    MoveDirection moveDirection;
    
    UIView *lockView;
}

@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initDefaults];
    [self initUI];
}

- (void)initDefaults {
    
}

- (void)initUI {
    if(readerView == nil) {
        readerView = [[ZBarReaderView alloc] init];
        readerView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 44);
        readerView.readerDelegate = self;
        
        //close flash light
        readerView.torchMode = 0;
        readerView.tracksSymbols = NO;
        
        UIButton *btnFlashLight = [[UIButton alloc] initWithFrame:CGRectMake(20, 25, 30, 30)];
        [btnFlashLight setBackgroundImage:[UIImage imageNamed:@"btn_flash_light.png"] forState:UIControlStateNormal];
        [btnFlashLight addTarget:self action:@selector(btnFlashLightPressed:) forControlEvents:UIControlEventTouchUpInside];
        [readerView addSubview:btnFlashLight];
        
        UIButton *btnInfo = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-50, 24, 30, 30)];
        [btnInfo setBackgroundImage:[UIImage imageNamed:@"btn_info.png"] forState:UIControlStateNormal];
//        [btnInfo addTarget:self action:@selector(btnFlashLightPressed:) forControlEvents:UIControlEventTouchUpInside];
        [readerView addSubview:btnInfo];
        
        //sanner region
        CGRect rectForScannerView = CGRectMake((readerView.center.x - SCANNER_VIEW_LENGTH / 2), (readerView.center.y - SCANNER_VIEW_LENGTH / 2), SCANNER_VIEW_LENGTH, SCANNER_VIEW_LENGTH);
        
        //set scanner frame
        scannerFrame = [[UIImageView alloc] initWithFrame:rectForScannerView];
        scannerFrame.image = [UIImage imageNamed:@"bg_scanner_view.png"];
        [readerView addSubview:scannerFrame];
        
        scannerLine = [[UIImageView alloc] initWithFrame:CGRectMake(rectForScannerView.origin.x, rectForScannerView.origin.y, SCANNER_VIEW_LENGTH, 10)];
        scannerLine.image = [UIImage imageNamed:@"line_scanner.png"];
        [readerView addSubview:scannerLine];

        UILabel *lblTips = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 235, 21)];
        lblTips.text = NSLocalizedString(@"qr_code.tips", @"");
        lblTips.textAlignment = NSTextAlignmentCenter;
        lblTips.backgroundColor = [UIColor clearColor];
        lblTips.textColor = [UIColor lightGrayColor];
        lblTips.font = [UIFont systemFontOfSize:14.f];
        lblTips.center = CGPointMake([UIScreen mainScreen].bounds.size.width / 2, scannerFrame.center.y + 140);
        [readerView addSubview:lblTips];
        
        //set scanner region
        readerView.scanCrop = [self regionRectForScanner:rectForScannerView readerViewBounds:readerView.bounds];
        [self.view addSubview:readerView];
        CGFloat y = [UIDevice systemVersionIsMoreThanOrEuqal7] ? 0 : 20;
        UIImageView *bottomBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 44 - y, [UIScreen mainScreen].bounds.size.width, 44)];
        bottomBar.image = [UIImage imageNamed:@"bg_bottom_bar_black.png"];
        
        CGFloat y2 = [UIDevice systemVersionIsMoreThanOrEuqal7] ? 20 : 0;
        UIButton *btnBack = [[UIButton alloc] initWithFrame:CGRectMake(10, [UIScreen mainScreen].bounds.size.height - 44 - 12 + y2, 48, 27)];
        [btnBack setBackgroundImage:[UIImage imageNamed:@"btn_done_black.png"] forState:UIControlStateNormal];
        [btnBack setTitle:NSLocalizedString(@"done", @"") forState:UIControlStateNormal];
        btnBack.titleLabel.font = [UIFont systemFontOfSize:14.f];
        btnBack.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 1, 0);
        [btnBack addTarget:self action:@selector(btnBackPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:bottomBar];
        [self.view addSubview:btnBack];
    }
    [readerView start];
    [self startScannerAnimating];
}
#pragma mark -
#pragma mark events

- (void)btnBackPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)btnFlashLightPressed:(id)sender {
    if(readerView == nil) return;
    if(readerView.torchMode == 0) {
        readerView.torchMode = 1;
    } else if(readerView.torchMode == 1) {
        readerView.torchMode = 0;
    }
}

#pragma mark -
#pragma mark scanner view

- (void)movingScannerLine:(NSTimer *)timer {
    CGFloat yMin = scannerFrame.frame.origin.y;
    CGFloat yMax = scannerFrame.frame.origin.y + SCANNER_VIEW_LENGTH - 7;
    CGFloat y = scannerLine.frame.origin.y;
    
    if(y >= yMax) {
        moveDirection = MoveDirectionUp;
    } else if(y <= yMin) {
        moveDirection = MoveDirectionDown;
    }
    
    if(moveDirection == MoveDirectionDown) {
        scannerLine.center = CGPointMake(scannerLine.center.x, scannerLine.center.y+1);
    } else {
        scannerLine.center = CGPointMake(scannerLine.center.x, scannerLine.center.y-1);
    }
}

- (void)lockView {
    if(lockView == nil) {
        lockView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        lockView.backgroundColor = [UIColor blackColor];
        lockView.alpha = 0.8f;
        
        UIView  *processingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 220, 44)];
        processingView.center = CGPointMake(scannerFrame.center.x, scannerFrame.center.y + 20);
        processingView.backgroundColor = [UIColor clearColor];
        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(15, 0, 44, 44)];
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        indicator.backgroundColor = [UIColor clearColor];
        indicator.tag = INDICATOR_VIEW_TAG;
        [processingView addSubview:indicator];
        
        UILabel *lblMessage = [[UILabel alloc] initWithFrame:CGRectMake(70, 7, 140, 30)];
        lblMessage.textColor = [UIColor whiteColor];
        lblMessage.font = [UIFont boldSystemFontOfSize:18.f];
        lblMessage.backgroundColor = [UIColor clearColor];
        lblMessage.text = NSLocalizedString(@"processing", @"");
        [processingView addSubview:lblMessage];
        
        [lockView addSubview:processingView];
    }
    scannerLine.hidden = YES;
    UIActivityIndicatorView *indicator = (UIActivityIndicatorView *)[lockView viewWithTag:INDICATOR_VIEW_TAG];
    if(indicator != nil) {
        [indicator startAnimating];
    }
    [[UIApplication sharedApplication].keyWindow addSubview:lockView];
}

- (void)unlockViewAndRestart:(BOOL)restart {
    if(lockView != nil) {
        UIActivityIndicatorView *indicator = (UIActivityIndicatorView *)[lockView viewWithTag:INDICATOR_VIEW_TAG];
        if(indicator != nil) {
            [indicator stopAnimating];
        }
        [lockView removeFromSuperview];
        if(restart) {
            scannerLine.hidden = NO;
            [readerView start];
        }
    }
}

- (void)startScannerAnimating {
    [NSTimer scheduledTimerWithTimeInterval:0.01f target:self selector:@selector(movingScannerLine:) userInfo:nil repeats:YES];
}

#pragma mark -
#pragma mark QR Code calc

-(CGRect)regionRectForScanner:(CGRect)scannerView readerViewBounds:(CGRect)readerView_ {
    CGFloat x, y, width, height;
    x = scannerView.origin.x / readerView_.size.width;
    y = scannerView.origin.y / readerView_.size.height;
    width = scannerView.size.width / readerView_.size.width;
    height = scannerView.size.height / readerView_.size.height;
    return CGRectMake(x, y, width, height);
}

#pragma mark -
#pragma mark zbar delegate

- (void)readerView:(ZBarReaderView *)readerView_ didReadSymbols:(ZBarSymbolSet *)symbols fromImage:(UIImage *)image {
    NSString *result = [NSString emptyString];
    for (ZBarSymbol *symbol in symbols) {
        result = symbol.data;
        break;
    }
    [readerView_ stop];
    [self lockView];
    if(self.delegate != nil && [self.delegate respondsToSelector:@selector(qrCodeScannerSuccess:scanner:)]) {
        [self.delegate qrCodeScannerSuccess:result scanner:self];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark -
#pragma mark override

- (void)dismissModalViewControllerAnimated:(BOOL)animated {
    [self unlockViewAndRestart:NO];
    [super dismissModalViewControllerAnimated:YES];
}

- (void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion {
    [self unlockViewAndRestart:NO];
    [super dismissViewControllerAnimated:flag completion:completion];
}

@end
