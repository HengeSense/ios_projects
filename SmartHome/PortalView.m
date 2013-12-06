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
#import "ScenePlanFileManager.h"

@implementation PortalView {
    SMButton *btnSceneBack;
    SMButton *btnSceneOut;
    SMButton *btnSceneGetUp;
    SMButton *btnSceneSleep;
    
    UIImageView *imgNetworkState;
    UIButton *btnShowNotification;
    
    NSMutableDictionary *plans;
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
    plans = [NSMutableDictionary dictionary];
}

- (void)initUI {
    [super initUI];
    
    [self.topbar.rightButton setBackgroundImage:[UIImage imageNamed:@"btn_drawer_unit"] forState:UIControlStateNormal];
    [self.topbar.rightButton setBackgroundImage:[UIImage imageNamed:@"btn_drawer_unit"] forState:UIControlStateHighlighted];
    
    [self.topbar.rightButton addTarget:self action:@selector(showUnitSelectionDrawerView:) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat toMinusHeight = [UIDevice systemVersionIsMoreThanOrEuqal7] ? 0 : 20;
    
    btnShowNotification = [[UIButton alloc] initWithFrame:CGRectMake(180, 97 - toMinusHeight, 24, 21)];
    [btnShowNotification setBackgroundImage:[UIImage imageNamed:@"icon_message"] forState:UIControlStateNormal];
    [btnShowNotification setBackgroundImage:[UIImage imageNamed:@"icon_message"] forState:UIControlStateHighlighted];
    [btnShowNotification setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self addSubview:btnShowNotification];
    
    UIButton *btnShowUnitController = [[UIButton alloc] initWithFrame:CGRectMake(230, 95 - toMinusHeight, 25, 20)];
    [btnShowUnitController setBackgroundImage:[UIImage imageNamed:@"btn_unit_panel"] forState:UIControlStateNormal];
    [btnShowUnitController setBackgroundImage:[UIImage imageNamed:@"btn_unit_panel"] forState:UIControlStateHighlighted];
    [btnShowUnitController setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnShowUnitController addTarget:self action:@selector(showUnitController:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnShowUnitController];
    
    imgNetworkState = [[UIImageView alloc] initWithFrame:CGRectMake(280, 94 - toMinusHeight, 24, 21)];
    imgNetworkState.image = [UIImage imageNamed:@"red"];
    [self addSubview:imgNetworkState];
    
    btnSceneBack = [[SMButton alloc] initWithFrame:CGRectMake(45, 140 - toMinusHeight, 86, 86)];
    btnSceneBack.identifier = SCENE_MODE_BACK;
    [btnSceneBack setParameter:NSLocalizedString(@"scene_home", @"") forKey:@"name"];
//    [btnSceneBack setBackgroundImage:[UIImage imageNamed:@"btn_home"] forState:UIControlStateNormal];
//    [btnSceneBack setBackgroundImage:[UIImage imageNamed:@"btn_home_unselected"] forState:UIControlStateHighlighted];
    btnSceneBack.longPressDelegate = self;
    [btnSceneBack addTarget:self action:@selector(btnScenePressed:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *imgBack = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_back"]];
    imgBack.center = CGPointMake(btnSceneBack.center.x, 250 - toMinusHeight);
    [self addSubview:imgBack];
    
    btnSceneOut = [[SMButton alloc] initWithFrame:CGRectMake(199, 140 - toMinusHeight, 86, 86)];
    btnSceneOut.identifier = SCENE_MODE_OUT;
//    [btnSceneOut setBackgroundImage:[UIImage imageNamed:@"btn_out"] forState:UIControlStateNormal];
//    [btnSceneOut setBackgroundImage:[UIImage imageNamed:@"btn_out_unselected"] forState:UIControlStateHighlighted];
    [btnSceneOut setParameter:NSLocalizedString(@"scene_out", @"") forKey:@"name"];
    btnSceneOut.longPressDelegate = self;
    [btnSceneOut addTarget:self action:@selector(btnScenePressed:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *imgOut = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_out"]];
    imgOut.center = CGPointMake(btnSceneOut.center.x, 250 - toMinusHeight);
    [self addSubview:imgOut];
    
    btnSceneGetUp = [[SMButton alloc] initWithFrame:CGRectMake(45, 300 - toMinusHeight, 86, 86)];
    btnSceneGetUp.identifier = SCENE_MODE_GET_UP;
//    [btnSceneGetUp setBackgroundImage:[UIImage imageNamed:@"btn_get_up"] forState:UIControlStateNormal];
//    [btnSceneGetUp setBackgroundImage:[UIImage imageNamed:@"btn_get_up_unselected"] forState:UIControlStateHighlighted];
    [btnSceneGetUp setParameter:NSLocalizedString(@"scene_get_up", @"") forKey:@"name"];
    btnSceneGetUp.longPressDelegate = self;
    [btnSceneGetUp addTarget:self action:@selector(btnScenePressed:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *imgGetUp = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_get_up"]];
    imgGetUp.center = CGPointMake(btnSceneGetUp.center.x, 410 - toMinusHeight);
    [self addSubview:imgGetUp];
    
    btnSceneSleep = [[SMButton alloc] initWithFrame:CGRectMake(199, 300 - toMinusHeight, 86, 86)];
    btnSceneSleep.identifier = SCENE_MODE_SLEEP;
//    [btnSceneSleep setBackgroundImage:[UIImage imageNamed:@"btn_sleep"] forState:UIControlStateNormal];
//    [btnSceneSleep setBackgroundImage:[UIImage imageNamed:@"btn_sleep_unselected"] forState:UIControlStateHighlighted];
    [btnSceneSleep setParameter:NSLocalizedString(@"scene_sleep", @"") forKey:@"name"];
    btnSceneSleep.longPressDelegate = self;
    [btnSceneSleep addTarget:self action:@selector(btnScenePressed:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *imgSleep = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_sleep"]];
    imgSleep.center = CGPointMake(btnSceneSleep.center.x, 410 - toMinusHeight);
    [self addSubview:imgSleep];
 
    [self addSubview:btnSceneBack];
    [self addSubview:btnSceneOut];
    [self addSubview:btnSceneGetUp];
    [self addSubview:btnSceneSleep];
}

- (void)setUp {
    [[SMShared current].memory subscribeHandler:[DeviceCommandGetUnitsHandler class] for:self];
    [self updateScenePlanForCurrentUnit];
}

- (void)destory {
    [[SMShared current].memory unSubscribeHandler:[DeviceCommandGetUnitsHandler class] for:self];
    [plans removeAllObjects];
}

- (void)notifyViewUpdate {
    if(self.ownerController != nil) {
        self.ownerController.rightViewEnable = YES;
    }
    [self notifyUnitsWasUpdate];
}

- (void)notifyUnitsWasUpdate {
    @synchronized(self) {
        [self notifyMeCurrentUnitWasChanged];
        if(self.ownerController.rightView != nil && [self.ownerController.rightView isKindOfClass:[UnitSelectionDrawerView class]]) {
            UnitSelectionDrawerView *selectionView = (UnitSelectionDrawerView *)self.ownerController.rightView;
            [selectionView refresh];
        }
    }
}

- (void)notifyMeCurrentUnitWasChanged {
    [self updateStatusDisplay];
    [self updateScenePlanForCurrentUnit];
}

- (void)updateStatusDisplay {
    if([SMShared current].memory.currentUnit != nil) {
        self.topbar.titleLabel.text = [SMShared current].memory.currentUnit.name;
    }
}

#pragma mark -
#pragma mark Events for button

- (void)showUnitSelectionDrawerView:(id)sender {
    if(self.ownerController != nil) {
        [self.ownerController showRightView];
    }
}

- (void)showUnitController:(id)sender {
    @synchronized(self) {
        UnitViewController *controller = [[UnitViewController alloc] init];
        [self.ownerController.navigationController pushViewController:controller animated:YES];
    }
}

- (void)btnScenePressed:(SMButton *)button {
    if(button == nil) return;
    ScenePlan *plan = [plans objectForKey:button.identifier];
    if(plan != nil) {
        [plan execute];
    }
    self.topbar.titleLabel.text = [SMShared current].memory.currentUnit.name;
}

- (void)smButtonLongPressed:(SMButton *)button {
    if(button == nil) return;
    SceneEditViewController *controller = [[SceneEditViewController alloc] init];
    controller.scenePlan = [plans objectForKey:button.identifier];
    NSString *name = [button parameterForKey:@"name"];
    if([NSString isBlank:name]) {
        controller.title = NSLocalizedString(@"scene_edit", @"");
    } else {
        controller.title = [NSString stringWithFormat:@"%@:%@", NSLocalizedString(@"scene_edit", @""), name];
    }
    [self.ownerController presentModalViewController:controller animated:YES];
}

#pragma mark -
#pragma mark Getter and setters

- (void)updateScenePlanForCurrentUnit {
    Unit *currentUnit = [SMShared current].memory.currentUnit;
    [plans removeAllObjects];
    if(currentUnit == nil) return;
    [self updateScenePlanFor:currentUnit withSPlanId:SCENE_MODE_BACK];
    [self updateScenePlanFor:currentUnit withSPlanId:SCENE_MODE_GET_UP];
    [self updateScenePlanFor:currentUnit withSPlanId:SCENE_MODE_OUT];
    [self updateScenePlanFor:currentUnit withSPlanId:SCENE_MODE_SLEEP];
}

- (void)updateScenePlanFor:(Unit *)unit withSPlanId:(NSString *)planId {
    Unit *mergedUnit = [[Unit alloc] init];
    mergedUnit.identifier = unit.identifier;
    
    for(int i=0; i<unit.zones.count; i++) {
        Zone *zone = [unit.zones objectAtIndex:i];
        if(zone.devices.count > 0) {
            Zone *_zone = [[Zone alloc] init];
            _zone.name = zone.name;
            _zone.identifier = zone.identifier;
            _zone.unit = zone.unit;
            for(int j=0; j<zone.devices.count; j++) {
                Device *device = [zone.devices objectAtIndex:j];
                if(device.isSocket || device.isRemote || device.isLightOrInlight || device.isCurtainOrSccurtain) {
                    [_zone.devices addObject:device];
                }
            }
            [mergedUnit.zones addObject:_zone];
        }
    }
    ScenePlan *plan = [[ScenePlan alloc] initWithUnit:mergedUnit];
    plan.scenePlanIdentifier = planId;
    ScenePlanFileManager *manager = [ScenePlanFileManager fileManager];
    BOOL hasSet = [manager syncScenePlan:plan] != nil;
    [plans setObject:plan forKey:planId];
    
    // Refresh button image that scene plan is set or unset
    if([SCENE_MODE_BACK isEqualToString:planId]) {
        [btnSceneBack setBackgroundImage:[UIImage imageNamed:hasSet ? @"btn_home" : @"btn_home_unset"] forState:UIControlStateNormal];
    } else if([SCENE_MODE_GET_UP isEqualToString:planId]) {
        [btnSceneGetUp setBackgroundImage:[UIImage imageNamed:hasSet ? @"btn_get_up" :@"btn_get_up_unset"] forState:UIControlStateNormal];
    } else if([SCENE_MODE_OUT isEqualToString:planId]) {
        [btnSceneOut setBackgroundImage:[UIImage imageNamed:hasSet ? @"btn_out" : @"btn_out_unset"] forState:UIControlStateNormal];
    } else if([SCENE_MODE_SLEEP isEqualToString:planId]) {
        [btnSceneSleep setBackgroundImage:[UIImage imageNamed:hasSet ? @"btn_sleep" : @"btn_sleep_unset"] forState:UIControlStateNormal];
    }
}

@end
