//
//  UnitsBindingViewController.h
//  SmartHome
//
//  Created by Zhao yang on 8/15/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "QRCodeScannerViewController.h"
#import "BaseViewController.h"
#import "TopbarView.h"

@interface UnitsBindingViewController : BaseViewController<QRCodeProcessorDelegate>

@property (strong, nonatomic) TopbarView *topbar;

@end
