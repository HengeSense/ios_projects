//
//  MessageCell.m
//  SmartHome
//
//  Created by hadoop user account on 9/09/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "MessageCell.h"

@implementation MessageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier ofMessage:(Message *) message
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self initUIWithMessage:message];
    }
    return self;
}
-(void) initUIWithMessage:(Message *) message{

    UIView  *view = [[UIView alloc] initWithFrame:self.contentView.frame];
    
    UIImageView *typeMessage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 50/2, 39/2)];
    if (message.messageType == MessageTypeNormal) {
        typeMessage.image = [UIImage imageNamed:@"icon_message.png"];
    }else if(message.messageType == MessageTypeVerify){
        typeMessage.image = [UIImage imageNamed:@"icon_validation.png"];
    }else if(message.messageType == MessageTypeWarning){
        typeMessage.image = [UIImage imageNamed:@"icon_warning"];
    }
    typeMessage.backgroundColor = [UIColor clearColor];
    typeMessage.tag = 1001;
    [view addSubview:typeMessage];
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 5, 240,MESSAGE_CELL_HEIGHT)];
    textLabel.tag = 1000;
    textLabel.font =[UIFont systemFontOfSize:12];
    textLabel.text = [@"  " stringByAppendingString:message.text];
    textLabel.textColor = [UIColor lightTextColor];
    textLabel.lineBreakMode = UILineBreakModeWordWrap;
    textLabel.numberOfLines = 0;
    [view addSubview:textLabel];
    
    UIImageView *accessory = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"message_accessory.png"]];
    accessory.center = CGPointMake(self.frame.size.width-12, self.center.y);
    [view addSubview:accessory];
    
    view.tag =999;
    [self addSubview:view];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
