//
//  NSString+StringUtils.m
//  SmartHome
//
//  Created by Zhao yang on 8/5/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "NSString+StringUtils.h"

@implementation NSString (StringUtils)

+ (BOOL)isEmpty:(NSString *)str {
    if(str == nil || [@"" isEqualToString:str]) return YES;
    return NO;
}

+ (BOOL)isBlank:(NSString *)str {
    if([NSString isEmpty:str]) return YES;
    if([@"" isEqualToString:
        [str stringByTrimmingCharactersInSet:
         [NSCharacterSet whitespaceAndNewlineCharacterSet]]]) {
            return YES;
        }
    return NO;
}

+ (NSString *)trim:(NSString *)str {
    if(str) {
        return [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    return nil;
}

+ (NSString *)stringEncodeWithBase64:(NSString *)str {
    NSData *theData = [str dataUsingEncoding: NSASCIIStringEncoding];
    
    const uint8_t* input = (const uint8_t*)[theData bytes];
    NSInteger length = [theData length];
    
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    
    NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t* output = (uint8_t*)data.mutableBytes;
    
    NSInteger i;
    for (i=0; i < length; i += 3) {
        NSInteger value = 0;
        NSInteger j;
        for (j = i; j < (i + 3); j++) {
            value <<= 8;
            
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        
        NSInteger theIndex = (i / 3) * 4;
        output[theIndex + 0] =                    table[(value >> 18) & 0x3F];
        output[theIndex + 1] =                    table[(value >> 12) & 0x3F];
        output[theIndex + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
        output[theIndex + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
    }
    
    return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
}

+ (NSString *)emptyString {
    return @"";
}


@end
