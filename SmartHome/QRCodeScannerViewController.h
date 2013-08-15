//
//  QRCodeScannerViewController.h
//  SmartHome
//
//  Created by Zhao yang on 8/5/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ZBarReaderView.h"

@protocol QRCodeScannerDelegate <NSObject>

- (void)qrCodeSanningSuccess:(NSString *)result;

@end

@interface QRCodeScannerViewController : UIViewController<ZBarReaderViewDelegate>

@property (assign, nonatomic) id<QRCodeScannerDelegate> delegate;

@end
