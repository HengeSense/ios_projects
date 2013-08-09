//
//  SmsService.m
//  SmartHome
//
//  Created by hadoop user account on 8/08/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "SmsService.h"
#import "RestClient.h"

#define SMS_URL @"http://si.800617.com:4400"
#define SMS_UN @"ctyswse-27"
#define SMS_PWD @"b3d2dd"
@implementation SmsService {
    RestClient *client;
}

/*
 
 un = @"ctyswse-27";
 pwd = @"b3d2dd";
 urlAsString = @"http://si.800617.com:4400/SendLenSms.aspx";
 mobile = phoneNumber.text;
 verificationCode = [NSString stringWithFormat:@"%i",[self randomIntBetween:100000 andLargerInt:999999]];
 urlAsString = [urlAsString stringByAppendingFormat:@"?un=%@&pwd=%@&mobile=%@&msg=%@",un,pwd,mobile,verificationCode];
 NSURL *url = [NSURL URLWithString:urlAsString];
 NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
 [request setTimeoutInterval:30.0f];
 [request setHTTPMethod:@"POST"];
 NSOperationQueue *queue = [NSOperationQueue new];
 [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(
 NSURLResponse *response,
 NSData *data,
 NSError *error){
 
 
 GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:data options:0 error:&error];
 NSLog(@"url=%@",urlAsString);
 NSLog(@"callback data  = %@",doc.rootElement);
 
 }
 
 ];
 */

- (id)init {
    self = [super init];
    if(self) {
        client = [[RestClient alloc] initWithBaseUrl:SMS_URL];
    }
    return self;
}

- (void)sendMessageFor:(NSString *)msg mobile:(NSString *)phoneNumber {
    [client getForUrl:[SMS_URL stringByAppendingFormat:@"?un=%@&pwd=%@&mobile=%@&msg=%@",SMS_UN,SMS_PWD,phoneNumber,msg] acceptType:@"application/xml" success:@selector(sendMessageSuccess:) error:@selector(sendMessageFailed:) for:self callback:nil];
}

- (void)sendMessageSuccess:(RestResponse *)resp {
    if(resp.statusCode == 200) {
        GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:resp.body options:0 error:NULL];
        NSLog(@"return value = %@",doc);
    }
}

- (void)sendMessageFailed:(RestResponse *)resp {
    
}


@end
