//
//  NetworkHandler.m
//  SmartHome
//
//  Created by hadoop user account on 16/10/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "DeviceUtils.h"

@implementation DeviceUtils

+ (BOOL)checkDeviceIsAvailable:(Device *)device {
    if(device == nil) return NO;
    
    if (device.state == 1) {
        [[AlertView currentAlertView] setMessage:NSLocalizedString(@"device_state_offline", @"") forType:AlertViewTypeFailed];
        [[AlertView currentAlertView] alertAutoDisappear:YES lockView:nil];
        return NO;
    }
    
    if([SMShared current].deliveryService.currentNetworkMode == NetworkModeInternal) {
        return YES;
    } else {
        if([SMShared current].deliveryService.tcpService.isConnectted) {
            if ([@"在线" isEqualToString:device.zone.unit.status]) {
                return YES;
            } else {
                [[AlertView currentAlertView] setMessage:NSLocalizedString(@"unit_state_offline", @"") forType:AlertViewTypeFailed];
                [[AlertView currentAlertView] alertAutoDisappear:YES lockView:nil];
                return NO;
            }
        } else {
            [[AlertView currentAlertView] setMessage:NSLocalizedString(@"offline", @"") forType:AlertViewTypeFailed];
            [[AlertView currentAlertView] alertAutoDisappear:YES lockView:nil];
            return NO;
        }
    }
}

@end
