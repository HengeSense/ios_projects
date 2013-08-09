//
//  ZBarScanningViewController.m
//  SmartHome
//
//  Created by Zhao yang on 8/5/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "ZBarScanningViewController.h"
#import "UIViewController+UIViewControllerExtension.h"


@interface ZBarScanningViewController ()

@end

@implementation ZBarScanningViewController{
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
    [self initDefaults];
    [self initUI];
}

- (void)initDefaults {
    
}

- (void)initUI {
    self.view.backgroundColor = [UIColor darkGrayColor];
    
    //zbar scanner button
    UIButton *btnZbarScan = [[UIButton alloc] initWithFrame:CGRectMake(120.0f, 150.0f, 150.0f, 40.0f)];
    [btnZbarScan setTitle:NSLocalizedString(@"zbar.scan", @"") forState:UIControlStateNormal];
    [btnZbarScan addTarget:self action:@selector(btnZbarScanPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnZbarScan];
    
    //text view with zbar code for user custom
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(40.0f, 200.0f, 90.0f, 24.0f)];
    lblTitle.text = NSLocalizedString(@"zbar.enter", @"");
    lblTitle.textColor = [UIColor whiteColor];
    [self.view addSubview:lblTitle];
    txtZbarCode = [[UITextField alloc] initWithFrame:CGRectMake(130.0f, 200.0f, 180.0f, 24.0f)];
    [txtZbarCode setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:txtZbarCode];
    
    //done button to main view
    UIButton *btnDone = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 120, 48)];
    [btnDone setTitle:NSLocalizedString(@"done", @"") forState:UIControlStateNormal];
    [btnDone addTarget:self action:@selector(btnDownPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnDone];
}

#pragma mark -
#pragma mark delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    id<NSFastEnumeration> results = [info objectForKey:ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for(symbol in results) break;
    NSLog(@">>>>>>> %@", symbol.data);
    txtZbarCode.text = symbol.data;
    [picker dismissModalViewControllerAnimated: YES];
}

#pragma mark -
#pragma mark events

- (void)btnDownPressed:(id)sender {
    self.app.rootViewController.needLoadMainViewController = YES;
    [self.navigationController popToRootViewControllerAnimated:NO];
}

- (void)btnZbarScanPressed:(id)sender {
    ZBarReaderViewController *reader = [ZBarReaderViewController new];
    reader.readerDelegate = self;
    ZBarImageScanner *scanner = reader.scanner;
    [scanner setSymbology:ZBAR_I25 config:ZBAR_CFG_ENABLE to: 0];
    [self presentModalViewController:reader animated: YES];
}

@end
