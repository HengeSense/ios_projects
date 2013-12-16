//
//  XXEventSubscriptionPublisher.h
//  XXToolKit
//
//  Created by Zhao yang on 12/11/13.
//  Copyright (c) 2013 xuxiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XXEventSubscription.h"

@interface XXEventSubscriptionPublisher : NSObject

/**
 *  Singleton
 */
+ (XXEventSubscriptionPublisher *)defaultPublisher;


/**
 *
 *
 */
- (void)publishWithEvent:(XXEvent *)event;
- (void)publishWithEvent:(XXEvent *)event exceptSubscribersArray:(NSArray *)subscribers;
- (void)publishWithEvent:(XXEvent *)event exceptSubscriberIdsArray:(NSArray *)subscriberIds;


/**
 *
 *
 */
- (void)subscribeFor:(XXEventSubscription *)subscription;
- (void)unSubscribeForSubscription:(XXEventSubscription *)subscription;
- (void)unSubscribeForSubscriber:(id<XXEventSubscriber>)subscriber;
- (void)unSubscribeForSubscriberId:(NSString *)subscriberId;
- (void)unsubscribeAllSubscriptions;

@end



