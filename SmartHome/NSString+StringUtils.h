//
//  NSString+StringUtils.h
//  SmartHome
//
//  Created by Zhao yang on 8/5/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (StringUtils)

+ (BOOL)isEmpty:(NSString *)str;
+ (BOOL)isBlank:(NSString *)str;
+ (NSString *)trim:(NSString *)str;
+ (NSString *)stringEncodeWithBase64:(NSString *)str;
+ (NSString *)emptyString;

@end
