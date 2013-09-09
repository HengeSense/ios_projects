//
//  Message.h
//  SmartHome
//
//  Created by hadoop user account on 6/09/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSUInteger, MessageType ){
    MessageTypeNormal,
    MessageTypeVerify,
    MessageTypeWarning
};
typedef NS_ENUM(NSUInteger, MessageState){
    MessageStateRead,
    MessageStateUnread
};
@interface Message : NSObject
@property (strong,nonatomic) NSString *text;
@property (assign,nonatomic) MessageType messageType;
@property (assign,nonatomic) MessageState messageState;
@property (strong,nonatomic) NSDate *createTime;
@property (strong,nonatomic) NSDictionary *data;
@end
