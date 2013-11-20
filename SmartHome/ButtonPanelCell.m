//
//  ButtonPanelCell.m
//  SmartHome
//
//  Created by hadoop user account on 18/11/2013.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "ButtonPanelCell.h"
#import "ImageFactory.h"
@implementation ButtonPanelCell {
    UIImageView *backgroundImageView;
    UIImageView *selectedBackgroundImageView;
    BOOL needFixed;
}
@synthesize isBottom,isCenter;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier needFixed:(BOOL)fixed{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        needFixed = fixed;
        [self initUI];
        if ([reuseIdentifier isEqualToString:@"centerPanelIdentifier"]) {
            self.isCenter = YES;
        }else if ([reuseIdentifier isEqualToString:@"bottomPanelIdentifier"]){
            self.isBottom = YES;
        }
    }
    return self;
}
-(void) initUI{
    self.frame = CGRectMake(0, 0, SM_CELL_WIDTH / 2, SM_CELL_HEIGHT/2);
    self.backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SM_CELL_WIDTH / 2, SM_CELL_HEIGHT/2)];
    self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.bounds];
    self.textLabel.font = [UIFont systemFontOfSize:16.f];
    self.textLabel.textColor = [UIColor blackColor];
    self.textLabel.highlightedTextColor = [UIColor darkGrayColor];
    
    if(backgroundImageView == nil) {
        backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self.backgroundView addSubview:backgroundImageView];
    }
    if(selectedBackgroundImageView == nil) {
        selectedBackgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self.selectedBackgroundView addSubview:selectedBackgroundImageView];
    }

    
}
-(void) setIsCenter:(BOOL) isCenter_{
    isCenter = isCenter_;
    if(isCenter) {
        isBottom = !isCenter_;
        backgroundImageView.image = [[ImageFactory sharedImageFactory] imageForCellWithIdentifier:@"cellIdentifier" selected:NO];
        selectedBackgroundImageView.image = [[ImageFactory sharedImageFactory] imageForCellWithIdentifier:@"cellIdentifier" selected:YES];
        UIImageView *imgSperatorLineView = [[UIImageView alloc] initWithFrame:CGRectMake(needFixed ? FIXED_WIDTH : 0, SM_CELL_HEIGHT / 2 - 1, SM_CELL_WIDTH / 2, 1)];
        imgSperatorLineView.image = [UIImage imageNamed:@"line_cell_seperator_main.png"];
        imgSperatorLineView.tag = 8888;
        [self addSubview:imgSperatorLineView];
    }
}
-(void) setIsBottom:(BOOL)isBottom_{
    isBottom  = isBottom_;
    if (isBottom) {
        isCenter  = !isBottom_;
        backgroundImageView.image = [[ImageFactory sharedImageFactory] imageForCellWithIdentifier:@"bottomCellIdentifier" selected:NO];
        selectedBackgroundImageView.image = [[ImageFactory sharedImageFactory] imageForCellWithIdentifier:@"bottomCellIdentifier" selected:YES];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}

@end
