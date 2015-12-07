//
//  CourseViewController.m
//  ems
//
//  Created by 刘向宏 on 15/11/12.
//  Copyright © 2015年 刘向宏. All rights reserved.
//

#import "CourseViewController.h"
#import "CourseTotalView.h"
#import "CourseWeekMounthView.h"
#import <MBProgressHUD.h>
#import "EMSAPI.h"

@interface CourseViewController ()<UIScrollViewDelegate>
@property (nonatomic,weak) IBOutlet UIButton *buttonWeek;
@property (nonatomic,weak) IBOutlet UIButton *buttonTotal;
@property (nonatomic,weak) IBOutlet UIButton *buttonMouth;
@property (nonatomic,weak) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint;

@property (nonatomic,weak) IBOutlet CourseTotalView *totalView;
@property (nonatomic,weak) IBOutlet CourseWeekMounthView *weekView;
@property (nonatomic,weak) IBOutlet CourseWeekMounthView *monthView;
@end

@implementation CourseViewController
{
    MBProgressHUD *hud;
    BOOL first;
    
    NSMutableDictionary *weekDic;
    NSMutableDictionary *monthDic;
    NSMutableArray *weekArray;
    NSMutableArray *monthArray;
    
    NSInteger model1;
    NSInteger model2;
    NSInteger model3;
    
    double calorieWeek;
    double calorieMonth;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    first = YES;
    weekDic = [[NSMutableDictionary alloc]init];
    monthDic = [[NSMutableDictionary alloc]init];
    weekArray = [[NSMutableArray alloc]init];
    monthArray = [[NSMutableArray alloc]init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

-(IBAction)backClick:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)buttonClick:(UIButton*)sender
{
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.width*sender.tag, 0) animated:YES];
    self.buttonMouth.selected = NO;
    self.buttonTotal.selected = NO;
    self.buttonWeek.selected = NO;
    sender.selected = YES;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (first) {
        CGFloat offx = self.scrollView.contentOffset.x;
        CGFloat width = self.scrollView.width;
        CGFloat cwidth = self.view.width/4;
        self.constraint.constant = (offx - width)/(width)*cwidth;
        first = NO;
        for(int i =1 ;i<13;i++)
        {
            NSString *month = [NSString stringWithFormat:@"%02d",i];
            [monthDic setObject:@"0" forKey:month];
            [monthArray addObject:month];
        }
        NSArray *dataArray = [NSArray arrayWithObjects:monthArray,@[@"0"], nil ];
        self.monthView.DataView.dataArray = dataArray;
        
        NSDate *date = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
        [formatter setDateFormat: @"yyyy-MM-dd"];
        NSString *strendtime = [formatter stringFromDate:date];
        [formatter setDateFormat: @"MM/dd"];
        for (int i =6; i>=0; i--) {
            NSDate *weekDate = [date dateByAddingTimeInterval:(-3600*24*i)];
            NSString *weekString = [formatter stringFromDate:weekDate];
            [weekDic setValue:@"0" forKey:weekString];
            [weekArray addObject:weekString];
        }
        dataArray = [NSArray arrayWithObjects:weekArray,@[@"0"], nil ];
        self.weekView.DataView.dataArray = dataArray;
        NSDictionary *dic = @{
                              @"starttime" : @"2015-08-01",
                              @"endtime" : strendtime,
                              @"userid" : [[NSUserDefaults standardUserDefaults] objectForKey:@"id"]
                              };
        [formatter setDateFormat: @"yyyy"];
        NSString *yearTady = [formatter stringFromDate:date];
        [EMSAPI getSportWithParameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"%@",responseObject);
            if ([responseObject[@"state"] integerValue]==0) {
                NSArray *array = responseObject[@"data"];
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
                for (NSDictionary *sportDic in array) {
                    NSString *uploadtime = sportDic[@"uploadtime"];
                    NSDate *date = [formatter dateFromString:uploadtime];
                    NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
                    [formatter2 setDateFormat: @"yyyy"];
                    NSString *year = [formatter2 stringFromDate:date];
                    if ([year isEqualToString:yearTady]) {
                        [formatter2 setDateFormat: @"MM/dd"];
                        NSString *week = [formatter2 stringFromDate:date];
                        NSInteger time = [sportDic[@"time"] integerValue];
                        double calorie = [sportDic[@"calorie"] doubleValue];
                        if ([weekDic objectForKey:week]) {
                            NSInteger timeBefor = [[weekDic objectForKey:week] integerValue];
                            [weekDic setObject:[NSString stringWithFormat:@"%ld",(time+timeBefor)] forKey:week];
                            calorieWeek+=calorie;
                        }
                        [formatter2 setDateFormat: @"MM"];
                        NSString *month = [formatter2 stringFromDate:date];
                        if ([monthDic objectForKey:month]) {
                            NSInteger timeBefor = [[monthDic objectForKey:month] integerValue];
                            [monthDic setObject:[NSString stringWithFormat:@"%ld",(time+timeBefor)] forKey:month];
                            calorieMonth+=calorie;
                        }
                        
                        NSInteger mode = [sportDic[@"mode"] integerValue];
                        if (mode == 1) {
                            model1 += time;
                        }
                        else if (mode == 2)
                        {
                            model2 += time;
                        }
                        else
                        {
                            model3 += time;
                        }
                    }
                    
                    
                    
                }
                NSMutableArray *arrayData = [[NSMutableArray alloc] init];
                for (NSString *key in weekArray) {
                    [arrayData addObject:weekDic[key]];
                }
                NSArray *dataArray = [NSArray arrayWithObjects:weekArray,arrayData, nil ];
                self.weekView.DataView.dataArray = dataArray;
                [self.weekView.DataView showDate];
                self.weekView.calorie = calorieWeek;
                
                arrayData = [[NSMutableArray alloc] init];
                for (NSString *key in monthArray) {
                    [arrayData addObject:monthDic[key]];
                }
                dataArray = [NSArray arrayWithObjects:monthArray,arrayData, nil ];
                self.monthView.DataView.dataArray = dataArray;
                [self.monthView.DataView showDate];
                self.monthView.calorie = calorieMonth;
                
                self.totalView.array = @[@(model1),@(model2),@(model3)];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            ;
        }];
    }
}
#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offx = scrollView.contentOffset.x;
    CGFloat width = scrollView.width;
    CGFloat cwidth = self.view.width/4;
    self.constraint.constant = (offx - width)/(width)*cwidth;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat offx = scrollView.contentOffset.x;
    CGFloat width = scrollView.width;
    if (offx<width-1) {
        [self buttonClick:self.buttonWeek];
    }
    else if(offx>(width+1))
    {
        [self buttonClick:self.buttonMouth];
    }
    else
    {
        [self buttonClick:self.buttonTotal];
    }
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
