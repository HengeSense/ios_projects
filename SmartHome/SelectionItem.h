//
//  SelectionItem.h
//  SmartHome
//
//  Created by Zhao yang on 9/6/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SelectionItem : NSObject

@property (strong, nonatomic) NSString *identifier;
@property (strong, nonatomic) NSString *title;

- (id)initWithIdentifier:(NSString *)_id_ andTitle:(NSString *)_t_;

@end
