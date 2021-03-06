//
//  ForgetPWDoneViewController.m
//  ems
//
//  Created by 刘向宏 on 15/9/7.
//  Copyright (c) 2015年 刘向宏. All rights reserved.
//

#import "ForgetPWDoneViewController.h"
#import "EMSAPI.h"
#import <MBProgressHUD.h>
#import "UserManager.h"

@interface ForgetPWDoneViewController ()
@property (nonatomic,weak) IBOutlet UIButton *nextButton;
@property (nonatomic,weak) IBOutlet UIView *passworedView;
@property (nonatomic,weak) IBOutlet UITextField *passworedTextField;
@end

@implementation ForgetPWDoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.nextButton.layer.cornerRadius = 7;
    self.nextButton.layer.borderWidth = 2;
    self.nextButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.nextButton.layer.masksToBounds = YES;
    [self.nextButton setBackgroundImage:[UIImage colorImage:[UIColor colorWithRed:0xb5/255.0  green:0xb5/255.0 blue:0xb5/255.0 alpha:1.0f]] forState:UIControlStateHighlighted];
    [self setBackImage];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    tapGestureRecognizer.cancelsTouchesInView = YES;
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    UIBezierPath *maskPath2 = [UIBezierPath bezierPathWithRoundedRect:self.passworedView.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(7, 7)];
    CAShapeLayer *maskLayer2 = [[CAShapeLayer alloc] init];
    maskLayer2.frame = self.passworedView.bounds;
    maskLayer2.path = maskPath2.CGPath;
    self.passworedView.layer.mask = maskLayer2;
}

-(void)keyboardHide:(id)sender
{
    [self.passworedTextField resignFirstResponder];
}

-(IBAction)backButtonClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)seeButtonClicked:(id)sender
{
    self.passworedTextField.secureTextEntry = !self.passworedTextField.secureTextEntry;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)nextClicked:(id)sender
{
    if ([self.passworedTextField.text length]<1) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
        hud.dimBackground = YES;
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabelText = @"请输入密码";
        [hud hide:YES afterDelay:1.5f];
        return;
    }
    if (![UserManager sharedManager].forgetPWModel) {
        [UserManager sharedManager].forgetPWModel = [[ForgetPWModel alloc] init];
    }
    [UserManager sharedManager].forgetPWModel.password = self.passworedTextField.text;
    [self finished];
}

-(void)finished
{
    ForgetPWModel *model = [UserManager sharedManager].forgetPWModel;
    NSDictionary *dic = @{
                          @"loginname" : model.loginname,
                          @"password" : model.password,
                          @"random" : model.random
                          };
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
    hud.dimBackground = YES;
    hud.detailsLabelText = @"设置中";
    [EMSAPI ResetPassWordWithParameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        if ([[responseObject[@"state"] safeString] integerValue]==0) {
            hud.detailsLabelText = @"设置成功";
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        else if ([[responseObject[@"state"] safeString] integerValue]==1) {
            hud.detailsLabelText = @"用户不存在";
        }
        else if ([[responseObject[@"state"] safeString] integerValue]==4) {
            hud.detailsLabelText = @"验证码有误";
        }
        else
        {
            hud.detailsLabelText = @"服务器内部错误";
        }
        hud.mode = MBProgressHUDModeText;
        [hud hide:YES afterDelay:1.5f];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        hud.detailsLabelText = error.domain;
        hud.mode = MBProgressHUDModeText;
        [hud hide:YES afterDelay:1.5f];
    }];
}

#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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
