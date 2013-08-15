//
//  QRCodeScannerViewController.m
//  SmartHome
//
//  Created by Zhao yang on 8/5/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "QRCodeScannerViewController.h"
#import "NSString+StringUtils.h"

#define SCANNER_VIEW_LENGTH 235

@interface QRCodeScannerViewController ()

@end

@implementation QRCodeScannerViewController {
    ZBarReaderView *readerView;
    UIImageView *scannerFrame;
    UIImageView *scannerLine;
    BOOL scannerLineMoving;
}

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
        
        //sanner region
        CGRect rectForScannerView = CGRectMake((readerView.center.x - SCANNER_VIEW_LENGTH / 2), (readerView.center.y - SCANNER_VIEW_LENGTH / 2), SCANNER_VIEW_LENGTH, SCANNER_VIEW_LENGTH);
        
        //set scanner frame
        scannerFrame = [[UIImageView alloc] initWithFrame:rectForScannerView];
        scannerFrame.image = [UIImage imageNamed:@"bg_scanner_view.png"];
        [readerView addSubview:scannerFrame];
        
        scannerLine = [[UIImageView alloc] initWithFrame:CGRectMake(rectForScannerView.origin.x, rectForScannerView.origin.y, SCANNER_VIEW_LENGTH, 10)];
        scannerLine.image = [UIImage imageNamed:@"line_scanner.png"];
        [readerView addSubview:scannerLine];
        
        UILabel *lblTips = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        lblTips.text = @"";
        
        [readerView addSubview:lblTips];
        
        //set scanner region
        readerView.scanCrop = [self regionRectForScanner:rectForScannerView readerViewBounds:readerView.bounds];
        [self.view addSubview:readerView];
        
        UIImageView *bottomBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 44 - 20, [UIScreen mainScreen].bounds.size.width, 44)];
        bottomBar.image = [UIImage imageNamed:@"bg_bottom_bar.png"];
        
        UIButton *btnBack = [[UIButton alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 44 - 20, 64, 44)];
        [btnBack setBackgroundImage:[UIImage imageNamed:@"btn_scanner_view_back.png"] forState:UIControlStateNormal];
        [btnBack addTarget:self action:@selector(btnBackPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:bottomBar];
        [self.view addSubview:btnBack];
    }
    [readerView start];
}

#pragma mark -
#pragma mark events

- (void)btnBackPressed:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark scanner view

- (void)f {
    NSTimer *timer = [NSTimer timerWithTimeInterval:0.1f target:self selector:@selector(f:) userInfo:nil repeats:YES];

}

- (void)sannerLineUpDownMoving {
//    if(scannerLineMoving) {
        CGRect rect = scannerLine.frame;
        CGFloat y = rect.origin.y - 100;
        scannerLine.frame = CGRectMake(rect.origin.x, y, rect.size.width, rect.size.height);
//    }
}

- (void)beginScannerAnimation {

}

- (void)endScannerAnimation {
//    [timer invalidate];
}


#pragma mark -
#pragma mark QR Code calc

-(CGRect)regionRectForScanner:(CGRect)scannerView readerViewBounds:(CGRect)readerView_ {
//    CGFloat x, y, width, height;
//    x = scannerView.origin.y / readerView_.size.height;
//    y = 1 - (scannerView.origin.x + scannerView.size.width) / readerView_.size.width;
//    width = (scannerView.origin.y + scannerView.size.height) / readerView_.size.height;
//    height = 1 - scannerView.origin.x / readerView_.size.width;
//    return CGRectMake(x, y, width, height);
//    
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
    NSLog(result);
}

@end
