//
//  IPAddressTool.h
//  SmartHome
//
//  Created by hadoop user account on 23/09/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>
#define MAXADDRS    32

extern char *if_names[MAXADDRS];
extern char *ip_names[MAXADDRS];
extern char *hw_addrs[MAXADDRS];
extern unsigned long ip_addrs[MAXADDRS];

// Function prototypes


@interface IPAddressTool : NSObject
- (NSString *)deviceIPAdress;
@end
