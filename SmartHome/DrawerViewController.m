//
//  DrawerViewController.m
//  SmartHome
//
//  Created by Zhao yang on 8/2/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "DrawerViewController.h"

@interface DrawerViewController ()

@end

@implementation DrawerViewController {
    UIView *lockView;
    CGFloat lastedMainViewCenterX;
    CGFloat screenCenterY;
    BOOL leftViewIsAboveOnRightView;
    UITapGestureRecognizer *tapForMainViewStateHide;
    UIPanGestureRecognizer *panForMainViewStateHide;
    UIPanGestureRecognizer *panGesture;
    NSString *intentionDirection;
}

@synthesize leftView;
@synthesize rightView;
@synthesize mainView;
@synthesize rightViewCenterX;
@synthesize leftViewCenterX;
@synthesize leftViewVisibleWidth;
@synthesize rightViewVisibleWidth;
@synthesize scrollView;
@synthesize panFromScrollViewFirstPage;
@synthesize panFromScrollViewLastPage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)applyBindings {
    //20 is the status bar height
    screenCenterY = ([UIScreen mainScreen].bounds.size.height - 20) / 2;
    
    self.view.backgroundColor = [UIColor clearColor];
    
    if(self.rightView != nil) {
        [self.view addSubview:rightView];
    }
    
    if(self.leftView != nil) {
        [self.view addSubview:self.leftView];
    }
    
    if(self.mainView != nil) {
        [self.view addSubview:self.mainView];
        panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGestureForMainViewStateNormal:)];
        [self.mainView addGestureRecognizer:panGesture];
    }
    
    if(self.leftViewCenterX == 0) {
        self.leftViewCenterX = 110;
    }
    
    if(self.rightViewCenterX == 0) {
        self.rightViewCenterX = 190;
    }
    
    if(self.showDrawerMaxTrasitionX == 0) {
        self.showDrawerMaxTrasitionX = 80;
    }
    
    if(self.leftViewVisibleWidth == 0) {
        self.leftViewVisibleWidth = 220;
    }
    
    if(self.rightViewVisibleWidth == 0) {
        self.rightViewVisibleWidth = 260;
    }
    
    if(tapForMainViewStateHide == nil) {
        tapForMainViewStateHide = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGestureForMainViewStateHide:)];
    }
    
    if(panForMainViewStateHide == nil) {
        panForMainViewStateHide = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGestureForMainViewStateHide:)];
    }
    
    if(lockView == nil) {
        lockView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, screenCenterY * 2)];
        lockView.backgroundColor = [UIColor clearColor];
        [lockView addGestureRecognizer:tapForMainViewStateHide];
        [lockView addGestureRecognizer:panForMainViewStateHide];
    }
    
    lastedMainViewCenterX = 160;
    leftViewIsAboveOnRightView = YES;
}

- (void)handlePanGestureForMainViewStateNormal:(UIPanGestureRecognizer *)gesture {
    CGPoint translation = [gesture translationInView:self.mainView];
    
    if(gesture.state == UIGestureRecognizerStateBegan) {
        lastedMainViewCenterX = self.mainView.center.x;
        intentionDirection = @"";
    }
    
    //dragging main view
    if(gesture.state == UIGestureRecognizerStateChanged || gesture.state == UIGestureRecognizerStateBegan) {
        if(self.panFromScrollViewFirstPage) {
            if(translation.x > 0 && self.scrollView != nil) {
                if([@"" isEqualToString:intentionDirection]) {
                    intentionDirection = @"right";
                }
                if([@"left" isEqualToString:intentionDirection]) {
                    self.scrollView.scrollEnabled = YES;
                    self.mainView.center = CGPointMake(160, self.mainView.center.y);
                    return;
                } else {
                    self.scrollView.scrollEnabled = NO;
                }
            } else if (self.scrollView.scrollEnabled){
                if([@"" isEqualToString:intentionDirection]) {
                    intentionDirection = @"left";
                }
                if([@"left" isEqualToString:intentionDirection]) {
                    self.scrollView.scrollEnabled = YES;
                    self.mainView.center =CGPointMake(160, self.mainView.center.y);
                    return;
                } else {
                    self.scrollView.scrollEnabled = NO;
                }
            }
        } else if(self.panFromScrollViewLastPage) {
            if(translation.x < 0 && self.scrollView != nil) {
                if([@"" isEqualToString:intentionDirection]) {
                    intentionDirection = @"left";
                }
                if([@"right" isEqualToString:intentionDirection]) {
                    self.scrollView.scrollEnabled = YES;
                    self.mainView.center =CGPointMake(160, self.mainView.center.y);
                    return;
                } else {
                    self.scrollView.scrollEnabled = NO;
                }
            } else if (self.scrollView.scrollEnabled){
                if([@"" isEqualToString:intentionDirection]) {
                    intentionDirection = @"right";
                }
                if([@"right" isEqualToString:intentionDirection]) {
                    self.scrollView.scrollEnabled = YES;
                    self.mainView.center =CGPointMake(160, self.mainView.center.y);
                    return;
                } else {
                    self.scrollView.scrollEnabled = NO;
                }
            }
        }
        if(translation.x > 0) {
            if(leftView == nil) {
                self.mainView.center = CGPointMake(160, screenCenterY);
                return;
            }
            if(!leftViewIsAboveOnRightView && rightView != nil) [self leftViewToTopLevel];
        } else if(translation.x < 0) {
            if(rightView == nil) {
                self.mainView.center = CGPointMake(160, screenCenterY);
                return;
            }
            if(leftViewIsAboveOnRightView && leftView != nil) [self rightViewToTopLevel];
        }
        CGPoint center = self.mainView.center;
        self.mainView.center = CGPointMake(lastedMainViewCenterX + translation.x, center.y);
    } else if(gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateCancelled) {
        CGFloat mainViewX = self.mainView.frame.origin.x;
        //left view
        if(translation.x > 0) {
            //show
            if(mainViewX >= self.showDrawerMaxTrasitionX) {
                [self showLeftView];
            }
            //hide
            else {
                [self showMainView];
            }
        }
        //right view
        else if(translation.x < 0) {
            if(mainViewX < (0 - self.showDrawerMaxTrasitionX)) {
                [self showRightView];
            } else {
                [self showMainView];
            }
        }
        lastedMainViewCenterX = self.mainView.center.x;
    }
}

- (void)handleTapGestureForMainViewStateHide:(UITapGestureRecognizer *)gesture {
    [self showMainView];
}

- (void)handlePanGestureForMainViewStateHide:(UIPanGestureRecognizer *)gesture {
    CGPoint translation = [gesture translationInView:lockView];
    if(gesture.state == UIGestureRecognizerStateBegan) {
        lastedMainViewCenterX = self.mainView.center.x;
    }
    if(gesture.state == UIGestureRecognizerStateChanged || gesture.state == UIGestureRecognizerStateBegan) {
        CGFloat mainViewX = self.mainView.frame.origin.x;
        CGPoint center = self.mainView.center;
        if(mainViewX >= 0 && (lastedMainViewCenterX + translation.x) <= 160) {
            self.mainView.center = CGPointMake(160, center.y);
            return;
        } else if(mainViewX <= 0 && (lastedMainViewCenterX + translation.x) >= 160) {
            self.mainView.center = CGPointMake(160, center.y);
            return;
        }
        self.mainView.center = CGPointMake(lastedMainViewCenterX + translation.x, center.y);
    } else if(gesture.state == UIGestureRecognizerStateEnded) {
        CGFloat mainViewX = self.mainView.frame.origin.x;
        if(mainViewX > 0) {
            if(mainViewX <= self.leftViewCenterX) {
                [self showMainView];
            } else {
                [self showLeftView];
            }
        } else if(mainViewX < 0){
            if((mainViewX + 320) >= self.rightViewCenterX) {
                [self showMainView];
            } else {
                [self showRightView];
            }
        } else {
            [self showMainView];
        }
    }
}

- (void)showLeftView {
    if(self.leftView == nil) return;
    if(self.mainView != nil) {
        self.mainView.backgroundColor = [UIColor clearColor];
    }
    if(!leftViewIsAboveOnRightView && leftView && rightView) [self leftViewToTopLevel];
    [UIView animateWithDuration:0.3 animations:^{
        self.mainView.center = CGPointMake(160 + self.leftViewVisibleWidth, screenCenterY);
    } completion:^(BOOL finished) {
        [self.mainView addSubview:lockView];
        self.panFromScrollViewFirstPage = NO;
        self.panFromScrollViewLastPage = NO;
        self.mainView.backgroundColor = [UIColor whiteColor];
    }];
}

- (void)showMainView {
    if(self.mainView == nil) return;
    if(!(self.panFromScrollViewFirstPage && [intentionDirection isEqualToString:@"left"])
       && !(self.panFromScrollViewLastPage && [intentionDirection isEqualToString:@"right"])) {
        self.mainView.backgroundColor = [UIColor clearColor];
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.mainView.center = CGPointMake(160, screenCenterY);
    } completion:^(BOOL finished) {
        if(self.scrollView != nil) self.scrollView.scrollEnabled = YES;
        self.panFromScrollViewFirstPage = NO;
        self.panFromScrollViewLastPage = NO;
        if(lockView.superview != nil) {
            [lockView removeFromSuperview];
        }
        self.mainView.backgroundColor = [UIColor whiteColor];
    }];
}

- (void)showRightView {
    if(self.rightView == nil) return;
    if(self.mainView != nil) {
        self.mainView.backgroundColor = [UIColor clearColor];
    }
    if(leftViewIsAboveOnRightView && leftView && rightView) [self rightViewToTopLevel];
    [UIView animateWithDuration:0.3 animations:^{
        self.mainView.center = CGPointMake(160 - self.rightViewVisibleWidth, screenCenterY);
    } completion:^(BOOL finished) {
        [self.mainView addSubview:lockView];
        self.panFromScrollViewFirstPage = NO;
        self.panFromScrollViewLastPage = NO;
        self.mainView.backgroundColor = [UIColor whiteColor];
    }];
}

- (void)leftViewToTopLevel {
    if(!leftViewIsAboveOnRightView) {
        [self.view exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
        leftViewIsAboveOnRightView = YES;
    }
}

- (void)rightViewToTopLevel {
    if(leftViewIsAboveOnRightView) {
        [self.view exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
        leftViewIsAboveOnRightView = NO;
    }
}

@end
