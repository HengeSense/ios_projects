//
//  RestfulCommandService.h
//  SmartHome
//
//  Created by Zhao yang on 9/2/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "ServiceBase.h"
#import "CommandExecutor.h"
#import "CommandFactory.h"

@interface RestfulCommandService : ServiceBase<CommandExecutor>


- (void)getUnitByUrl:(NSString *)url;


/*
 Restful Service Callback Method
 ----------------------------------------------------*/
- (void)getUnitSucess:(RestResponse *)resp;
- (void)getUnitFailed:(RestResponse *)resp;

@end
