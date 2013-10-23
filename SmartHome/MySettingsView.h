//
//  MySettingsView.h
//  SmartHome
//
//  Created by Zhao yang on 8/5/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationView.h"
#import "DeviceCommandCheckVersionHandler.h"
@interface MySettingsView : NavigationView<UITableViewDataSource, UITableViewDelegate,DeviceCommandCheckVersionHandlerDelegate>

@end
