//
//  PageableScrollView.h
//  SmartHome
//
//  Created by hadoop user account on 26/08/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageableNavView.h"
#import "PopViewController.h"

@interface PageableScrollView : UIView<UIScrollViewDelegate, StatusChangeDelegate>

@property (strong,nonatomic) UIScrollView *pageableScrollView;
@property (strong,nonatomic) PageableNavView *pageNavView;

-(id)initWithPoint:(CGPoint) point andUnit:(Unit *) unit owner:(UIViewController *) owner;
-(void) loadDataWithDictionary:(Unit *) unit owner:(UIViewController *) owner;

@end
