//
//  AirConditionViewController.m
//  SmartHome
//
//  Created by Zhao yang on 8/5/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "AirConditionViewController.h"
#import "RadioButton.h"
#import <QuartzCore/QuartzCore.h>

#define RADIO_MARGIN 60
#define LABEL_MARGIN_TOP 20
#define RADIO_CENTER 10
#define CELL_HEIGHT 50
#define COLD_BASE_CODE 141
#define HOT_BASE_CODE 152
#define POWER_SWITCH_CODE 138

@interface AirConditionViewController ()

@end

@implementation AirConditionViewController{
    UIButton *closeBtn;
    UITableView *temperatureTable;
    NSIndexPath *curIndex;
    
}
@synthesize device = _device;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(id) initWithDevice:(Device *) device{
    self = [super init];
    if (self) {
        _device = device;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) initUI{
    [super initUI];
    
    if (temperatureTable == nil) {
        temperatureTable = [[UITableView alloc] initWithFrame:CGRectMake(0, self.topbar.frame.size.height+40+30, self.view.frame.size.width,self.view.frame.size.height-self.topbar.frame.size.height-70) style:UITableViewStylePlain];
        temperatureTable.dataSource = self;
        temperatureTable.delegate = self;
        temperatureTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        temperatureTable.backgroundColor = [UIColor clearColor];
        temperatureTable.showsVerticalScrollIndicator = NO;
        temperatureTable.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        [self.view addSubview:temperatureTable];
    }
    if (closeBtn == nil) {
        closeBtn =[[UIButton alloc] initWithFrame:CGRectMake(0, temperatureTable.frame.origin.y-78/2-10, 75/2, 78/2)];
        closeBtn.center = CGPointMake(self.view.center.x, closeBtn.center.y);
        [closeBtn setBackgroundImage:[UIImage imageNamed:@"btn_rc_power.png"] forState:UIControlStateNormal];
        [closeBtn setBackgroundImage:[UIImage imageNamed:@"btn_rc_power.png"] forState:UIControlStateHighlighted];
        [closeBtn setBackgroundImage:[UIImage imageNamed:@"btn_rc_power.png"] forState:UIControlStateSelected];
        [closeBtn addTarget:self action:@selector(closeBtnPressed) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:closeBtn];
    }
}

-(void) closeBtnPressed{
    [self executeCommandWithCode:POWER_SWITCH_CODE];
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *temperatureCell = nil;
    static NSString *cellIdentifier = @"temperatureCellIdentifier";
    temperatureCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(temperatureCell == nil) {
        temperatureCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        temperatureCell.backgroundColor = [UIColor clearColor];
    }
    NSString *type;
    if (indexPath.section == 0) {
        type = NSLocalizedString(@"heating", @"");
        temperatureCell.textLabel.text = [NSString stringWithFormat:@"%@     %i℃",type,indexPath.row+21];
    }else{
        type = NSLocalizedString(@"cryogen", @"");
        temperatureCell.textLabel.text = [NSString stringWithFormat:@"%@     %i℃",type,indexPath.row+21];
    }
    temperatureCell.textLabel.font = [UIFont systemFontOfSize:16];
    temperatureCell.textLabel.textColor = [UIColor colorWithHexString:@"696970"];
    temperatureCell.selectionStyle = UITableViewCellSelectionStyleNone;
//    if(indexPath.row != 0) {
        UIImageView *seperatorLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"line_cell_notification"]];
        seperatorLine.frame = CGRectMake(0,1, 320, 1);
        [temperatureCell addSubview:seperatorLine];
//    }
    return  temperatureCell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header = nil;
    if(section == 0) {
        header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 640/2, 47/2)];
        UIImageView *headerImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_hot.png"]];
        headerImg.frame = CGRectMake(0, 0, 640/2, 47/2);
        [header addSubview:headerImg];
    } else if(section == 1){
        header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 640/2, 47/2)];
        header.backgroundColor = [UIColor clearColor];
        UIImageView *headerImg = nil;
        headerImg =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_cold.png"]];
        headerImg.frame = CGRectMake(0, 0, 640/2, 47/2);
        [header addSubview:headerImg];
        return header;
    }
    return header;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    curIndex = indexPath;
    NSInteger commandCode = curIndex.section?HOT_BASE_CODE+curIndex.row:COLD_BASE_CODE+curIndex.row;
    [self executeCommandWithCode:commandCode];
    UITableViewCell *curCell = [tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.section == 0) {
        curCell.backgroundColor = [UIColor colorWithHexString:@"aa5923"];
    }else{
        curCell.backgroundColor = [UIColor colorWithHexString:@"2a6b97"];
    }
    curCell.textLabel.textColor = [UIColor whiteColor];
    [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(selectDelay) userInfo:nil repeats:NO];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  CELL_HEIGHT;
}
-(void) executeCommandWithCode:(NSInteger) commandCode{
    DeviceCommandUpdateDevice *updateDevice = (DeviceCommandUpdateDevice *)[CommandFactory commandForType:CommandTypeUpdateDevice];
    updateDevice.masterDeviceCode = self.device.zone.unit.identifier;
    [updateDevice addCommandString:[self.device commandStringForRemote:commandCode]];
    [[SMShared current].deliveryService executeDeviceCommand:updateDevice];
}
- (void)selectDelay {
    UITableViewCell *curCell = [temperatureTable cellForRowAtIndexPath:curIndex];
    curCell.textLabel.textColor = [UIColor colorWithHexString:@"696970"];
    curCell.backgroundColor = [UIColor clearColor];
}
@end
