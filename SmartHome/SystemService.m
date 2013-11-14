//
//  SystemService.m
//  SmartHome
//
//  Created by Zhao yang on 11/14/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "SystemService.h"

@implementation SystemService
    
+ (void)dialToMobile:(NSString *)mobile {
    if([NSString isBlank:mobile]) return;
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@", mobile]]];
}
    
+ (void)messageToMobile:(NSString *)mobile withMessage:(NSString *)message {
    if([NSString isBlank:mobile]) return;
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"sms://%@", mobile]]];
}
    
@end
