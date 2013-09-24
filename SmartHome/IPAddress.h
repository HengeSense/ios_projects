//
//  IPAddress.h
//  SmartHome
//
//  Created by hadoop user account on 24/09/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#ifndef SmartHome_IPAddress_h
#define SmartHome_IPAddress_h
#define MAXADDRS    32
extern char *if_names[MAXADDRS];
extern char *ip_names[MAXADDRS];
extern char *hw_addrs[MAXADDRS];
extern unsigned long ip_addrs[MAXADDRS];
// Function prototypes
void InitAddresses();
void FreeAddresses();
void GetIPAddresses();
void GetHWAddresses();
#endif
