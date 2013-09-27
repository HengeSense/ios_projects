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
typedef  NS_ENUM(NSUInteger, TopBarType){
    TopBarTypeSkip,
    TopBarTypeDone
};
@interface UnitsBindingViewController : PopViewController <QRCodeProcessorDelegate,DeviceFinderDelegate,UIAlertViewDelegate>

@property (strong, nonatomic) TopbarView *topbar;
@property (assign,nonatomic) TopBarType topBarType;
-(id) initWithType:(NSUInteger) type;
@end
