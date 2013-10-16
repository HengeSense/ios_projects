//
//  NetworkHandler.m
//  SmartHome
//
//  Created by hadoop user account on 16/10/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "NetworkHandler.h"

@implementation NetworkHandler
+ (BOOL)handleNetworkExceptionOfDevice:(Device *)device{
    if (device.state == 1) {
        [[AlertView currentAlertView] setMessage:NSLocalizedString(@"device_disconnected_cloud", @"") forType:AlertViewTypeFailed];
        [[AlertView currentAlertView] delayDismissAlertView];
        return NO;
    }
    
    if([SMShared current].deliveryService.currentNetworkMode == NetworkModeInternal) {
        return YES;
    } else {
        
        if([SMShared current].deliveryService.tcpService.isConnectted) {
            
            if ([device.zone.unit.status isEqualToString:ONLINE]) {
                return YES;
            } else {
                [[AlertView currentAlertView] setMessage:NSLocalizedString(@"unit_is_offline", @"") forType:AlertViewTypeFailed];
                [[AlertView currentAlertView] delayDismissAlertView];
                return NO;
            }
            
        } else {
            [[AlertView currentAlertView] setMessage:NSLocalizedString(@"can't_connect_cloud", @"") forType:AlertViewTypeFailed];
            [[AlertView currentAlertView] delayDismissAlertView];
            return NO;
        }
        
        
    }
    
    
}

@end
