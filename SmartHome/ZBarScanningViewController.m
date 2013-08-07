//
//  ZBarScanningViewController.m
//  SmartHome
//
//  Created by Zhao yang on 8/5/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "ZBarScanningViewController.h"


@interface ZBarScanningViewController ()

@end

@implementation ZBarScanningViewController{
    UITextField *zbarCode;
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
    self.view.backgroundColor = [UIColor blueColor];
    UIButton *scannerButton = [[UIButton alloc] initWithFrame:CGRectMake(120.0f, 150.0f, 150.0f, 40.0f)];
    [scannerButton setTitle:NSLocalizedString(@"扫一扫", @"") forState:UIControlStateNormal];
    [scannerButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [scannerButton addTarget:self action:@selector(buttonChange:) forControlEvents:UIControlEventTouchDown];
//    scannerButton.center = self.view.center;
    scannerButton.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:scannerButton];
    UILabel *text = [[UILabel alloc] initWithFrame:CGRectMake(40.0f, 200.0f, 90.0f, 24.0f)];
    [text setText:NSLocalizedString(@"输入二维码", @"")];
    text.backgroundColor = [UIColor blueColor];
    text.textColor = [UIColor whiteColor];
    [self.view addSubview:text];
    zbarCode = [[UITextField alloc] initWithFrame:CGRectMake(130.0f, 200.0f, 180.0f, 24.0f)];
    [zbarCode setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:zbarCode];
    
        
}

- (void) imagePickerController: (UIImagePickerController*) reader
 didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    id<NSFastEnumeration> results =
    [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for(symbol in results)
        break;
    NSLog(@"===%@",symbol.data);
    zbarCode.text = symbol.data;
    
    
    
   [reader dismissModalViewControllerAnimated: YES];
    
}

- (void)buttonChange:(id)sender {
    ZBarReaderViewController *reader = [ZBarReaderViewController new];
    reader.readerDelegate = self;
    ZBarImageScanner *scanner = reader.scanner;
     
    [scanner setSymbology: ZBAR_I25
                   config: ZBAR_CFG_ENABLE
                       to: 0];
    [self presentModalViewController: reader
                            animated: YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
