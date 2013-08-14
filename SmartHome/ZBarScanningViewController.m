//
//  ZBarScanningViewController.m
//  SmartHome
//
//  Created by Zhao yang on 8/5/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "ZBarScanningViewController.h"
#import "UIViewController+UIViewControllerExtension.h"
#import "ZBarCameraSimulator.h"

@interface ZBarScanningViewController ()

@end

@implementation ZBarScanningViewController{
    UIButton *btnDone;
    UILabel *lblTitle;
    UIButton *btnZbarScan;
    UITextField *txtZbarCode;
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
}

- (void)initDefaults {
    
}

- (void)initUI {
    [super initUI];

    //zbar scanner button
    if(btnZbarScan == nil) {
        btnZbarScan = [[UIButton alloc] initWithFrame:CGRectMake(120.0f, 150.0f, 150.0f, 40.0f)];
        [btnZbarScan setTitle:NSLocalizedString(@"zbar.scan", @"") forState:UIControlStateNormal];
        [btnZbarScan addTarget:self action:@selector(btnZbarScanPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnZbarScan];
    }
    
    if(lblTitle == nil) {
        //text view with zbar code for user custom
        lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(40.0f, 200.0f, 90.0f, 24.0f)];
        lblTitle.text = NSLocalizedString(@"zbar.enter", @"");
        lblTitle.textColor = [UIColor whiteColor];
        [self.view addSubview:lblTitle];
    }
    
    if(txtZbarCode == nil) {
        txtZbarCode = [[UITextField alloc] initWithFrame:CGRectMake(130.0f, 200.0f, 180.0f, 24.0f)];
        [txtZbarCode setBackgroundColor:[UIColor whiteColor]];
        [self.view addSubview:txtZbarCode];
    }
    
    //done button to main view
    if(btnDone == nil) {
        btnDone = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 120, 48)];
        [btnDone setTitle:NSLocalizedString(@"done", @"") forState:UIControlStateNormal];
        [btnDone addTarget:self action:@selector(btnDownPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnDone];
    }
}

#pragma mark -
#pragma mark delegate

//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
//    id<NSFastEnumeration> results = [info objectForKey:ZBarReaderControllerResults];
//    ZBarSymbol *symbol = nil;
//    for(symbol in results) break;
//    [picker dismissModalViewControllerAnimated: YES];
//    [self zbarCodeScanningSuccess:symbol.data];
//}

-(CGRect)getScanCrop:(CGRect)rect readerViewBounds:(CGRect)readerViewBounds
{
    CGFloat x,y,width,height;
    
    x = rect.origin.x / readerViewBounds.size.width;
    y = rect.origin.y / readerViewBounds.size.height;
    width = rect.size.width / readerViewBounds.size.width;
    height = rect.size.height / readerViewBounds.size.height;
    
    return CGRectMake(x, y, width, height);
}
- (void)zbarCodeScanningSuccess:(NSString *)zbarCode {
    NSLog(@">>>>>>> %@", zbarCode);
    txtZbarCode.text = zbarCode;
}

#pragma mark -
#pragma mark events

- (void)btnDownPressed:(id)sender {
    self.app.rootViewController.needLoadMainViewController = YES;
    [self.navigationController popToRootViewControllerAnimated:NO];
}

- (void)btnZbarScanPressed:(id)sender {

    ZBarReaderView *readerView = [[ZBarReaderView alloc] init];
    readerView.frame = CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height - 44);
    readerView.readerDelegate = self;
    //关闭闪光灯
    readerView.torchMode = 0;
    //扫描区域
    CGRect scanMaskRect = CGRectMake(60, CGRectGetMidY(readerView.frame) - 126, 200, 200);
    
    [self.view addSubview:readerView];
    //扫描区域计算
    readerView.scanCrop = [self getScanCrop:scanMaskRect readerViewBounds:readerView.bounds];

    [readerView start];
}
- (void)readerView:(ZBarReaderView *)readerView didReadSymbols:(ZBarSymbolSet *)symbols fromImage:(UIImage *)image
{
    for (ZBarSymbol *symbol in symbols) {
        NSLog(@"%@", symbol.data);
        break;
    }
    
    [readerView stop];
    [readerView removeFromSuperview];
}

@end
