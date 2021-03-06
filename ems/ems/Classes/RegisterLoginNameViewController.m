//
//  RegisterAdressViewController.m
//  ems
//
//  Created by 刘向宏 on 15/9/7.
//  Copyright (c) 2015年 刘向宏. All rights reserved.
//

#import "RegisterLoginNameViewController.h"
#import "EMSAPI.h"
#import <MBProgressHUD.h>
#import "UserManager.h"
#import "IHKeyboardAvoiding.h"

@interface RegisterLoginNameViewController ()
@property (nonatomic,weak) IBOutlet UIButton *nextButton;
@property (nonatomic,weak) IBOutlet UITextField *loginNameTextField;
@property (nonatomic,weak) IBOutlet UITextField *passworedTextField;
@property (nonatomic,weak) IBOutlet UITextField *repassworedTextField;
@property (nonatomic,weak) IBOutlet UITextField *codeTextField;
@property (nonatomic,weak) IBOutlet UITextField *nickNameTextField;
@property (nonatomic,weak) IBOutlet UIButton *codeButton;
@property (nonatomic,weak) IBOutlet UIView *contanstView;
@property (nonatomic,weak) IBOutlet TopView *topView;
@end

@implementation RegisterLoginNameViewController
{
    NSTimer *countDownTimer;
    long timeCount;
    
    NSString *code;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.nextButton.layer.cornerRadius = 7;
//    self.nextButton.layer.borderWidth = 2;
//    self.nextButton.layer.borderColor = [[UIColor whiteColor] CGColor];
//    self.nextButton.layer.masksToBounds = YES;
//    [self.nextButton setBackgroundImage:[UIImage colorImage:[UIColor colorWithRed:0xb5/255.0  green:0xb5/255.0 blue:0xb5/255.0 alpha:1.0f]] forState:UIControlStateHighlighted];
//    [self setBackImage];
    [IHKeyboardAvoiding setAvoidingView:self.contanstView];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    tapGestureRecognizer.cancelsTouchesInView = YES;
    [self.view addGestureRecognizer:tapGestureRecognizer];
    self.topView.title = @"注册";
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.loginNameView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(7, 7)];
//    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
//    maskLayer.frame = self.loginNameView.bounds;
//    maskLayer.path = maskPath.CGPath;
//    self.loginNameView.layer.mask = maskLayer;
//    
//    UIBezierPath *maskPath2 = [UIBezierPath bezierPathWithRoundedRect:self.passworedView.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(7, 7)];
//    CAShapeLayer *maskLayer2 = [[CAShapeLayer alloc] init];
//    maskLayer2.frame = self.passworedView.bounds;
//    maskLayer2.path = maskPath2.CGPath;
//    self.passworedView.layer.mask = maskLayer2;
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
            [self.codeButton setTitle:[NSString stringWithFormat:@"%ld秒后重发", timeCount] forState:UIControlStateDisabled];
            countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
        }
        
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)countDown
{
    timeCount --;
    if (timeCount > 0) {
        [self.codeButton setTitle:[NSString stringWithFormat:@"%ld秒后重发", timeCount] forState:UIControlStateDisabled];
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
    [self.nickNameTextField resignFirstResponder];
    [self.repassworedTextField resignFirstResponder];
    [self.codeTextField resignFirstResponder];
}

-(IBAction)backButtonClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

//-(IBAction)loginButtonClicked:(id)sender
//{
//    [self.navigationController popToRootViewControllerAnimated:YES];
//}
//
//- (IBAction)loginTypeClick:(UISegmentedControl *)sender {
//    NSInteger index = type = sender.selectedSegmentIndex;
//    [self.loginNameTextField resignFirstResponder];
//    self.loginNameTextField.placeholder = index?@"请输入邮箱":@"请输入手机号码";
//    self.loginNameTextField.keyboardType = index?UIKeyboardTypeEmailAddress:UIKeyboardTypePhonePad;
//}

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
    [EMSAPI GetAuthCodeWithParameters:dicParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
            [self.codeButton setTitle:[NSString stringWithFormat:@"%ld秒后重发", timeCount] forState:UIControlStateDisabled];
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
    BOOL test = NO;
    if(test)
    {
        [self performSegueWithIdentifier:@"nextIdentifier" sender:nil];
        return;
    }
    NSString *usertype = [self checkLoginName];
    if (!usertype) {
        return;
    }
    if ([self.codeTextField.text length]<1) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
        hud.dimBackground = YES;
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabelText = @"请输入验证码";
        [hud hide:YES afterDelay:1.5f];
        return;
    }
    if (![self.codeTextField.text isEqualToString:code]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
        hud.dimBackground = YES;
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabelText = @"验证码错误";
        [hud hide:YES afterDelay:1.5f];
        return;
    }
    if ([self.nickNameTextField.text length]<1) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
        hud.dimBackground = YES;
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabelText = @"请输入昵称";
        [hud hide:YES afterDelay:1.5f];
        return;
    }
    if ([self.passworedTextField.text length]<6) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
        hud.dimBackground = YES;
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabelText = @"密码长度至少6位";
        [hud hide:YES afterDelay:1.5f];
        return;
    }
    if (![self.passworedTextField.text isEqualToString:self.repassworedTextField.text]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
        hud.dimBackground = YES;
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabelText = @"两次密码不一致";
        [hud hide:YES afterDelay:1.5f];
        return;
    }
    if (![UserManager sharedManager].registerModel) {
        [UserManager sharedManager].registerModel = [[RegisterModel alloc] init];
    }
    [UserManager sharedManager].registerModel.loginname = self.loginNameTextField.text;
    [UserManager sharedManager].registerModel.password = self.passworedTextField.text;
    [UserManager sharedManager].registerModel.usertype = usertype;
    [UserManager sharedManager].registerModel.random = self.codeTextField.text;
    [UserManager sharedManager].registerModel.nickname = self.nickNameTextField.text;
    [self performSegueWithIdentifier:@"nextIdentifier" sender:nil];
}

-(NSString *)checkLoginName
{
    if ([self.loginNameTextField.text checkTel]) {
        
        return @"1";
    }
    if ([self.loginNameTextField.text isValidateEmail]) {
        return @"2";
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
    hud.dimBackground = YES;
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabelText = @"请输入正确的邮箱/手机号码";
    [hud hide:YES afterDelay:1.5f];
    return nil;
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
