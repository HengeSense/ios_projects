//
//  PageableNavView.h
//  SmartHome
//
//  Created by hadoop user account on 26/08/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol PageableNavViewDelegate<NSObject>
-(void) panAndTouchAccessoryBehavior;
@end
@interface PageableNavView : UIView<UIScrollViewDelegate>
@property(assign,nonatomic) id<PageableNavViewDelegate> delegate;
@property(strong,nonatomic) UIScrollView *pageableNavView;
@end
