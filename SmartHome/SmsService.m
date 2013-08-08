//
//  SmsService.m
//  SmartHome
//
//  Created by hadoop user account on 8/08/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "SmsService.h"
#import "RestClient.h"

#define SMS_URL  @"http://si.800617.com:4400"
#define SMS_UN   @"ctyswse-27"
#define SMS_PWD  @"b3d2dd"


@implementation SmsService {

}

- (id)init {
    self = [super init];
    if(self) {
        [self setupWithUrl:SMS_URL];
    }
    return self;
}

- (void)sendMessage:(NSString *)message for:(NSString *)phoneNumber {
    [self.client getForUrl:
        [SMS_URL stringByAppendingFormat:@"?un=%@&pwd=%@&mobile=%@&msg=%@",
         SMS_UN, SMS_PWD, phoneNumber,message] acceptType:@"application/xml"
         success:@selector(sendMessageSuccess:) error:@selector(sendMessageFailed:)
         for:self callback:nil];
}

- (void)sendMessageSuccess:(RestResponse *)resp {
    if(resp.statusCode == 200) {
        //  resp.body
    } else {
        [self sendMessageFailed:resp];
    }
}

- (void)sendMessageFailed:(RestResponse *)resp {
    
}

@end
