//
//  ZBarScanningViewController.h
//  SmartHome
//
//  Created by Zhao yang on 8/5/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBarReaderView.h"
#import "ZBarSymbol.h"
#import "ZBarReaderViewController.h"
#import "NavViewController.h"

@interface ZBarScanningViewController : NavViewController <ZBarReaderDelegate>

@end
