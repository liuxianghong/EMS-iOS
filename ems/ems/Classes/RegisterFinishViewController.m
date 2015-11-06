//
//  RegisterFinishViewController.m
//  ems
//
//  Created by 刘向宏 on 15/9/7.
//  Copyright (c) 2015年 刘向宏. All rights reserved.
//

#import "RegisterFinishViewController.h"
#import "EMSAPI.h"
#import <MBProgressHUD.h>
#import "UserManager.h"
#import "IHKeyboardAvoiding.h"

@interface RegisterFinishViewController ()<UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate>
@property (nonatomic,weak) IBOutlet UIButton *nextButton;
@property (nonatomic,weak) IBOutlet UIView *contanstView;
@property (nonatomic,weak) IBOutlet TopView *topView;

@property (nonatomic,weak) IBOutlet UITextField *sexField;
@property (nonatomic,weak) IBOutlet UITextField *wightField;
@property (nonatomic,weak) IBOutlet UITextField *heightField;
@property (nonatomic,weak) IBOutlet UITextField *birthDayField;
@end

@implementation RegisterFinishViewController
{
    UIPickerView *sexPickView;
    UIPickerView *wightPickView;
    UIPickerView *heightPickView;
    UIDatePicker *birthDayPickView;
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
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    tapGestureRecognizer.cancelsTouchesInView = YES;
    [self.view addGestureRecognizer:tapGestureRecognizer];
    self.topView.title = @"注册";
    [IHKeyboardAvoiding setAvoidingView:self.contanstView];
    
    
    
    sexPickView = [[UIPickerView alloc]init];
    //sexPickView.backgroundColor = [UIColor whiteColor];
    sexPickView.delegate = self;
    sexPickView.dataSource = self;
    self.sexField.inputView = sexPickView;
    self.sexField.inputAccessoryView = [self creactinputAccessoryView:0];
    [sexPickView selectRow:5000 inComponent:0 animated:NO];
    
    wightPickView = [[UIPickerView alloc]init];
    //wightPickView.backgroundColor = [UIColor whiteColor];
    wightPickView.delegate = self;
    wightPickView.dataSource = self;
    self.wightField.inputView = wightPickView;
    self.wightField.inputAccessoryView = [self creactinputAccessoryView:1];
    [wightPickView selectRow:(5000-70) inComponent:0 animated:NO];
    
    heightPickView = [[UIPickerView alloc]init];
    //heightPickView.backgroundColor = [UIColor whiteColor];
    heightPickView.delegate = self;
    heightPickView.dataSource = self;
    self.heightField.inputView = heightPickView;
    self.heightField.inputAccessoryView = [self creactinputAccessoryView:2];
    [heightPickView selectRow:(5000-130) inComponent:0 animated:NO];
    
    birthDayPickView = [[UIDatePicker alloc]init];
    //birthDayPickView.backgroundColor = [UIColor whiteColor];
    self.birthDayField.inputView = birthDayPickView;
    self.birthDayField.inputAccessoryView = [self creactinputAccessoryView:3];
    birthDayPickView.maximumDate = [NSDate date];
    [birthDayPickView setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_Hans_CN"]];
    birthDayPickView.datePickerMode = UIDatePickerModeDate;
}

-(UIView *)creactinputAccessoryView:(NSInteger)tag{
    UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
    topView.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem * cancelButton = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancelChoice:)];
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(doneChoice:)];
    NSArray * buttonsArray = [NSArray arrayWithObjects:cancelButton,btnSpace,doneButton,nil];
    doneButton.tag = cancelButton.tag = tag;
    [topView setItems:buttonsArray];
    [self doneChoice:doneButton];
    return topView;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
//    UIBezierPath *maskPath2 = [UIBezierPath bezierPathWithRoundedRect:self.passworedView.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(7, 7)];
//    CAShapeLayer *maskLayer2 = [[CAShapeLayer alloc] init];
//    maskLayer2.frame = self.passworedView.bounds;
//    maskLayer2.path = maskPath2.CGPath;
//    self.passworedView.layer.mask = maskLayer2;
}

-(void)keyboardHide:(id)sender
{
    [self.sexField resignFirstResponder];
    [self.wightField resignFirstResponder];
    [self.heightField resignFirstResponder];
    [self.birthDayField resignFirstResponder];
}

-(IBAction)backButtonClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)sexButtonClicked:(id)sender
{
    [self.sexField becomeFirstResponder];
}

-(IBAction)wightButtonClicked:(id)sender
{
    [self.wightField becomeFirstResponder];
}

-(IBAction)heightButtonClicked:(id)sender
{
    [self.heightField becomeFirstResponder];
}

-(void)cancelChoice:(UIBarButtonItem *)sender
{
    [self keyboardHide:nil];
}

-(void)doneChoice:(UIBarButtonItem *)sender
{
    [self keyboardHide:nil];
    switch (sender.tag) {
        case 0:
        {
            [UserManager sharedManager].registerModel.sex = [sexPickView selectedRowInComponent:0]%2?@"1":@"2";
            self.sexField.text = [sexPickView selectedRowInComponent:0]%2?@"男":@"女";
        }
            break;
        case 1:
        {
            self.wightField.text = [NSString stringWithFormat:@"%ldcm",[wightPickView selectedRowInComponent:0]%350+20];
            [UserManager sharedManager].registerModel.weight = [NSString stringWithFormat:@"%ld",[wightPickView selectedRowInComponent:0]%350+20];
        }
            break;
        case 2:
        {
            self.heightField.text = [NSString stringWithFormat:@"%ldcm",[heightPickView selectedRowInComponent:0]%250+50];
            [UserManager sharedManager].registerModel.height = [NSString stringWithFormat:@"%ld",[heightPickView selectedRowInComponent:0]%250+50];
        }
            break;
        case 3:
        {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat: @"yyyy-MM-dd"];
            NSString *destDateString = [dateFormatter stringFromDate:birthDayPickView.date];
            [UserManager sharedManager].registerModel.birthDay = destDateString;
            self.birthDayField.text = destDateString;
        }
            break;
            
        default:
            break;
    }
}
//-(IBAction)seeButtonClicked:(id)sender
//{
//    self.passworedTextField.secureTextEntry = !self.passworedTextField.secureTextEntry;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)nextClicked:(id)sender
{
    [self finished];
}

-(void)finished
{
    RegisterModel *model = [UserManager sharedManager].registerModel;
    NSDictionary *dic = @{
                          @"loginname" : model.loginname,
                          @"password" : model.password,
                          @"nickname" : model.nickname,
                          @"sex" : model.sex,
                          @"height" : model.height,
                          @"weight" : model.weight,
                          @"longitude" : model.longitude?model.longitude:@"",
                          @"latitude" : model.latitude?model.latitude:@"",
                          @"address" : model.address?model.address:@"",
                          @"usertype" : model.usertype,
                          @"random" : model.random
                          };
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
    hud.dimBackground = YES;
    hud.detailsLabelText = @"注册中";
    [EMSAPI UserRegisterWithParameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        if ([[responseObject[@"state"] safeString] integerValue]==0) {
            hud.detailsLabelText = @"注册成功";
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        else if ([[responseObject[@"state"] safeString] integerValue]==1) {
            hud.detailsLabelText = @"该用户名已经被注册";
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

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
//    if ([pickerView isEqual:sexPickView]) {
//        return 10000;
//    }
//    else if ([pickerView isEqual:wightPickView])
//    {
//        return 10000;
//    }
//    else if ([pickerView isEqual:heightPickView])
//    {
//        return 10000;
//    }
    return 10000;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if ([pickerView isEqual:sexPickView]) {
        return row%2?@"男":@"女";
    }
    else if ([pickerView isEqual:wightPickView])
    {
        return [NSString stringWithFormat:@"%ldkg",row%350+20];
    }
    else if ([pickerView isEqual:heightPickView])
    {
        return [NSString stringWithFormat:@"%ldcm",row%250+50];;
    }
    return nil;
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
