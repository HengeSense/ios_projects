//
//  Message.h
//  SmartHome
//
//  Created by hadoop user account on 6/09/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, MessageType){
    
};
@interface Message : NSObject
@property (strong,nonatomic) NSString *content;
@property (strong,nonatomic) NSString *type;
@property (strong,nonatomic) NSString *state;
@end
