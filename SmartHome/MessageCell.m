//
//  MessageCell.m
//  SmartHome
//
//  Created by hadoop user account on 9/09/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "MessageCell.h"

@implementation MessageCell
@synthesize notificaion;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier ofMessage:(SMNotification *) message
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self initUIWithMessage:message];
        self.notificaion = message;
    }
    return self;
}
-(void) initUIWithMessage:(SMNotification *) message{

    UIView  *view = [[UIView alloc] initWithFrame:self.contentView.frame];
    view.backgroundColor = [UIColor clearColor];
    
    UIImageView *typeMessage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 50/2, 39/2)];
    if ([message.type isEqualToString:@"MS"]||[message.type isEqualToString:@"AT"]) {
        typeMessage.image = [UIImage imageNamed:@"icon_message.png"];
    }else if([message.type isEqualToString:@"CF"]){
        typeMessage.image = [UIImage imageNamed:@"icon_validation.png"];
    }else if([message.type isEqualToString:@"AL"]){
        typeMessage.image = [UIImage imageNamed:@"icon_warning"];
    }
    typeMessage.backgroundColor = [UIColor clearColor];
    typeMessage.tag = TYPE_IMAGE_TAG;
    [view addSubview:typeMessage];
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 5, 240,MESSAGE_CELL_HEIGHT)];
    textLabel.tag = TEXT_LABEL_TAG;
    textLabel.font =[UIFont systemFontOfSize:12];
    textLabel.text = [@"    " stringByAppendingString:message.text];
    textLabel.textColor = [UIColor lightTextColor];
    textLabel.lineBreakMode = UILineBreakModeWordWrap;
    textLabel.numberOfLines = 0;
    textLabel.backgroundColor = [UIColor clearColor];
    [view addSubview:textLabel];
    
    UIImageView *accessory = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"message_accessory.png"]];
    accessory.center = CGPointMake(self.frame.size.width-12, self.center.y+15);
    [view addSubview:accessory];
    
    view.tag = CELL_VIEW_TAG;
    [self addSubview:view];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
