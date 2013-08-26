//
//  SMCell.m
//  SmartHome
//
//  Created by Zhao yang on 8/26/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "SMCell.h"
#import "ImageFactory.h"

@implementation SMCell {
    UIImageView *backgroundImageView;
    UIImageView *selectedBackgroundImageView;
}

@synthesize isSingle;
@synthesize isTop;
@synthesize isCenter;
@synthesize isBottom;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initUI];
        if([@"topCellIdentifier" isEqualToString:reuseIdentifier]) {
            self.isTop = YES;
        } else if([@"cellIdentifier" isEqualToString:reuseIdentifier]) {
            self.isCenter = YES;
        } else if([@"bottomCellIdentifier" isEqualToString:reuseIdentifier]) {
            self.isBottom = YES;
        }
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)initUI {
    self.backgroundView = [[UIView alloc] initWithFrame:self.bounds];
    self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.bounds];
    self.textLabel.font = [UIFont systemFontOfSize:16.f];
    self.textLabel.textColor = [UIColor darkGrayColor];
    self.textLabel.highlightedTextColor = [UIColor darkGrayColor];
    
    if(backgroundImageView == nil) {
        backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SM_CELL_WIDTH / 2, SM_CELL_HEIGHT / 2)];
        [self.backgroundView addSubview:backgroundImageView];
    }
    
    if(selectedBackgroundImageView == nil) {
        selectedBackgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SM_CELL_WIDTH / 2, SM_CELL_HEIGHT / 2)];
        [self.selectedBackgroundView addSubview:selectedBackgroundImageView];
    }
}

- (void)setIsSingle:(BOOL)isSingle_ {
    isSingle = isSingle_;
    if(isSingle) {
        isTop = !isSingle_;
        isCenter = !isSingle_;
        isBottom = !isSingle_;
        backgroundImageView.image = [[ImageFactory sharedImageFactory] imageForCellWithIdentifier:@"" selected:NO];
        selectedBackgroundImageView.image = [[ImageFactory sharedImageFactory] imageForCellWithIdentifier:@"" selected:YES];
    }
}

- (void)setIsTop:(BOOL)isTop_ {
    isTop = isTop_;
    if(isTop) {
        isSingle = !isTop_;
        isCenter = !isTop_;
        isBottom = !isTop_;
        backgroundImageView.image = [[ImageFactory sharedImageFactory] imageForCellWithIdentifier:@"topCellIdentifier" selected:NO];
        selectedBackgroundImageView.image = [[ImageFactory sharedImageFactory] imageForCellWithIdentifier:@"topCellIdentifier" selected:YES];
        UIImageView *imgSperatorLineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, SM_CELL_HEIGHT / 2 - 1, SM_CELL_WIDTH / 2, 1)];
        imgSperatorLineView.image = [UIImage imageNamed:@"line_cell_seperator_main.png"];
        [self addSubview:imgSperatorLineView];
    }
}

- (void)setIsCenter:(BOOL)isCenter_ {
    isCenter = isCenter_;
    if(isCenter) {
        isTop = !isCenter_;
        isSingle = !isCenter_;
        isBottom = !isCenter_;
        backgroundImageView.image = [[ImageFactory sharedImageFactory] imageForCellWithIdentifier:@"cellIdentifier" selected:NO];
        selectedBackgroundImageView.image = [[ImageFactory sharedImageFactory] imageForCellWithIdentifier:@"cellIdentifier" selected:YES];
        UIImageView *imgSperatorLineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, SM_CELL_HEIGHT / 2 - 1, SM_CELL_WIDTH / 2, 1)];
        imgSperatorLineView.image = [UIImage imageNamed:@"line_cell_seperator_main.png"];
        [self addSubview:imgSperatorLineView];
    }
}

- (void)setIsBottom:(BOOL)isBottom_ {
    isBottom = isBottom_;
    if(isBottom) {
        isTop = !isBottom_;
        isCenter = !isBottom_;
        isSingle = !isBottom_;
        backgroundImageView.image = [[ImageFactory sharedImageFactory] imageForCellWithIdentifier:@"bottomCellIdentifier" selected:NO];
        selectedBackgroundImageView.image = [[ImageFactory sharedImageFactory] imageForCellWithIdentifier:@"bottomCellIdentifier" selected:YES];
    }
}

@end
