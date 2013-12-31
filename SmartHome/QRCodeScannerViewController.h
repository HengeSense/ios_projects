//
//  QRCodeScannerViewController.h
//  SmartHome
//
//  Created by Zhao yang on 8/5/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBarReaderView.h"

@protocol QRCodeProcessorDelegate <NSObject>

//you must execute [scannerViewController dismissModalViewControllerAnimated:YES] after you
//process the result string
- (void)qrCodeScannerSuccess:(NSString *)result scanner:(UIViewController *)scannerViewController;

@end

@interface QRCodeScannerViewController : UIViewController<ZBarReaderViewDelegate>

@property(weak, nonatomic) id<QRCodeProcessorDelegate> delegate;

@end


