//
//  ImageFactory.m
//  SmartHome
//
//  Created by Zhao yang on 8/12/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "ImageFactory.h"

@implementation ImageFactory {
    UIImage *imgBubbleTheirs;
    UIImage *imgBubbleMine;
}

- (UIImage *)imageForBubbleTheirs {
    if(imgBubbleTheirs == nil) {
        imgBubbleTheirs = [[UIImage imageNamed:@"bubble_theirs.png"] stretchableImageWithLeftCapWidth:8 topCapHeight:22];
    }
    return imgBubbleTheirs;
}

- (UIImage *)imageForBubbleMine {
    if(imgBubbleMine == nil) {
        imgBubbleMine = [[UIImage imageNamed:@"bubble_mine.png"] stretchableImageWithLeftCapWidth:8 topCapHeight:22];
    }
    return imgBubbleMine;
}

- (UIImage *)imageForCellWithIdentifier:(NSString *)identifier selected:(BOOL)selected {
    if(identifier == nil) return nil;
    if([@"topCellIdentifier" isEqualToString:identifier]) {
        return [UIImage imageNamed:[NSString stringWithFormat:@"%@%@.png", @"bg_cell_top", selected ? @"_selected" : @""]];
    } else if([@"cellIdentifier" isEqualToString:identifier]) {
        return [UIImage imageNamed:[NSString stringWithFormat:@"%@%@.png", @"bg_cell_center", selected ? @"_selected" : @""]];
    } else if([@"bottomCellIdentifier" isEqualToString:identifier]) {
        return [UIImage imageNamed:[NSString stringWithFormat:@"%@%@.png", @"bg_cell_footer", selected ? @"_selected" : @""]];
    } else {
        return nil;
    }
}

+ (ImageFactory *)sharedImageFactory {
    static ImageFactory *factory = nil;
    if(factory == nil) {
        factory = [[ImageFactory alloc] init];
    }
    return factory;
}

@end
