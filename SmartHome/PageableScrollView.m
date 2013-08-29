//
//  PageableScrollView.m
//  SmartHome
//
//  Created by hadoop user account on 26/08/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "PageableScrollView.h"
#import "ScrollNavButton.h"
#import "SwitchButton.h"
#define MARGIN_X 0
#define MARGIN_Y 12
#define SCROLL_ITEM_WIDTH 240
#define SCROLL_ITEM_HEIGHT 180
#define GROUP_ITEM_WIDRH 80
#define GROUP_ITEM_HEIGHT 52
@implementation PageableScrollView{
    NSArray *navItems;
    NSDictionary *deviceDictionary;
    UIImageView *leftBoundsShadow;
    UIImageView *rightBoundsShadow;
    
}
@synthesize pageableScrollView;
@synthesize pageNavView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.pageableScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        self.pageableScrollView.delegate = self;
        [self addSubview:pageableScrollView];
    }
    return self;
}
-(id)initWithPoint:(CGPoint) point andDictionary:(NSDictionary *) dictionary{
    self = [super initWithFrame:CGRectMake(point.x, point.y, SCROLL_ITEM_WIDTH+20, SCROLL_ITEM_HEIGHT)];
    __block NSMutableArray *mutableNavArr = [[NSMutableArray alloc] initWithObjects: nil];
    __block NSMutableArray *mutableScrollArr = [[NSMutableArray alloc] initWithObjects:nil];
    [dictionary enumerateKeysAndObjectsUsingBlock:^(__strong NSString *key, __strong NSArray *obj, BOOL *stop) {
        UIButton *navBtn = [ScrollNavButton buttonWithNothing];
        [navBtn setTitle:key forState:UIControlStateNormal];
        [navBtn addTarget:self action:@selector(scrollNavButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [mutableNavArr addObject:navBtn];
        CGRect scrollRect = CGRectMake(point.x, point.y, SCROLL_ITEM_WIDTH,SCROLL_ITEM_HEIGHT);
        __block UIView *scrollItem = [[UIView alloc] initWithFrame:scrollRect];
        __block CGPoint lastOrigin = CGPointMake(0, 0);
        [obj enumerateObjectsUsingBlock:^(__strong UIView *obj, NSUInteger idx, BOOL *stop) {
            if (idx%3==0&&idx/3>=1) {
                obj.frame = CGRectMake(0, lastOrigin.y+MARGIN_Y+obj.frame.size.height, obj.frame.size.width, obj.frame.size.height);
                lastOrigin.x = MARGIN_X+obj.frame.size.width;
                lastOrigin.y +=MARGIN_Y+obj.frame.size.height;
            }else{
                obj.frame = CGRectMake(lastOrigin.x, lastOrigin.y, obj.frame.size.width, obj.frame.size.height);
                lastOrigin.x +=MARGIN_X+obj.frame.size.width;
            }
            [scrollItem addSubview:obj];
        }];
        [mutableScrollArr addObject:scrollItem];
    }];
    self.pageableScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 0, SCROLL_ITEM_WIDTH, SCROLL_ITEM_HEIGHT)];
    self.pageableScrollView.delegate = self;
    [self pageWithViews:mutableScrollArr];
    [self addSubview:self.pageableScrollView];
    self.pageNavView = [[PageableNavView alloc] initWithFrame:CGRectMake(point.x+SCROLL_ITEM_WIDTH+MARGIN_X+20, point.y, 101/2,SCROLL_ITEM_HEIGHT) andNavItemsForVertical:mutableNavArr];
    navItems = mutableNavArr;
    
    leftBoundsShadow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lineleft.png"]];
    leftBoundsShadow.frame = CGRectMake(10, 0, 10, SCROLL_ITEM_HEIGHT);
    rightBoundsShadow =  [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lineright.png"]];
    rightBoundsShadow.frame = CGRectMake(SCROLL_ITEM_WIDTH, 0, 10, SCROLL_ITEM_HEIGHT);
    [self addSubview:leftBoundsShadow];
    [self addSubview:rightBoundsShadow];
    leftBoundsShadow.hidden = YES;
    rightBoundsShadow.hidden = YES;
    if (dictionary.count>1) {
        rightBoundsShadow.hidden = NO;
    }
    
    return self;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self accessoryBehavior];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self accessoryBehavior];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;{
}

-(void) pageWithViews:(NSArray *) views{
    self.pageableScrollView.pagingEnabled = YES;
    self.pageableScrollView.showsHorizontalScrollIndicator = NO;
    CGFloat multiple = (CGFloat) views.count;
    NSInteger groupCount = views.count/3;
    CGFloat contentHeight = groupCount<3?SCROLL_ITEM_HEIGHT:groupCount*(GROUP_ITEM_HEIGHT+MARGIN_Y)-MARGIN_Y;
    self.pageableScrollView.contentSize = CGSizeMake(self.pageableScrollView.frame.size.width*multiple,contentHeight);
    __block CGRect pageableRect = self.pageableScrollView.frame;
    [views enumerateObjectsUsingBlock:^(__strong UIView *obj,NSUInteger index,BOOL *stop){
        obj.frame = pageableRect;
        [self.pageableScrollView addSubview:obj];
        pageableRect.origin.x += pageableRect.size.width;
        
    }];
}

-(void) scrollNavButtonAction:(UIButton *)sender{
    __block NSInteger curNav;
    [navItems enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL *stop) {
        obj.selected = NO;
        obj.titleLabel.font = [UIFont systemFontOfSize:16];
        if ([obj isEqual:sender]) {
            curNav = idx;
        }
    }];
    sender.selected = YES;
    sender.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.pageableScrollView scrollRectToVisible:CGRectMake(self.pageableScrollView.frame.size.width*curNav, self.pageableScrollView.frame.origin.y,SCROLL_ITEM_WIDTH, SCROLL_ITEM_WIDTH) animated:YES];
}

-(void) accessoryBehavior{
    CGFloat itemWidth = self.pageableScrollView.frame.size.width;
    CGFloat xOffset = self.pageableScrollView.contentOffset.x;
    CGPoint navOffset = self.pageNavView.pageableNavView.contentOffset;
    CGFloat navHeight = 30+ITEM_MARGIN;
    
    NSInteger curPage = xOffset/itemWidth;
    [navItems enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL *stop) {
        obj.selected = NO;
        obj.titleLabel.font = [UIFont systemFontOfSize:16];
        if (curPage == idx) {
            obj.selected = YES;
            obj.titleLabel.font = [UIFont systemFontOfSize:18];

        }
    }];
    CGFloat curNavYOffset = navHeight*curPage;
    if (navOffset.y+pageNavView.pageableNavView.frame.size.height<curNavYOffset) {
        self.pageNavView.pageableNavView.contentOffset = CGPointMake(navOffset.x, navOffset.y+navHeight);
    }
    if(navOffset.y>curNavYOffset){
        self.pageNavView.pageableNavView.contentOffset = CGPointMake(navOffset.x, navOffset.y-navHeight);
    }
    
    if (xOffset <= 0) {
        rightBoundsShadow.hidden = NO;
        leftBoundsShadow.hidden = YES;
    }else if (xOffset<self.pageableScrollView.contentSize.width-SCROLL_ITEM_WIDTH){
        leftBoundsShadow.hidden = NO;
        rightBoundsShadow.hidden = NO;
    }else{
        leftBoundsShadow.hidden = NO;
        rightBoundsShadow.hidden = YES;
    }
}

- (void)notifyStatusChangedFor:(NSString *)deviceID status:(NSString *)status {
    [deviceDictionary enumerateKeysAndObjectsUsingBlock:^(id key, __strong NSArray *obj, BOOL *stop) {
        [obj enumerateObjectsUsingBlock:^(__strong SwitchButton *obj, NSUInteger idx, BOOL *stop) {
            if ([obj.deviceID isEqualToString:deviceID]) {
                obj.status = status;
                return ;
            }
        }];
    }];
}

@end
