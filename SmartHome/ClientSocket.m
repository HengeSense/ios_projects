//
//  ClientSocket.m
//  SmartHome
//
//  Created by Zhao yang on 8/15/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "ClientSocket.h"
#import "CommunicationMessage.h"

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
        
        NSMutableData *data = [[NSMutableData alloc] init];
        int totalRead = 0;
        
        //
        uint8_t header[1];
        totalRead = [inputStream read:header maxLength:1];
        if(totalRead != 1) {
            //unknow exception
            //need return
            NSLog(@"unknonw");
        }
        [data appendBytes:header length:1];

        if(header[0] != 127) {
            //error data
            NSLog(@"error code is ...  %d   ", header[0]);
        }
        
        //
        totalRead = 0;
        uint8_t dataLengthBuffer[4];
        while (inputStream.hasBytesAvailable && totalRead != 4) {
            int bytesRead = [inputStream read:dataLengthBuffer maxLength:4 - totalRead];
            if(bytesRead > 0) {
                [data appendBytes:dataLengthBuffer length:bytesRead];
                totalRead += bytesRead;
            }
        }
        
        //
        uint8_t dataLength[4];
        [data getBytes:dataLength range:NSMakeRange(1, 4)];
        NSUInteger length = [BitUtils bytes2Int:dataLength];
        
        NSLog(@" the length is    %d", length);
        
        totalRead = 0;
        uint8_t dataDomainBuffer[BUFFER_SIZE];
        while(inputStream.hasBytesAvailable && totalRead != length) {
            int bytesRead = [inputStream read:dataDomainBuffer maxLength:length - totalRead];
            if(bytesRead > 0) {
                [data appendBytes:dataDomainBuffer length:bytesRead];
                totalRead += bytesRead;
            }
        }
        
        if(totalRead == length) {
            NSLog(@"刚好");
        } else if(totalRead > length) {
            NSLog(@"读多了 应该不可能发生");
        } else  {
            NSLog(@"读少了 奇怪啊...   不做处理 记录断点 ...");
        }
       
        if(inputStream.hasBytesAvailable) {
            NSLog(@"还有");
        } else {
            NSLog(@"没有了");
        }
        
        NSString *str =        [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(str);
        
        
//        if(aStream != nil && aStream == inputStream) {
//            NSMutableData *data = [NSMutableData data];
//            uint8_t buffer[BUFFER_SIZE];
//            while([inputStream hasBytesAvailable]) {
//                int bytesHasRead = [inputStream read:buffer maxLength:sizeof(buffer)];
//                if(bytesHasRead > 0) {
//                    [data appendBytes:buffer length:bytesHasRead];
//                }
//            }
//            if(data.length > 0) {
//                NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//                NSLog(str);
//                NSLog(@"-->");
//            }
//        }
    } else if(eventCode == NSStreamEventHasSpaceAvailable) {
        
        static NSString *str = @"";
        if([@"" isEqualToString:str]) {
        if(aStream != nil && aStream == outputStream) {
            NSLog(@" has space available");
            CommunicationMessage *ms =   [[CommunicationMessage alloc] init];

            ms.deviceCommand = [[DeviceCommand alloc] init];

            NSData *ddd =  [ms generateData];
            [self writeData:ddd];

        }
            str = @"full";
        }
//
//            NSLog(@"%@",            outputStream.hasSpaceAvailable ? @"yes":@"no");
//            NSLog(@"writted");
//        }


    } else {
        
    }
}

- (void)writeData:(NSData *)data {
    if(outputStream != nil) {
        if([outputStream hasSpaceAvailable]) {
            [outputStream write:data.bytes maxLength:data.length];
        }
    }
}


@end
