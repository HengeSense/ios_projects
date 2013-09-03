//
//  DeviceCommandHandler.m
//  SmartHome
//
//  Created by Zhao yang on 8/29/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "DeviceCommandHandler.h"
@interface DeviceCommandHandler()
@property(unsafe_unretained) NSUInteger myHash;
@end
@implementation DeviceCommandHandler
-(id) init{
    self = [super init];
    if (self) {
        _myHash = (NSUInteger) self;
    }
    return  self;
}
- (void)handle:(DeviceCommand *)command {
    
}
-(id) copyWithZone:(NSZone *)zone{
    id aCopy = [[self.class alloc] init];
    if (aCopy) {
        [aCopy setMyHash:self.myHash];
    }
    return aCopy;
}
-(BOOL) isEqual:(id)object{
    return self.myHash == ((DeviceCommandHandler *) object).myHash;
}
-(NSUInteger) hash{
    return _myHash;
}
@end
