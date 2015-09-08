//
//  RegisterSexViewController.m
//  ems
//
//  Created by 刘向宏 on 15/9/2.
//  Copyright (c) 2015年 刘向宏. All rights reserved.
//

#import "RegisterSexViewController.h"
#import <MBProgressHUD.h>
#import "UserManager.h"

@interface RegisterSexViewController ()
@property (nonatomic,weak) IBOutlet UIButton *nextButton;

@property (nonatomic,weak) IBOutlet UIButton *womanButton;
@property (nonatomic,weak) IBOutlet UIButton *manButton;
@property (nonatomic,weak) IBOutlet UILabel *womanLabel;
@property (nonatomic,weak) IBOutlet UILabel *manLabel;
@end

@implementation RegisterSexViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.nextButton.layer.cornerRadius = 7;
    self.nextButton.layer.borderWidth = 2;
    self.nextButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.nextButton.layer.masksToBounds = YES;
    [self.nextButton setBackgroundImage:[UIImage colorImage:[UIColor colorWithRed:0xb5/255.0  green:0xb5/255.0 blue:0xb5/255.0 alpha:1.0f]] forState:UIControlStateHighlighted];
    [self setBackImage];
    
    self.manButton.enabled = YES;
    self.womanButton.enabled = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)backButtonClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)womanButtonClicked:(id)sender
{
    //self.womanButton.selected = YES;
    self.manButton.enabled = YES;
    self.womanButton.enabled = NO;
}

-(IBAction)manButtonClicked:(id)sender
{
    self.womanButton.enabled = YES;
    self.manButton.enabled = NO;
}

-(IBAction)nextClicked:(id)sender
{
    if (![UserManager sharedManager].registerModel) {
        [UserManager sharedManager].registerModel = [[RegisterModel alloc] init];
    }
    [UserManager sharedManager].registerModel.sex = self.womanButton.enabled?@"1":@"2";
    [self performSegueWithIdentifier:@"nextIdentifier" sender:nil];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
