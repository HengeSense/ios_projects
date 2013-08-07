//
//  XMLElement.h
//  SmartHome
//
//  Created by hadoop user account on 7/08/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMLElement : NSObject
@property (strong,nonatomic) NSString *name;
@property (strong,nonatomic) NSString *text;
@property (strong,nonatomic) NSDictionary *attributes;
@property (strong,nonatomic) NSMutableArray *subElements;
@property (weak,nonatomic) XMLElement *parent;
@end
