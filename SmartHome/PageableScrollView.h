//
//  PageableScrollView.h
//  SmartHome
//
//  Created by hadoop user account on 26/08/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol PageableSCrollViewDelegate <NSObject>
-(void) accessoryBehavior;
@end
@interface PageableScrollView : UIView<UIScrollViewDelegate>
@property (strong,nonatomic) UIScrollView *pageableScrollView;
@property (assign,nonatomic) id<PageableSCrollViewDelegate> delegate;
@end
