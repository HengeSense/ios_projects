//
//  XXStringUtils.H
//  XXToolKit
//
//  Created by Zhao yang on 12/11/13.
//  Copyright (c) 2013 xuxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XXStringUtils : NSObject

+ (BOOL)isEmpty:(NSString *)str;
+ (BOOL)isBlank:(NSString *)str;

+ (NSString *)emptyString;
+ (NSString *)trim:(NSString *)str;
+ (NSString *)stringEncodeWithBase64:(NSString *)str;

@end
