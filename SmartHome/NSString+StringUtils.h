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
+ (BOOL)string:(NSString *)s1 isEqualString:(NSString *)s2;
+ (NSString *)trim:(NSString *)str;
+ (NSString *)stringEncodeWithBase64:(NSString *)str;
+ (NSString *)emptyString;
+ (NSString *)md5HexDigest:(NSString *)str;

@end
