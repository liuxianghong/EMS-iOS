//
//  LoginViewController.m
//  ems
//
//  Created by 刘向宏 on 15/9/2.
//  Copyright (c) 2015年 刘向宏. All rights reserved.
//

#import "LoginViewController.h"
#import <MBProgressHUD.h>
#import "EMSAPI.h"

@interface LoginViewController () <UITextFieldDelegate>
@property (nonatomic,weak) IBOutlet UIView *loginNameView;
@property (nonatomic,weak) IBOutlet UIView *passworedView;
@property (nonatomic,weak) IBOutlet UITextField *loginNameTextField;
@property (nonatomic,weak) IBOutlet UITextField *passworedTextField;
@property (nonatomic,weak) IBOutlet UIButton *loginButton;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.loginButton.layer.cornerRadius = 7;
    self.loginButton.layer.borderWidth = 2;
    self.loginButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.loginButton.layer.masksToBounds = YES;
    [self.loginButton setBackgroundImage:[UIImage colorImage:[UIColor colorWithRed:0xb5/255.0  green:0xb5/255.0 blue:0xb5/255.0 alpha:1.0f]] forState:UIControlStateHighlighted];
    [self setBackImage];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    tapGestureRecognizer.cancelsTouchesInView = YES;
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [self.loginNameTextField resignFirstResponder];
    [self.passworedTextField resignFirstResponder];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.loginNameView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(7, 7)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.loginNameView.bounds;
    maskLayer.path = maskPath.CGPath;
    self.loginNameView.layer.mask = maskLayer;
    
    UIBezierPath *maskPath2 = [UIBezierPath bezierPathWithRoundedRect:self.passworedView.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(7, 7)];
    CAShapeLayer *maskLayer2 = [[CAShapeLayer alloc] init];
    maskLayer2.frame = self.passworedView.bounds;
    maskLayer2.path = maskPath2.CGPath;
    self.passworedView.layer.mask = maskLayer2;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self keyboardHide:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)backCliced:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)loginCliced:(id)sender
{
    [self.loginNameTextField resignFirstResponder];
    [self.passworedTextField resignFirstResponder];
    NSString *loginName = self.loginNameTextField.text;
    NSString *password = self.passworedTextField.text;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
    hud.dimBackground = YES;
    
    if (![loginName checkTel]) {
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabelText = @"请输入正确的手机号码";
        [hud hide:YES afterDelay:1.5f];
        return;
    }
    if ([password length]<1) {
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabelText = @"请输入密码";
        [hud hide:YES afterDelay:1.5f];
        return;
    }
    hud.detailsLabelText = @"登陆中";
    //NSString *deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"];
    NSDictionary *dic = @{
                          @"loginname": loginName,
                          @"password": password//,
                          //@"deviceType" : @1,
                          //@"deviceToken" : deviceToken?deviceToken:@" "
                          };
    [EMSAPI UserLoginWithParameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        if(![[responseObject[@"state"] safeString] integerValue])
        {
            hud.mode = MBProgressHUDModeText;
            hud.detailsLabelText = @"登陆成功";
            [hud hide:YES];
            [EMSAPI saveUserImformatin:responseObject[@"data"]];
            [[NSUserDefaults standardUserDefaults]setObject:loginName forKey:@"loginloginName"];
            [[NSUserDefaults standardUserDefaults]setObject:password forKey:@"loginpassword"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        else if([responseObject[@"state"] integerValue]==4)
        {
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"提示";
            hud.detailsLabelText = @"密码错误，请重新输入";
            [hud hide:YES afterDelay:1.5f];
        }
        else if([responseObject[@"state"] integerValue]==1)
        {
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"提示";
            hud.detailsLabelText = @"用户名不存在";
            [hud hide:YES afterDelay:1.5f];
        }
//        else if([responseObject[@"state"] integerValue]==4)
//        {
//            hud.mode = MBProgressHUDModeText;
//            hud.labelText = @"提示";
//            hud.detailsLabelText = @"账户还没有审核，请收到审核通知后再登录";
//            [hud hide:YES afterDelay:1.5f];
//        }
        else
        {
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"提示";
            hud.detailsLabelText = @"服务器内部错误";
            [hud hide:YES afterDelay:1.5f];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabelText = error.domain;
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
