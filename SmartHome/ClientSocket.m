//
//  ClientSocket.m
//  SmartHome
//
//  Created by Zhao yang on 8/15/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "ClientSocket.h"
#import "NSString+StringUtils.h"

#define BUFFER_SIZE 1024

@implementation ClientSocket {
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

- (void)close {
    if(inputStream != nil) {
        [inputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        if(inputStream.streamStatus != NSStreamStatusNotOpen && inputStream.streamStatus != NSStreamStatusClosed) {
            NSLog(@"close1");
            [inputStream close];
        }
        inputStream = nil;
    }
    
    if(outputStream != nil) {
        [outputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        if(outputStream.streamStatus != NSStreamStatusNotOpen && outputStream.streamStatus != NSStreamStatusClosed) {
            
            [outputStream close];
            NSLog(@"close2");
        }
        outputStream = nil;
    }
}

- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode {
//    if(self.delegate == nil) return;
    if(eventCode == NSStreamEventNone) {
        // ignore this event
    } else if(eventCode == NSStreamEventOpenCompleted) {
//        if([self.delegate respondsToSelector:@selector(streamConnectionDidOpen:)]) {
//            [self.delegate streamConnectionDidOpen:aStream];
//        }
        NSLog(@"opened");
    } else if(eventCode == NSStreamEventEndEncountered) {
        NSLog(@"end");
        [self close];
    } else if(eventCode == NSStreamEventErrorOccurred) {
//        [self.delegate connectionError:aStream.streamError];
        

        //aStream.streamError;

        NSLog(@"error");
        [self close];
    } else if(eventCode == NSStreamEventHasBytesAvailable) {
        if(aStream != nil && aStream == inputStream) {
            NSMutableData *data = [NSMutableData data];
            uint8_t buffer[BUFFER_SIZE];
            while([inputStream hasBytesAvailable]) {
                int bytesHasRead = [inputStream read:buffer maxLength:sizeof(buffer)];
                if(bytesHasRead > 0) {
                    [data appendBytes:buffer length:bytesHasRead];
                }
            }
            if(data.length > 0) {
                NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSLog(str);
            }
        }
    } else if(eventCode == NSStreamEventHasSpaceAvailable) {
        NSLog(@" has space available");
    } else {
        
    }
}


- (void)write {
    if(outputStream != nil) {
        if([outputStream hasSpaceAvailable]) {
//            outputStream write: maxLength:
            NSMutableData *data = [NSMutableData data];
            
            [data appendData:
            [[NSString stringWithFormat:@"%@", @"hello  what's up ,, fuck you baby...."] dataUsingEncoding:NSUTF8StringEncoding]
             ];
            


            [outputStream write:data.bytes maxLength:data.length];
        }
    }
}


@end
