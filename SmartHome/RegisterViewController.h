//
//  RegisterViewController.h
//  SmartHome
//
//  Created by Zhao yang on 8/5/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMLElement.h"
#import "GDataXMLNode.h"
#import "BaseViewController.h"

@interface RegisterViewController : BaseViewController<NSXMLParserDelegate>

@property (strong,nonatomic) NSXMLParser *xmlParser;

@end
