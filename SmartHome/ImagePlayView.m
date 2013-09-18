//
//  ImagePlayView.m
//  SmartHome
//
//  Created by Zhao yang on 9/17/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "ImagePlayView.h"

@implementation ImagePlayView {
    UIImageView *playView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)initUI {
    if(playView == nil) {
        playView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        [self addSubview:playView];
    }
}

- (void)playWithImage:(UIImage *)img {
    playView.image = img;
}


@end
