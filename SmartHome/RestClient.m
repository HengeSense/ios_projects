//
//  RestClient.m
//  topsales
//
//  Created by young on 4/10/13.
//  Copyright (c) 2013 young. All rights reserved.
//

#import "RestClient.h"

@implementation RestClient {
    
@private NSString *authKey;
    
}

@synthesize authName=_authName, authPassword=_authPassword, baseUrl=_baseUrl,
timeoutInterval=_timeoutInterval, auth=_auth;

- (id)initWithBaseUrl:(NSString *)u {
    self = [super init];
    if(self) {
        self.baseUrl = u;
        self.auth = AuthenticationTypeNone;
    }
    return self;
}

- (id)initWithBaseUrl:(NSString *)u authName:(id)n authPassword:(id)p authType:(AuthenticationType)a {
    self = [[RestClient alloc] init];
    if(self) {
        self.baseUrl = u;
        self.authName = n;
        self.authPassword = p;
        self.auth = a;
    }
    return self;
}

- (void)getForUrl:(NSString *)u acceptType:(NSString *)a success : (SEL)s error:(SEL)e for:(NSObject *)obj callback:(id)cb {
    NSDictionary *headers = nil;
    if(a != nil) {
        headers = [NSDictionary dictionaryWithObjectsAndKeys:a, @"Accept", nil];
    }
    [self executeForUrl:u method:@"GET" headers:headers body : nil success:s error:e for:obj callback:cb];
}

- (void)postForUrl:(NSString *)u acceptType:(NSString *)a contentType:(id)c body:(NSData *)b success:(SEL)s error:(SEL)e for:(NSObject *)obj callback:(id)cb {
    NSMutableDictionary *headers = nil;
    if(a != nil || c != nil) {
        headers = [[NSMutableDictionary alloc] init];
        if(c != nil) {
            [headers setObject:c forKey:@"Content-Type"];
        }
        if(a != nil) {
            [headers setObject:a forKey:@"Accept"];
        }
    }
    [self executeForUrl:u method:@"POST" headers:headers body:b success:s error:e for:obj callback:cb];
}

- (void)putForUrl:(NSString *)u acceptType:(NSString *)a contentType:(NSString *)c body:(NSData *)b success:(SEL)s error:(SEL)e for:(NSObject *)obj callback:(id)cb{
    NSMutableDictionary *headers = nil;
    if(a != nil || c != nil) {
        headers = [[NSMutableDictionary alloc] init];
        if(c != nil) {
            [headers setObject:c forKey:@"Content-Type"];
        }
        if(a != nil) {
            [headers setObject:a forKey:@"Accept"];
        }
    }
    [self executeForUrl:u method:@"PUT" headers:headers body:b success:s error:e for:obj callback:cb];
}

- (void) deleteForUrl:(NSString *)u success:(SEL)s error:(SEL)e for:(NSObject *)obj callback:(id)cb{
    [self executeForUrl:u method:@"DELETE" headers:nil body:nil success:s error:e for:obj callback:cb];
}

- (void)executeForUrl:(NSString *)u method:(NSString *)m headers:(NSDictionary *)h body : (NSData *) b success:(SEL)s error:(SEL)e for:(NSObject *)obj callback:(id)cb {
    @try {
        NSMutableURLRequest *request =[[NSMutableURLRequest alloc] initWithURL: [self getFullUrl:u] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:self.timeoutInterval];
        request.HTTPMethod = m;
        if(h != nil) {
            request.allHTTPHeaderFields = h;
            if(self.auth == AuthenticationTypeBasic) {
                if(authKey == nil) {
                    authKey = [NSString stringEncodeWithBase64:[NSString stringWithFormat:@"%@:%@", self.authName, self.authPassword]];
                }
                [request setValue:[NSString stringWithFormat:@"Basic %@", authKey] forHTTPHeaderField:@"Authorization"];
            }
        }
        request.HTTPBody = b;
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        [NSURLConnection sendAsynchronousRequest:request queue:queue
                               completionHandler:^(NSURLResponse *resp, NSData *data, NSError *error) {
                                   RestResponse *response = [[RestResponse alloc] init];
                                   if(error == nil) {
                                       if(obj != nil && s != nil) {
                                           if([obj respondsToSelector:s]) {
                                               if([resp isMemberOfClass:[NSHTTPURLResponse class]]) {
                                                   NSHTTPURLResponse *rp = (NSHTTPURLResponse *)resp;
                                                   response.statusCode = rp.statusCode;
                                                   response.body = data;
                                                   response.callbackObject = cb;
                                                   response.contentType = [rp.allHeaderFields valueForKey:@"Content-Type"];
                                                   response.headers = rp.allHeaderFields;
                                                   [obj performSelectorOnMainThread:s withObject:response waitUntilDone:NO];
                                               }
                                           }
                                       }
                                   } else {
                                       if(obj != nil && e != nil) {
                                           if([obj respondsToSelector:e]) {
                                               response.statusCode = error.code;
                                               response.failedReason = error.localizedFailureReason;
                                               [obj performSelectorOnMainThread:e withObject:response waitUntilDone:NO];
                                           }
                                       }
                                   }
                               }];
    } @catch (NSException *ex) {
        RestResponse *response = [[RestResponse alloc] init];
        response.statusCode = 500; //Server internal error
        response.failedReason = ex.reason;
        [obj performSelectorOnMainThread:e withObject:response waitUntilDone:NO];
    }
}

- (NSInteger)timeoutInterval {
    if(_timeoutInterval <= 0) {
        _timeoutInterval = 30;
    }
    return _timeoutInterval;
}

- (NSURL *)getFullUrl:(NSString *)relativeUrl {
    if([NSString isBlank:relativeUrl]) return [[NSURL alloc] initWithString:self.baseUrl];
    if([NSString isBlank:self.baseUrl]) return [[NSURL alloc] initWithString:relativeUrl];
    
    BOOL hasEnd;
    BOOL hasStart;
    NSString *fullUrl;
    
    //this is a query string
    if([relativeUrl hasPrefix:@"?"]) {
        fullUrl = [self.baseUrl stringByAppendingString:relativeUrl];
    } else {
        hasEnd = [self.baseUrl hasSuffix:@"/"];
        hasStart = [relativeUrl hasPrefix:@"/"];
        if(hasEnd && hasStart) {
            fullUrl = [self.baseUrl stringByAppendingString:[relativeUrl substringFromIndex:1]];
        } else if(!hasEnd && !hasStart) {
            fullUrl = [[self.baseUrl stringByAppendingString:@"/"] stringByAppendingString:relativeUrl];
        } else {
            fullUrl = [self.baseUrl stringByAppendingString:relativeUrl];
        }
    }
    return [[NSURL alloc] initWithString:fullUrl];
}

@end

