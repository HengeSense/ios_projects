//
//  ModifyInfoViewController.m
//  SmartHome
//
//  Created by hadoop user account on 16/08/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "ModifyInfoViewController.h"
@interface ModifyInfoViewController ()

@end

@implementation ModifyInfoViewController{
    UITextField *input;
    UITextField *makesureInput;
}
@synthesize textDelegate;
@synthesize lastView;
@synthesize title;
@synthesize value;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (id) initWithKey:(NSString *)key forValue:(NSString *)v from:(NavViewController *)where{
    self = [super init];
    if(self){
        if (self.title == nil) {
            self.title = key;
        }
        if (self.value == nil) {
            self.value = v;
        }
        if (self.lastView == nil) {
            self.lastView = where;
        }
    }
    return  self;
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

- (void)initDefaults {

}
- (void)generateTopbar {
    self.topbar = [TopbarView topBarWithImage:[UIImage imageNamed:@"bg_topbar.png"] shadow:YES];
    
    self.topbar.leftButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 8, 101/2, 59/2)];
    [self.topbar.leftButton setBackgroundImage:[UIImage imageNamed:@"btn_done.png"] forState:UIControlStateNormal];
    [self.topbar.leftButton setBackgroundImage:[UIImage imageNamed:@"btn_done.png"] forState:UIControlStateSelected];
    [self.topbar.leftButton setTitle:NSLocalizedString(@"cancel", @"") forState:UIControlStateNormal];
    [self.topbar.leftButton setTitleColor:[UIColor lightTextColor] forState:UIControlStateNormal];
    self.topbar.leftButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.topbar.leftButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    [self.topbar addSubview:self.topbar.leftButton];
    
    self.topbar.rightButton = [[UIButton alloc] initWithFrame:CGRectMake(self.topbar.frame.size.width - 101/2 - 8, 8, 101/2, 59/2)];
    [self.topbar addSubview:self.topbar.rightButton];
    [self.topbar.rightButton setBackgroundImage:[UIImage imageNamed:@"btn_done.png"] forState:UIControlStateNormal];
    [self.topbar.rightButton setBackgroundImage:[UIImage imageNamed:@"btn_done.png"] forState:UIControlStateHighlighted];
    [self.topbar.rightButton setTitleColor:[UIColor lightTextColor] forState:UIControlStateNormal];
    [self.topbar.rightButton setTitleColor:[UIColor lightTextColor] forState:UIControlStateHighlighted];
    [self.topbar.rightButton setTitle:NSLocalizedString(@"done", @"") forState:UIControlStateNormal];
    self.topbar.rightButton.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [self.topbar.rightButton addTarget:self action:@selector(btnDownPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.topbar];
    self.topbar.titleLabel.text = NSLocalizedString(@"unit_binding_view.title", @"btn_done.png");
}

- (void)initUI {
    [super initUI];
    self.topbar.titleLabel.text = self.title;
    if (self.title == NSLocalizedString(@"modify.password", @"")) {
        UILabel *one = [[UILabel alloc]initWithFrame:CGRectMake(10, self.topbar.frame.size.height+10, 150, 20)];
        one.font = [UIFont systemFontOfSize:14];
        one.backgroundColor = [UIColor clearColor];
        one.textColor = [UIColor lightTextColor];
        one.text = NSLocalizedString(@"input.new.password", @"");
        [self.view addSubview:one];
        if (input == nil) {
            input = [SMTextField textFieldWithPoint:CGPointMake(5, one.frame.origin.y+one.frame.size.height+5)];
            [self.view addSubview:input];
        }
        input.secureTextEntry = YES;
        input.returnKeyType = UIReturnKeyNext;
        [self.view addSubview:input];
        
        UILabel *again = [[UILabel alloc] initWithFrame:CGRectMake(10, input.frame.origin.y+input.frame.size.height+10, 150, 20)];
        again.font = [UIFont systemFontOfSize:14];
        again.backgroundColor = [UIColor clearColor];
        again.textColor = [UIColor lightTextColor];
        again.text = NSLocalizedString(@"again.to.makesure", @"");
        [self.view addSubview:again];
        
        if (makesureInput == nil) {
            makesureInput = [SMTextField textFieldWithPoint:CGPointMake(5, again.frame.origin.y+again.frame.size.height+5)];
            makesureInput.delegate = self;
            makesureInput.secureTextEntry = YES;
            makesureInput.returnKeyType = UIReturnKeyDone;
            [self.view addSubview:makesureInput];
        }

        
    }else{
        if (input == nil) {
            input = [SMTextField textFieldWithPoint:CGPointMake(5, self.topbar.frame.size.height + 10)];
            input.text = self.value;
            input.delegate = self;
            [self.view addSubview:input];
        }
    
        input.returnKeyType = UIReturnKeyDone;
    }
    
}
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    if ([self.title isEqualToString:NSLocalizedString(@"modify.password", @"")]) {
        if (input.text !=nil&&makesureInput.text!=nil) {
            if ([input.text isEqualToString:makesureInput.text]) {
                [self.textDelegate textViewHasBeenSetting:input.text];
                [self dismissModalViewControllerAnimated:YES];
                return  YES;
            }else{
                [[AlertView currentAlertView] setMessage:NSLocalizedString(@"the.two.input.is.not.consistent", @"") forType:AlertViewTypeFailed];
                [[AlertView currentAlertView] alertAutoDisappear:YES lockView:self.view];
                return  NO;
            }

        }else{
            [[AlertView currentAlertView] setMessage:@"密码格式不正确" forType:AlertViewTypeFailed];
            [[AlertView currentAlertView] alertAutoDisappear:YES lockView:self.view];
            return  NO;
        }
    }else{
        if(self.textDelegate != nil && [self.textDelegate respondsToSelector:@selector(textViewHasBeenSetting:)]) {
            [self.textDelegate textViewHasBeenSetting:input.text];
        }
        [self dismissModalViewControllerAnimated:YES];
        return  YES;

    }
}
- (void)btnDownPressed:(id)sender {
    
    if ([self.title isEqualToString:NSLocalizedString(@"modify.password", @"")]) {
        if (input.text !=nil&&makesureInput.text!=nil) {
            if ([input.text isEqualToString:makesureInput.text]) {
                [self.textDelegate textViewHasBeenSetting:input.text];
                [self dismissModalViewControllerAnimated:YES];

            }else{
                [[AlertView currentAlertView] setMessage:NSLocalizedString(@"the.two.input.is.not.consistent", @"") forType:AlertViewTypeFailed];
                [[AlertView currentAlertView] alertAutoDisappear:YES lockView:self.view];

            }
            
        }else{
            [[AlertView currentAlertView] setMessage:@"密码格式不正确" forType:AlertViewTypeFailed];
            [[AlertView currentAlertView] alertAutoDisappear:YES lockView:self.view];

        }
    }else{
        if(self.textDelegate != nil && [self.textDelegate respondsToSelector:@selector(textViewHasBeenSetting:)]) {
            [self.textDelegate textViewHasBeenSetting:input.text];
        }
        [self dismissModalViewControllerAnimated:YES];

        
    }
}

-(void) cancel{
    [self dismissModalViewControllerAnimated:YES];
}
@end
