//
//  XMLElement.m
//  SmartHome
//
//  Created by hadoop user account on 7/08/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "XMLElement.h"

@implementation XMLElement
@synthesize name;
@synthesize text;
@synthesize attributes;
@synthesize subElements;
@synthesize parent;
-(NSMutableArray *) subElements{
    if(subElements ==nil){
        subElements = [[NSMutableArray alloc] init];
    }
    return subElements;
}
@end
