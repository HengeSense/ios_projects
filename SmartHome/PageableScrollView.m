//
//  PageableScrollView.m
//  SmartHome
//
//  Created by hadoop user account on 26/08/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "PageableScrollView.h"
#import "ScrollNavButton.h"
#import "DeviceButton.h"

#define MARGIN_X 0
#define MARGIN_Y 12
#define SCROLL_ITEM_WIDTH 240
#define SCROLL_ITEM_HEIGHT 180
#define GROUP_ITEM_WIDRH 80
#define GROUP_ITEM_HEIGHT 52

@implementation PageableScrollView{
    NSArray *navItems;
    NSMutableDictionary *deviceDictionary;
    UIImageView *leftBoundsShadow;
    UIImageView *rightBoundsShadow;
    UIViewController *ownerController;
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

- (id)initWithPoint:(CGPoint)point owner:(UIViewController *)owner {
    self = [super initWithFrame:CGRectMake(point.x, point.y, SCROLL_ITEM_WIDTH+20+101/2, SCROLL_ITEM_HEIGHT)];
    if(self) {
        ownerController = owner;
        //
        self.pageableScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCROLL_ITEM_WIDTH, SCROLL_ITEM_HEIGHT)];
        leftBoundsShadow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lineleft.png"]];
        leftBoundsShadow.frame = CGRectMake(0, 0, 10, SCROLL_ITEM_HEIGHT);
        rightBoundsShadow =  [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lineright.png"]];
        rightBoundsShadow.frame = CGRectMake(SCROLL_ITEM_WIDTH-10, 0, 10, SCROLL_ITEM_HEIGHT);
        [self addSubview:leftBoundsShadow];
        [self addSubview:rightBoundsShadow];
        leftBoundsShadow.hidden = YES;
        rightBoundsShadow.hidden = YES;
        rightBoundsShadow.hidden = YES;
    }
    return self;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if(!scrollView.isDecelerating) {
        [self accessoryBehavior];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self accessoryBehavior];
}

- (void)loadDataWithDictionary:(Unit *)unit {
    if (unit == nil) return;
    
    NSArray *zones = unit.zones;
    NSMutableArray *rooms = [NSMutableArray new];
    NSMutableArray *devicesOfRooms = [NSMutableArray new];
    for (Zone *zone in zones) {
        NSArray *devices = zone.devices;
        NSMutableArray *devicesBtn = [NSMutableArray new];
        [rooms addObject:zone.name];
        for (Device *device in devices) {
            DeviceButton *db = [DeviceButton buttonWithDevice:device point:CGPointMake(0, 0) owner:ownerController];
            [devicesBtn addObject:db];
        }
        [devicesOfRooms addObject:devicesBtn];
    }
    deviceDictionary = [[NSMutableDictionary alloc] initWithObjects:devicesOfRooms forKeys:rooms];
    
    __block NSMutableArray *mutableNavArr = [[NSMutableArray alloc] initWithObjects: nil];
    __block NSMutableArray *mutableScrollArr = [[NSMutableArray alloc] initWithObjects:nil];
    [deviceDictionary enumerateKeysAndObjectsUsingBlock:^(__strong NSString *key, __strong NSArray *obj, BOOL *stop) {
        NSInteger groupCount = obj.count/9+1;
        CGFloat contentHeight = groupCount*SCROLL_ITEM_HEIGHT;
        UIButton *navBtn = [ScrollNavButton buttonWithNothing];
        [navBtn setTitle:key forState:UIControlStateNormal];
        [navBtn addTarget:self action:@selector(scrollNavButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [mutableNavArr addObject:navBtn];
        CGRect scrollRect = CGRectMake(0,0, SCROLL_ITEM_WIDTH,SCROLL_ITEM_HEIGHT);
        __block UIScrollView *scrollItem = [[UIScrollView alloc] initWithFrame:scrollRect];
        scrollItem.contentSize = CGSizeMake(SCROLL_ITEM_WIDTH, contentHeight);
        scrollItem.showsVerticalScrollIndicator = NO;
        scrollItem.pagingEnabled = YES;
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
    
    
    CGFloat multiple = (CGFloat) unit.zones.count;
    if (self.pageableScrollView == nil) {
        self.pageableScrollView.contentSize = CGSizeMake(self.pageableScrollView.frame.size.width*multiple,SCROLL_ITEM_HEIGHT);
        [self pageWithViews:mutableScrollArr];
        [self addSubview:self.pageableScrollView];
    }else{
        [self removeSubviews:self.pageableScrollView];
        [self pageWithViews:mutableScrollArr];
    }

    self.pageNavView = [[PageableNavView alloc] initWithFrame:CGRectMake(SCROLL_ITEM_WIDTH+MARGIN_X+20, 0, 101/2,SCROLL_ITEM_HEIGHT) andNavItemsForVertical:mutableNavArr];
    [self addSubview:self.pageNavView];

    navItems = mutableNavArr;

}
-(void) pageWithViews:(NSArray *) views{
    self.pageableScrollView.pagingEnabled = YES;
    self.pageableScrollView.showsHorizontalScrollIndicator = NO;
    __block CGRect pageableRect = self.pageableScrollView.frame;
    [views enumerateObjectsUsingBlock:^(__strong UIView *obj,NSUInteger index,BOOL *stop){
        obj.frame = pageableRect;
        [self.pageableScrollView addSubview:obj];
        pageableRect.origin.x += pageableRect.size.width;
        
    }];
}
-(void) removeSubviews:(UIView *) v{
    NSArray *subviews = v.subviews;
    for (UIView *view in subviews) {
        [view removeFromSuperview];
    }
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

- (void)notifyStatusChangedFor:(NSString *)deviceId {
    if(deviceDictionary == nil) return;
    NSEnumerator *zonesEnumerator = deviceDictionary.keyEnumerator;
    for(NSArray *zone in zonesEnumerator) {
        for(int i=0; i<zone.count; i++) {
            DeviceButton *btnDevice = [zone objectAtIndex:i];
            if(btnDevice != nil) {
                if([deviceId isEqualToString:btnDevice.device.identifier]) {
                    [btnDevice refresh];
                    return;
                }
            }
        }
    }
}

@end
