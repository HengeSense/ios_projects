//
//  PortalView.m
//  SmartHome
//
//  Created by Zhao yang on 12/2/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "PortalView.h"
#import "SceneEditViewController.h"
#import "UnitSelectionDrawerView.h"
#import "UnitViewController.h"

#import "ScenePlan.h"
#import "ScenePlanDevice.h"

@implementation PortalView {
    SMButton *btnSceneBack;
    SMButton *btnSceneOut;
    SMButton *btnSceneGetUp;
    SMButton *btnSceneSleep;
    
    UIImageView *imgNetworkState;
    UIButton *btnShowNotification;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)initDefaults {
    [super initDefaults];
    
    [self.topbar.rightButton setBackgroundImage:[UIImage imageNamed:@"btn_drawer_unit"] forState:UIControlStateNormal];
    [self.topbar.rightButton setBackgroundImage:[UIImage imageNamed:@"btn_drawer_unit"] forState:UIControlStateHighlighted];
    
    [self.topbar.rightButton addTarget:self action:@selector(showUnitSelectionDrawerView:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)initUI {
    [super initUI];
    
    UIButton *btnShowUnitController = [[UIButton alloc] initWithFrame:CGRectMake(180, 93, 22, 23)];
    [btnShowUnitController setBackgroundImage:[UIImage imageNamed:@"device_count"] forState:UIControlStateNormal];
    [btnShowUnitController setBackgroundImage:[UIImage imageNamed:@"device_count"] forState:UIControlStateHighlighted];
    [btnShowUnitController setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnShowUnitController addTarget:self action:@selector(showUnitController:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnShowUnitController];
    
    btnShowNotification = [[UIButton alloc] initWithFrame:CGRectMake(230, 95, 25, 20)];
    [btnShowNotification setBackgroundImage:[UIImage imageNamed:@"icon_message"] forState:UIControlStateNormal];
    [btnShowNotification setBackgroundImage:[UIImage imageNamed:@"icon_message"] forState:UIControlStateHighlighted];
    [btnShowNotification setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self addSubview:btnShowNotification];
    
    imgNetworkState = [[UIImageView alloc] initWithFrame:CGRectMake(280, 93, 24, 21)];
    imgNetworkState.image = [UIImage imageNamed:@"red"];
    [self addSubview:imgNetworkState];
    
    btnSceneBack = [[SMButton alloc] initWithFrame:CGRectMake(45, 140, 86, 86)];
    btnSceneBack.identifier = SCENE_MODE_BACK;
    [btnSceneBack setBackgroundImage:[UIImage imageNamed:@"btn_home"] forState:UIControlStateNormal];
    [btnSceneBack setBackgroundImage:[UIImage imageNamed:@"btn_home_unselected"] forState:UIControlStateHighlighted];
    btnSceneBack.longPressDelegate = self;
    [btnSceneBack addTarget:self action:@selector(btnScenePressed:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *imgBack = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_back"]];
    imgBack.center = CGPointMake(btnSceneBack.center.x, 250);
    [self addSubview:imgBack];
    
    btnSceneOut = [[SMButton alloc] initWithFrame:CGRectMake(199, 140, 86, 86)];
    btnSceneOut.identifier = SCENE_MODE_OUT;
    [btnSceneOut setBackgroundImage:[UIImage imageNamed:@"btn_out"] forState:UIControlStateNormal];
    [btnSceneOut setBackgroundImage:[UIImage imageNamed:@"btn_out_unselected"] forState:UIControlStateHighlighted];
    btnSceneOut.longPressDelegate = self;
    [btnSceneOut addTarget:self action:@selector(btnScenePressed:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *imgOut = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_out"]];
    imgOut.center = CGPointMake(btnSceneOut.center.x, 250);
    [self addSubview:imgOut];
    
    btnSceneGetUp = [[SMButton alloc] initWithFrame:CGRectMake(45, 300, 86, 86)];
    btnSceneGetUp.identifier = SCENE_MODE_GET_UP;
    [btnSceneGetUp setBackgroundImage:[UIImage imageNamed:@"btn_get_up"] forState:UIControlStateNormal];
    [btnSceneGetUp setBackgroundImage:[UIImage imageNamed:@"btn_get_up_unselected"] forState:UIControlStateHighlighted];
    btnSceneGetUp.longPressDelegate = self;
    [btnSceneGetUp addTarget:self action:@selector(btnScenePressed:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *imgGetUp = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_get_up"]];
    imgGetUp.center = CGPointMake(btnSceneGetUp.center.x, 410);
    [self addSubview:imgGetUp];
    
    btnSceneSleep = [[SMButton alloc] initWithFrame:CGRectMake(199, 300, 86, 86)];
    btnSceneSleep.identifier = SCENE_MODE_SLEEP;
    [btnSceneSleep setBackgroundImage:[UIImage imageNamed:@"btn_sleep"] forState:UIControlStateNormal];
    [btnSceneSleep setBackgroundImage:[UIImage imageNamed:@"btn_sleep_unselected"] forState:UIControlStateHighlighted];
    btnSceneSleep.longPressDelegate = self;
    [btnSceneSleep addTarget:self action:@selector(btnScenePressed:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *imgSleep = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_sleep"]];
    imgSleep.center = CGPointMake(btnSceneSleep.center.x, 410);
    [self addSubview:imgSleep];
 
    [self addSubview:btnSceneBack];
    [self addSubview:btnSceneOut];
    [self addSubview:btnSceneGetUp];
    [self addSubview:btnSceneSleep];
}

- (void)setUp {
}

- (void)notifyViewUpdate {
    if(self.ownerController != nil) {
        self.ownerController.rightViewEnable = YES;
    }
}

- (void)destory {
}

#pragma mark -
#pragma mark Events for button

- (void)showUnitSelectionDrawerView:(id)sender {
    if(self.ownerController != nil) {
        [self.ownerController showRightView];
    }
}

- (void)showUnitController:(id)sender {
    UnitViewController *controller = [[UnitViewController alloc] init];
    [self.ownerController.navigationController pushViewController:controller animated:YES];
}

- (void)btnScenePressed:(SMButton *)button {
    if(button == nil) return;
    self.topbar.titleLabel.text = [SMShared current].memory.currentUnit.name;
}

- (void)smButtonLongPressed:(SMButton *)button {
    if(button == nil) return;
    SceneEditViewController *controller = [[SceneEditViewController alloc] init];
    controller.sceneModeIdentifier = button.identifier;
    controller.unit = [SMShared current].memory.currentUnit;
    controller.title = NSLocalizedString(@"scene_edit", @"");
    [self.ownerController presentModalViewController:controller animated:YES];
}

@end
