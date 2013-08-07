//
//  DrawerViewController.h
//  SmartHome
//
//  Created by Zhao yang on 8/2/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DrawerViewController : UIViewController<UIScrollViewDelegate>

@property (nonatomic) CGFloat leftViewCenterX;
@property (nonatomic) CGFloat rightViewCenterX;
@property (nonatomic) CGFloat showDrawerMaxTrasitionX;
@property (nonatomic) CGFloat leftViewVisibleWidth;
@property (nonatomic) CGFloat rightViewVisibleWidth;
@property (nonatomic) BOOL panFromScrollViewFirstPage;
@property (nonatomic) BOOL panFromScrollViewLastPage;
@property (strong, nonatomic) UIView *mainView;
@property (strong, nonatomic) UIView *leftView;
@property (strong, nonatomic) UIView *rightView;
@property (strong, nonatomic) UIScrollView *scrollView;

- (void)showRightView;
- (void)showMainView;
- (void)showLeftView;

- (void)applyBindings;

@end
