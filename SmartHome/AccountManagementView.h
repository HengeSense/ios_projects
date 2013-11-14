//
//  AccountManagementView.h
//  SmartHome
//
//  Created by Zhao yang on 11/14/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "NavigationView.h"
#import "DeviceCommandGetUnitsHandler.h"
#import "SMCell.h"

@interface AccountManagementView : NavigationView<UITableViewDataSource,UITableViewDelegate,DeviceCommandGetUnitsHandlerDelegate>

@end
