//
//  PageableNavView.m
//  SmartHome
//
//  Created by hadoop user account on 26/08/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "PageableNavView.h"
#define ITEM_MARGIN 10
@implementation PageableNavView
@synthesize delegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.pageableNavView = [[UIScrollView alloc] initWithFrame:self.bounds];
        self.pageableNavView.delegate = self;
        [self addSubview:self.pageableNavView];
    }
    return self;
}
-(id)initWithFrame:(CGRect)frame andNavItemsForHorizontal:(NSArray *) navItems {
    if (frame.size.width<100) {
        frame.size.height = 100;
    }
    self = [super initWithFrame:frame];
    if(self){
        self.pageableNavView = [[UIScrollView alloc] initWithFrame:self.bounds];
        self.pageableNavView.delegate = self;
        [self pageHorizontal:navItems];
        [self addSubview:self.pageableNavView];
    }
    return self;
}
-(id)initWithFrame:(CGRect)frame andNavItemsForVertical:(NSArray *) navItems {
    if (frame.size.height<100) {
        frame.size.height = 100;
    }
    self = [super initWithFrame:frame];
    if(self){
        
        self.pageableNavView = [[UIScrollView alloc] initWithFrame:self.bounds];
        self.pageableNavView.delegate = self;
        [self pageVertical:navItems];
        [self addSubview:self.pageableNavView];
    }
    return self;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //    self.pageableScrollView.alpha = 0.5f;
    if ([self.delegate respondsToSelector:@selector(panAndTouchAccessoryBehavior)] ) {
        [self.delegate panAndTouchAccessoryBehavior];
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    self.pageableNavView.alpha = 1.0f;
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;{
    self.pageableNavView.alpha = 1.0f;
}
-(void) pageHorizontal:(NSArray *) navItems{
    
}
-(void) pageVertical:(NSArray *) navItems{
    self.pageableNavView.showsVerticalScrollIndicator = NO;
    __block CGRect pageableNavRect = self.pageableNavView.frame;
   
    [navItems enumerateObjectsUsingBlock:^(__strong UIButton *obj,NSUInteger index,BOOL *stop){
        obj.frame = CGRectMake(pageableNavRect.origin.x, pageableNavRect.origin.y, obj.frame.size.width, obj.frame.size.height);
        [self.pageableNavView addSubview:obj];
        pageableNavRect.origin.y += obj.frame.size.height+ITEM_MARGIN;
    }];
    //CGFloat widthOfGroup =
    
}
@end
