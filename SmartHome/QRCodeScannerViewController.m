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
        
        UIImageView *bottomBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 44 - 20, [UIScreen mainScreen].bounds.size.width, 44)];
        bottomBar.image = [UIImage imageNamed:@"bg_bottom_bar.png"];
        
        UIButton *btnBack = [[UIButton alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 44 - 20, 64, 44)];
        [btnBack setBackgroundImage:[UIImage imageNamed:@"btn_scanner_view_back.png"] forState:UIControlStateNormal];
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
    [self dismissModalViewControllerAnimated:YES];
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
    if(self.delegate != nil && [self.delegate respondsToSelector:@selector(qrCodeSanningSuccess:)]) {
        [self.delegate qrCodeSanningSuccess:result];
    }
    [self dismissModalViewControllerAnimated:YES];
}

@end
