//
//  ForgetPWCodeViewController.m
//  ems
//
//  Created by 刘向宏 on 15/9/7.
//  Copyright (c) 2015年 刘向宏. All rights reserved.
//

#import "ForgetPWCodeViewController.h"
#import "EMSAPI.h"
#import <MBProgressHUD.h>
#import "UserManager.h"

@interface ForgetPWCodeViewController ()
@property (nonatomic,weak) IBOutlet UIButton *nextButton;
@property (nonatomic,weak) IBOutlet UIView *loginNameView;
@property (nonatomic,weak) IBOutlet UIView *passworedView;
@property (nonatomic,weak) IBOutlet UITextField *loginNameTextField;
@property (nonatomic,weak) IBOutlet UITextField *passworedTextField;
@property (nonatomic,weak) IBOutlet UIButton *codeButton;
@end

@implementation ForgetPWCodeViewController
{
    NSTimer *countDownTimer;
    long timeCount;
    
    NSString *code;
    
    NSInteger type;
}

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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    if (countDownTimer) {
        [countDownTimer invalidate];
        countDownTimer = nil;
    }
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSNumber *recordTime = [[NSUserDefaults standardUserDefaults]objectForKey:@"LastTimeGetCapthaTime"];
    if (recordTime) {
        long nowTime = [[NSDate date]timeIntervalSince1970];
        long interval = (nowTime - [recordTime longValue]);
        if (interval >= 60) {
            [self.codeButton setEnabled:YES];
        }
        else{
            [self.codeButton setEnabled:NO];
            [self.codeButton.titleLabel setFont:[UIFont systemFontOfSize:11.0f]];
            timeCount = 60-interval;
            [self.codeButton setTitle:[NSString stringWithFormat:@"%ld秒后重新发送", timeCount] forState:UIControlStateDisabled];
            countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
        }
        
    }
}

- (void)countDown
{
    timeCount --;
    if (timeCount > 0) {
        [self.codeButton setTitle:[NSString stringWithFormat:@"%ld秒后重新发送", timeCount] forState:UIControlStateDisabled];
    }
    else{
        [self.codeButton setEnabled:YES];
        [self.codeButton.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [countDownTimer invalidate];
        countDownTimer = nil;
    }
}

-(void)keyboardHide:(id)sender
{
    [self.loginNameTextField resignFirstResponder];
    [self.passworedTextField resignFirstResponder];
}

-(IBAction)backButtonClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)sendClick:(id)sender
{
    if (![self checkLoginName]) {
        return;
    }
    [self.codeButton setTitle:@"发送中" forState:UIControlStateNormal];
    NSDictionary *dicParameters = @{
                                    @"loginname" : self.loginNameTextField.text,
                                    @"usertype" : @1
                                    };
    [EMSAPI ForgetPasswordWithParameters:dicParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        NSDictionary *dic = (NSDictionary *)responseObject;
        if(![[dic[@"state"] safeString] integerValue])
        {
            code = [[dic[@"data"] firstObject][@"random"] safeString];
            NSLog(@"%@",code);
            long nowTime = [[NSDate date]timeIntervalSince1970];
            [[NSUserDefaults standardUserDefaults]setObject:@(nowTime) forKey:@"LastTimeGetCapthaTime"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            [self.codeButton setEnabled:NO];
            [self.codeButton.titleLabel setFont:[UIFont systemFontOfSize:11.0f]];
            timeCount = 60;
            [self.codeButton setTitle:[NSString stringWithFormat:@"%ld秒后重新发送", timeCount] forState:UIControlStateDisabled];
            countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
        }else
        {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
            hud.dimBackground = YES;
            hud.mode = MBProgressHUDModeText;
            if ([[dic[@"state"] safeString] integerValue]==1) {
                hud.detailsLabelText = @"该用户名已经被注册";
            }
            else
                hud.detailsLabelText = @"服务器内部错误";
            [hud hide:YES afterDelay:1.5f];
            [self.codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
        hud.dimBackground = YES;
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabelText = error.domain;
        [hud hide:YES afterDelay:1.5f];
        [self.codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    }];
    
}

-(IBAction)nextClicked:(id)sender
{
    
    
    if (![self checkLoginName]) {
        return;
    }
    if ([self.passworedTextField.text length]<1) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
        hud.dimBackground = YES;
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabelText = @"请输入验证码";
        [hud hide:YES afterDelay:1.5f];
        return;
    }
    if (![UserManager sharedManager].forgetPWModel) {
        [UserManager sharedManager].forgetPWModel = [[ForgetPWModel alloc] init];
    }
    [UserManager sharedManager].forgetPWModel.loginname = self.loginNameTextField.text;
    [UserManager sharedManager].forgetPWModel.random = self.passworedTextField.text;
    //[UserManager sharedManager].registerModel.usertype = type?@"2":@"1";
    [self performSegueWithIdentifier:@"nextIdentifier" sender:nil];
}

-(BOOL)checkLoginName
{
    if (![self.loginNameTextField.text checkTel]) {
        if (![self.loginNameTextField.text isValidateEmail]) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
            hud.dimBackground = YES;
            hud.mode = MBProgressHUDModeText;
            hud.detailsLabelText = @"请输入正确的用户名";
            [hud hide:YES afterDelay:1.5f];
            return NO;
        }
    }
    return YES;
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
