//
//  ButtonPanelCell.h
//  SmartHome
//
//  Created by hadoop user account on 18/11/2013.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMCell.h"
#define PANEL_CELL_HIGHT 30
@interface ButtonPanelCell : UITableViewCell
@property (assign,nonatomic) BOOL isCenter;
@property (assign,nonatomic) BOOL isBottom;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier needFixed:(BOOL)fixed;
@end
