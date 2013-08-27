//
//  PageableNavView.m
//  SmartHome
//
//  Created by hadoop user account on 26/08/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "PageableNavView.h"
#define ITEM_MARGIN 20
@implementation PageableNavView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.pageableNavView = [[UIScrollView alloc] initWithFrame:self.bounds];
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
        [self pageVertical:navItems];
        [self addSubview:self.pageableNavView];
    }
    return self;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //    self.pageableScrollView.alpha = 0.5f;
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
    self.pageableNavView.pagingEnabled = YES;
//    self.pageableNavView.showsVerticalScrollIndicator = NO;
    __block CGRect pageableNavRect = self.pageableNavView.frame;
    self.pageableNavView.contentSize = CGSizeMake(pageableNavRect.size.width,navItems.count*101/2+(navItems.count-1)*ITEM_MARGIN);
    [navItems enumerateObjectsUsingBlock:^(__strong UIButton *obj,NSUInteger index,BOOL *stop){
        obj.frame = CGRectMake(pageableNavRect.origin.x, pageableNavRect.origin.y, obj.frame.size.width, obj.frame.size.height);
        [self.pageableNavView addSubview:obj];
        pageableNavRect.origin.y += obj.frame.size.height+ITEM_MARGIN;
    }];
    //CGFloat widthOfGroup =
    
}
@end
