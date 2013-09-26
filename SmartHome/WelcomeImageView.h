//
//  WelcomeImageView.h
//  SmartHome
//
//  Created by hadoop user account on 25/09/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>
#define IMG_HEIGHT [UIScreen mainScreen].bounds.size.height

#define IMG_WIDTH  [UIScreen mainScreen].bounds.size.width


@interface WelcomeImageView : UIImageView
+(UIImageView *) imageViewWithImageName:(NSString *) imageName;
@end