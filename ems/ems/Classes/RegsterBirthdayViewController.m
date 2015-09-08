//
//  RegsterBirthdayViewController.m
//  ems
//
//  Created by 刘向宏 on 15/9/7.
//  Copyright (c) 2015年 刘向宏. All rights reserved.
//

#import "RegsterBirthdayViewController.h"
#import <MBProgressHUD.h>
#import "UserManager.h"

@interface RegsterBirthdayViewController ()
@property (nonatomic,weak) IBOutlet UIButton *nextButton;

@property (nonatomic,weak) IBOutlet UIButton *yearButton;
@property (nonatomic,weak) IBOutlet UIButton *monthButton;
@property (nonatomic,weak) IBOutlet UIButton *dayButton;
@end

@implementation RegsterBirthdayViewController
{
    UIDatePicker *datePicker;
    UITextField *field;
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
    
    datePicker = [[UIDatePicker alloc]init];
    datePicker.datePickerMode = UIDatePickerModeDate;
    datePicker.maximumDate = [NSDate date];
    datePicker.backgroundColor = [UIColor whiteColor];
    datePicker.date = [NSDate dateWithTimeIntervalSince1970:0];
    //datePicker.hidden = YES;
    [datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged ];
    //[self.view addSubview:datePicker];
    //[self.view bringSubviewToFront:datePicker];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    tapGestureRecognizer.cancelsTouchesInView = YES;
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    field = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, 1, 1)];
    field.backgroundColor = [UIColor clearColor];
    field.textColor = [UIColor clearColor];
    field.inputView = datePicker;
    [self.view addSubview:field];
    
    [self dateChanged:datePicker];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)backButtonClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)dateButtonClicked:(id)sender
{
    [field becomeFirstResponder];
//    datePicker.hidden = !datePicker.hidden;
//    self.nextButton.hidden = !datePicker.hidden;
//    datePicker.bottom = self.view.bottom;
}

-(IBAction)nextClicked:(id)sender
{
    if (![UserManager sharedManager].registerModel) {
        [UserManager sharedManager].registerModel = [[RegisterModel alloc] init];
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
    NSString *destDateString = [dateFormatter stringFromDate:datePicker.date];
    [UserManager sharedManager].registerModel.birthDay = destDateString;
    //[self performSegueWithIdentifier:@"nextIdentifier" sender:nil];
}

-(void)keyboardHide:(id)sender
{
    [field resignFirstResponder];
//    datePicker.hidden = YES;
//    self.nextButton.hidden = NO;
}

-(void)dateChanged:(id)sender{
    UIDatePicker* control = (UIDatePicker*)sender;
    NSDate* _date = control.date;
    /*添加你自己响应代码*/
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit |
    NSMonthCalendarUnit |
    NSDayCalendarUnit |
    NSWeekdayCalendarUnit |
    NSHourCalendarUnit |
    NSMinuteCalendarUnit |
    NSSecondCalendarUnit;
    comps = [calendar components:unitFlags fromDate:_date];
    NSInteger year=[comps year];
    NSInteger month = [comps month];
    NSInteger day = [comps day];
    [self.yearButton setTitle:[NSString stringWithFormat:@"%02ld",year%100] forState:UIControlStateNormal];
    [self.monthButton setTitle:[NSString stringWithFormat:@"%02ld",month] forState:UIControlStateNormal];
    [self.dayButton setTitle:[NSString stringWithFormat:@"%02ld",day] forState:UIControlStateNormal];
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
