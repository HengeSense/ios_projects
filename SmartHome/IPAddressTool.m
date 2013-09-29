//
//  IPAddressTool.m
//  SmartHome
//
//  Created by hadoop user account on 23/09/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "IPAddressTool.h"
#import "IPAddress.h"

@implementation IPAddressTool

- (NSString *)deviceIPAdress {
    InitAddresses();
    GetIPAddresses();
    GetHWAddresses();
    
    int i,index=0;
    for (i=0; i<MAXADDRS; ++i)
    {
        static unsigned long localHost = 0x7F000001;        // 127.0.0.1
        unsigned long theAddr;
        
        theAddr = ip_addrs[i];
        
        if (theAddr == 0){
            if (i>0) {
                index = i-1;
            }
            break;
        }
        if (theAddr == localHost) continue;
    }
    return [NSString stringWithFormat:@"%s", ip_names[index]];
}
@end
