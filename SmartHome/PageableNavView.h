//
//  PageableNavView.h
//  SmartHome
//
//  Created by hadoop user account on 26/08/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>
#define ITEM_MARGIN 7.5
@interface PageableNavView : UIView<UIScrollViewDelegate>
@property(strong,nonatomic) UIScrollView *pageableNavView;

-(id)initWithFrame:(CGRect)frame andNavItemsForHorizontal:(NSArray *) navItems;
-(id)initWithFrame:(CGRect)frame andNavItemsForVertical:(NSArray *) navItems;

@end
