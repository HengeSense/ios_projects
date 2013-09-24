//
//  GlobalSettings.h
//  SmartHome
//
//  Created by Zhao yang on 8/8/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GlobalSettings : NSObject

@property (strong, nonatomic) NSString *account;
@property (strong, nonatomic) NSString *secretKey;
@property (strong, nonatomic) NSString *deviceCode;
@property (strong, nonatomic) NSString *tcpAddress;
@property (strong, nonatomic) NSString *screenName;
@property (assign, nonatomic) BOOL anyUnitsBinding;

- (NSDictionary *)toDictionary;
- (void)saveSettings;
- (void)clearAuth;

@end
