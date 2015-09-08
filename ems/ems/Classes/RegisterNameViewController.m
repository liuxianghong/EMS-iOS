//
//  RegisterNameViewController.m
//  ems
//
//  Created by 刘向宏 on 15/9/2.
//  Copyright (c) 2015年 刘向宏. All rights reserved.
//

#import "RegisterNameViewController.h"
#import <IHKeyboardAvoiding.h>
#import "UserManager.h"
#import <MBProgressHUD.h>

@interface RegisterNameViewController ()<UITextFieldDelegate>
@property (nonatomic,weak) IBOutlet UIButton *nextButton;
@property (nonatomic,weak) IBOutlet UITextField *nameTextField;
@end

@implementation RegisterNameViewController

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
    
    if (IS_IPHONE_5 || IS_IPHONE_4_OR_LESS) {
        [IHKeyboardAvoiding setAvoidingView:self.view withTriggerView:self.nameTextField];
    }
}

-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [self.nameTextField resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(IBAction)backButtonClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)nameButtonClicked:(id)sender
{
    [self.nameTextField becomeFirstResponder];
}

-(IBAction)nextClicked:(id)sender
{
    if ([self.nameTextField.text length]==0) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
        hud.dimBackground = YES;
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabelText = @"请输入您的名字";
        [hud hide:YES afterDelay:1.5f];
        return;
    }
    if (![UserManager sharedManager].registerModel) {
        [UserManager sharedManager].registerModel = [[RegisterModel alloc] init];
    }
    [UserManager sharedManager].registerModel.nickname = self.nameTextField.text;
    [self performSegueWithIdentifier:@"nextIdentifier" sender:nil];
}

#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    CGSize size = [toBeString calculateSize:CGSizeMake(FLT_MAX, textField.height) font:textField.font];
    if (size.width > self.view.width - 100) {
        return NO;
    }
    if ((size.width)>(100-18)) {
        self.jk.constant = size.width+18;
        [self.view updateConstraintsIfNeeded];
        [self.view layoutIfNeeded];
    }
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
