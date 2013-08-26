//
//  SMCell.h
//  SmartHome
//
//  Created by Zhao yang on 8/26/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SM_CELL_HEIGHT 93
#define SM_CELL_WIDTH  624

@interface SMCell : UITableViewCell

@property (assign, nonatomic) BOOL isSingle;
@property (assign, nonatomic) BOOL isTop;
@property (assign, nonatomic) BOOL isCenter;
@property (assign, nonatomic) BOOL isBottom;

@end
