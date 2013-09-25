//
//  UnitsBindingViewController.h
//  SmartHome
//
//  Created by Zhao yang on 8/15/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "QRCodeScannerViewController.h"
#import "PopViewController.h"
#import "TopbarView.h"
#import "DeviceFinder.h"

@interface UnitsBindingViewController : PopViewController <QRCodeProcessorDelegate>

@property (strong, nonatomic) TopbarView *topbar;

@end
