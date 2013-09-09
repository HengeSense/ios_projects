//
//  MessageCell.m
//  SmartHome
//
//  Created by hadoop user account on 9/09/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "MessageCell.h"

@implementation MessageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}
-(void) initUIWithIdentifier:(NSString *) identifier{

    UIView  *view = [[UIView alloc] initWithFrame:self.contentView.frame];
    
    UIImageView *typeMessage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 50/2, 39/2)];
    if ([identifier isEqualToString:@"messageTypeNormal"]) {
        typeMessage.image = [UIImage imageNamed:@"icon_message.png"];
    }else if([identifier isEqualToString:@"messageTypeVerify"]){
        typeMessage.image = [UIImage imageNamed:@"icon_validation.png"];
    }else if([identifier isEqualToString:@"messageTypeWarning"]){
        typeMessage.image = [UIImage imageNamed:@"icon_warning"];
    }
    typeMessage.backgroundColor = [UIColor clearColor];
    typeMessage.tag = 1001;
    [view addSubview:typeMessage];
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 5, 200,MESSAGE_CELL_HEIGHT)];
    textLabel.tag = 1000;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
