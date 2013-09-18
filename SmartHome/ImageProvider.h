//
//  ImageProvider.h
//  SmartHome
//
//  Created by Zhao yang on 9/17/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol ImageProviderDelegate <NSObject>

- (void)imageProviderNotifyAvailable:(NSArray *)imgList provider:(id)provider;

@end

@interface ImageProvider : NSObject

@property (assign, nonatomic) id<ImageProviderDelegate> delegate;




@property (assign, nonatomic) NSUInteger fps;


@end
