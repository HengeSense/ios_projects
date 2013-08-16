//
//  GlobalSettings.h
//  SmartHome
//
//  Created by Zhao yang on 8/8/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>

#define GLOBAL_SETTINGS_KEY @"globalSettings"

@interface GlobalSettings : NSObject

@property (strong, nonatomic) NSString *accountPhone;
@property (assign, nonatomic) BOOL isValid;
@property (assign, nonatomic) BOOL hasUnitBinding;

- (NSDictionary *)toDictionary;
- (void)saveSettings;

@end
