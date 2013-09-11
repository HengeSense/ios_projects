//
//  MessageCell.m
//  SmartHome
//
//  Created by hadoop user account on 9/09/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "MessageCell.h"

@implementation MessageCell{
    UIView  *view;
    UIImageView *typeMessage;
    UILabel *textLabel;
    UIImageView *accessory;
    UIImageView *seperatorLine;
}
@synthesize notificaion;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier 
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initUI];
    }
    return self;
}
-(void) initUI{
    
    if (typeMessage == nil) {
        typeMessage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 50/2, 39/2)];
        typeMessage.backgroundColor = [UIColor clearColor];
    }
    
    if (textLabel == nil) {
        textLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 5, 240,MESSAGE_CELL_HEIGHT)];
        textLabel.tag = TEXT_LABEL_TAG;
        textLabel.font =[UIFont systemFontOfSize:12];
        textLabel.textColor = [UIColor lightTextColor];
        textLabel.lineBreakMode = UILineBreakModeWordWrap;
        textLabel.numberOfLines = 0;
        textLabel.backgroundColor = [UIColor clearColor];

    }
    
    if (accessory == nil) {
        accessory = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"message_accessory.png"]];
        accessory.frame = CGRectMake(self.frame.size.width-10, 28, 12/2, 31/2);

    }
    
    if (seperatorLine == nil) {
       seperatorLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"line_cell_selection_view.png"]];
        seperatorLine.frame = CGRectMake(0, MESSAGE_CELL_HEIGHT-1, 320, 1);

    }
    if(view == nil){
        view = [[UIView alloc] initWithFrame:self.contentView.frame];
        view.backgroundColor = [UIColor clearColor];
        [view addSubview:typeMessage];
        [view addSubview:textLabel];
        [view addSubview:accessory];
        [view addSubview:seperatorLine];
        [self addSubview:view];
    }
    self.selectionStyle = UITableViewCellSelectionStyleNone;


}
-(void) loadWithMessage:(SMNotification *) message{
    if ([message.type isEqualToString:@"MS"]||[message.type isEqualToString:@"AT"]) {
        typeMessage.image = [UIImage imageNamed:@"icon_message.png"];
    }else if([message.type isEqualToString:@"CF"]){
        typeMessage.image = [UIImage imageNamed:@"icon_validation.png"];
    }else if([message.type isEqualToString:@"AL"]){
        typeMessage.image = [UIImage imageNamed:@"icon_warning"];
    }
    typeMessage.tag = TYPE_IMAGE_TAG;
    textLabel.text = [@"    " stringByAppendingString:message.text];
    view.tag = CELL_VIEW_TAG;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
