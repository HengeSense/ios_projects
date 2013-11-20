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
#define FIXED_WIDTH 9

@interface SMCell : UITableViewCell

@property (assign, nonatomic) BOOL isSingle;
@property (assign, nonatomic) BOOL isTop;
@property (assign, nonatomic) BOOL isCenter;
@property (assign, nonatomic) BOOL isBottom;

@property (assign, nonatomic) BOOL accessoryViewVisible;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier needFixed:(BOOL)fixed;

@end
