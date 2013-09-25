//
//  RestfulCommandService.h
//  SmartHome
//
//  Created by Zhao yang on 9/2/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "ServiceBase.h"
#import "CommandFactory.h"

@interface RestfulCommandService : ServiceBase

- (void)getUnitByUrl:(NSString *)url;

@end
