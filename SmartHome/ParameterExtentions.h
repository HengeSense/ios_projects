//
//  ParameterExtentions.h
//  SmartHome
//
//  Created by Zhao yang on 9/18/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ParameterExtentions <NSObject>

- (void)setObject:(id)object forKey:(NSString *)key;
- (id)objectForKey:(NSString *)key;

@end
