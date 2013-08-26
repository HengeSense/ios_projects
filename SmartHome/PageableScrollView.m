//
//  PageableScrollView.m
//  SmartHome
//
//  Created by hadoop user account on 26/08/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "PageableScrollView.h"

@implementation PageableScrollView
@synthesize pageableScrollView;
@synthesize delegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.pageableScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        self.pageableScrollView.delegate = self;
        
        UIImageView *img1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"camera_image.jpg"]];
        UIImageView *img2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"camera_image.jpg"]];
        UIImageView *img3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"camera_image.jpg"]];
        UIImageView *img4 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"camera_image.jpg"]];
        UIImageView *img5 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"camera_image.jpg"]];
        
        NSArray *imgs = [[NSArray alloc] initWithObjects:img1,img2,img3,img4,img5, nil];
        [self pageWithViews:imgs];
        [self addSubview:pageableScrollView];

    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    self.pageableScrollView.alpha = 0.5f;
    if ([self.delegate respondsToSelector:@selector(accessoryBehavior)] ) {
        [self.delegate accessoryBehavior];
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    self.pageableScrollView.alpha = 1.0f;
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;{
    self.pageableScrollView.alpha = 1.0f;
}
-(void) pageWithViews:(NSArray *) views{
    self.pageableScrollView.pagingEnabled = YES;
    self.pageableScrollView.showsHorizontalScrollIndicator = NO;
    CGFloat multiple = (CGFloat) views.count;
    self.pageableScrollView.contentSize = CGSizeMake(self.pageableScrollView.frame.size.width*multiple, self.pageableScrollView.frame.size.height);
    __block CGRect pageableRect = self.pageableScrollView.frame;
    [views enumerateObjectsUsingBlock:^(__strong UIView *obj,NSUInteger index,BOOL *stop){
        
        
        obj.frame = pageableRect;
        [self.pageableScrollView addSubview:obj];
        pageableRect.origin.x += pageableRect.size.width;
        
    }];
}
@end
