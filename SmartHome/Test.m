//
//  Test.m
//  SmartHome
//
//  Created by Zhao yang on 8/15/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "Test.h"
#import "NSString+StringUtils.h"

@implementation Test {
    NSInputStream *inputStream;
    NSOutputStream *outputStream;
}

@synthesize delegate;
@synthesize ipAddress;
@synthesize port;

- (id)initWithIPAddress:(NSString *)ip andPort:(NSInteger)portNumber {
    self = [super init];
    if(self) {
        self.ipAddress = ip;
        self.port = portNumber;
    }
    return self;
}

- (void)connect {
    CFReadStreamRef readStream = NULL;
    CFWriteStreamRef writeStream = NULL;
    
    CFStreamCreatePairWithSocketToHost(NULL, (__bridge CFStringRef)self.ipAddress, self.port, &readStream, &writeStream);
    inputStream = CFBridgingRelease(readStream);
    outputStream = CFBridgingRelease(writeStream);

    inputStream.delegate = self;
    outputStream.delegate = self;
    
    [inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    
    [inputStream open];
    [outputStream open];
    
    [[NSRunLoop currentRunLoop] run];
}

- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode {
//    if(self.delegate == nil) return;

    switch(eventCode) {
        case NSStreamEventNone:
            NSLog(@"none  empty ....");
            break;
        case NSStreamEventOpenCompleted:
            NSLog(@"opened ....");
            break;
        case NSStreamEventHasBytesAvailable:
            NSLog(@"has bytes available");
            break;
        case NSStreamEventHasSpaceAvailable:
            NSLog(@"has space avalible");
            break;
        case NSStreamEventEndEncountered:
            NSLog(@"end ....");
            [self close];
            break;
        case NSStreamEventErrorOccurred:
            NSLog(@"error ....");
            [self close];
            break;
        default:
            break;
    }
}

- (void)close {
    if(inputStream != nil) {
        [inputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        [inputStream close];
        inputStream = nil;
    }
    
    if(outputStream != nil) {
        [outputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        [outputStream close];
        outputStream = nil;
    }
}

@end
