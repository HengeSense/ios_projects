//
//  WelcomeImageView.m
//  SmartHome
//
//  Created by hadoop user account on 25/09/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "WelcomeImageView.h"
@implementation WelcomeImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
+(UIImageView *) imageViewWithImageName:(NSString *)imageName{
    NSArray *imageNameSplit = [imageName componentsSeparatedByString:@"."];
    if (imageNameSplit&&imageNameSplit.count == 2) {
       // NSLog(@"%@,%@,%@",[NSBundle mainBundle],[imageNameSplit objectAtIndex:0],[imageNameSplit objectAtIndex:1]);
        NSString *path = [[NSBundle mainBundle] pathForResource:[imageNameSplit objectAtIndex:0] ofType:[imageNameSplit objectAtIndex:1]];
        //NSLog(@"--------path = %@",path);
        if ([path length]>0) {
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:path]];
            //NSLog(@"----------image = %@",[UIImage imageWithContentsOfFile:path]);
            imageView.frame = CGRectMake(0, 0,IMG_WIDTH,IMG_HEIGHT);
            return imageView;
        }
    }
    return [[UIImageView alloc] init];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
