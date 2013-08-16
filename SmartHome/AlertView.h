//
//  AlertView.h
//  SmartHome
//
//  Created by Zhao yang on 8/16/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, AlertViewType) {
    AlertViewTypeLoading
};

@interface AlertView : UIView

+ (AlertView *)currentAlertView;

@end
