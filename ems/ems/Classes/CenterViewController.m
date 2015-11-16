//
//  CenterViewController.m
//  ems
//
//  Created by 刘向宏 on 15/9/8.
//  Copyright (c) 2015年 刘向宏. All rights reserved.
//

#import "CenterViewController.h"
#import "SerialGATT.h"
#import "RectView.h"
#import "IIViewDeckController.h"
#import "DateScrollView.h"
#import "TimeScrollView.h"
#import <MBProgressHUD.h>
#import "EMSAPI.h"

@interface CenterViewController ()<BTSmartSensorDelegate,DateScrollViewDelegate>
@property (strong, nonatomic) SerialGATT *sensor;
@property (nonatomic, retain) NSMutableArray *peripheralViewControllerArray;
@property (nonatomic,weak) IBOutlet UIView *viewcolor1;
@property (nonatomic,weak) IBOutlet UIView *viewcolor2;

@property (nonatomic,weak) IBOutlet UIView *farherView;
@property (nonatomic,weak) IBOutlet UIView *view1;
@property (nonatomic,weak) IBOutlet UIView *view2;
@property (nonatomic,weak) IBOutlet UIButton *buttontop;
@property (nonatomic,weak) IBOutlet UIButton *buttonbottom;
@property (nonatomic,weak) IBOutlet UILabel *labelcentleft;
@property (nonatomic,weak) IBOutlet UILabel *labelcentright;
@property (nonatomic,weak) IBOutlet UIButton *buttondo;

@property (nonatomic,weak) IBOutlet UILabel *label2top;
@property (nonatomic,weak) IBOutlet UILabel *label2cent;

@property (nonatomic,weak) IBOutlet DateScrollView *scrollViewDate;
@property (nonatomic,weak) IBOutlet TimeScrollView *scrollViewTime;

@property (nonatomic,weak) IBOutlet UIButton *btnLess;
@property (nonatomic,weak) IBOutlet UIButton *btnAdd;
@end

@implementation CenterViewController
{
    NSArray *array;
    NSInteger selecttag;
    
    RectView *rectViewSmall;
    
    BOOL first;
    
    NSMutableDictionary *dataDic;
    
    NSTimer *countDownTimer;
    long timeCount;
}
@synthesize sensor;
@synthesize peripheralViewControllerArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    rectViewSmall = [[RectView alloc]init];
    rectViewSmall.backgroundColor = [UIColor clearColor];
    [self.farherView addSubview:rectViewSmall];
    [self.farherView bringSubviewToFront:rectViewSmall];
    
    
    sensor = [[SerialGATT alloc] init];
    sensor.delegate = self;
    [sensor setup];
    
    
    printf("now we are searching device...\n");
    array = @[@[@"瘦身",[UIColor blueColor],@(0x80)],@[@"放松",[UIColor yellowColor],@(0x81)],@[@"塑形",[UIColor redColor],@(0x82)]];
    selecttag = 1;
    [self updateButton];
    [self updateStarButton];
    
    self.viewcolor1.layer.cornerRadius = 4;
    self.viewcolor1.layer.masksToBounds = YES;
    
    self.viewcolor2.layer.cornerRadius = 4;
    self.viewcolor2.layer.masksToBounds = YES;
    
    rectViewSmall.power = 1;
    
    first = YES;
    dataDic = [[NSMutableDictionary alloc]init];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (first&&[[NSUserDefaults standardUserDefaults] objectForKey:@"id"]) {
        first = NO;
        NSDate *date = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
        [formatter setDateFormat: @"yyyy-MM-dd"];
        NSDate *date2 = [date dateByAddingTimeInterval:(24*3600)*(maxDateView-6)];
        NSString *strendtime = [formatter stringFromDate:date];
        NSString *endtime = [formatter stringFromDate:date2];
        [formatter setDateFormat: @"MM/dd"];
        
        NSDictionary *dic = @{
                              @"starttime" : endtime,
                              @"endtime" : strendtime,
                              @"userid" : [[NSUserDefaults standardUserDefaults] objectForKey:@"id"]
                              };
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
                    [formatter2 setDateFormat: @"MM/dd"];
                    NSString *week = [formatter2 stringFromDate:date];
                    NSInteger time = [sportDic[@"time"] integerValue];
                    double calorie = [sportDic[@"calorie"] doubleValue];
                    NSMutableDictionary *dicweek = [dataDic objectForKey:week];
                    if (!dicweek) {
                        dicweek = [[NSMutableDictionary alloc]init];
                        [dataDic setObject:dicweek forKey:week];
                    }
                    
                    NSInteger timeBefor = [[dicweek objectForKey:@"time"] integerValue];
                    [dicweek setObject:[NSString stringWithFormat:@"%ld",(time+timeBefor)] forKey:@"time"];
                    double calorieWeek = [[dicweek objectForKey:@"calorie"] doubleValue];
                    [dicweek setObject:[NSString stringWithFormat:@"%f",(calorieWeek+calorie)] forKey:@"calorie"];
                    
                }
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            ;
        }];
    }
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    rectViewSmall.frame = CGRectInset(self.view1.frame, -6, -6);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)buttontopclick:(id)sender
{
    selecttag--;
    [self updateButton];
    if (self.buttondo.selected) {
        [self beginSatr:YES];
    }
}

-(IBAction)buttonbottomclick:(id)sender
{
    selecttag++;
    [self updateButton];
    if (self.buttondo.selected) {
        [self beginSatr:YES];
    }
}

-(void)updateButton
{
    if (selecttag==0) {
        selecttag = 3*100;
    }
    NSInteger tag = selecttag%3;
    self.labelcentleft.text = [array[tag][0] substringToIndex:1];
    self.labelcentright.text = [array[tag][0] substringFromIndex:1];
    [self.buttontop setTitle:array[(selecttag-1)%3][0] forState:UIControlStateNormal];
    [self.buttonbottom setTitle:array[(selecttag+1)%3][0] forState:UIControlStateNormal];
    self.viewcolor1.backgroundColor = array[(selecttag-1)%3][1];
    self.viewcolor2.backgroundColor = array[(selecttag+1)%3][1];
}

-(void)updateStarButton
{
    self.btnAdd.hidden = !self.buttondo.selected;
    self.btnLess.hidden = !self.buttondo.selected;
    rectViewSmall.hidden = !self.buttondo.selected;
    self.labelcentleft.hidden = self.buttondo.selected;
    self.labelcentright.hidden = self.buttondo.selected;
}

-(IBAction)buttonstarclick:(UIButton *)sender
{
    if(!sender.selected)
    {
        if (!sensor.activePeripheral) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
            hud.detailsLabelText = @"设备没有连接，请检查设备是否已开启或已被其它手机连接";
            hud.mode = MBProgressHUDModeText;
            [hud hide:YES afterDelay:2.0f];
            return;
        }
        timeCount = 0;
        countDownTimer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
    }
    else
    {
        if (countDownTimer) {
            [countDownTimer invalidate];
            countDownTimer = nil;
        }
        if (timeCount<1) {
            return;
        }
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
        NSDictionary *dic = @{
                               @"userid" : [[NSUserDefaults standardUserDefaults] objectForKey:@"id"],
                               @"calorie" : @(timeCount*rectViewSmall.power),
                               @"mode" : @(selecttag%3+1),
                               @"strength" : [NSString stringWithFormat:@"%ld",rectViewSmall.power],
                               @"uploadtime" : [formatter stringFromDate:[NSDate date]],
                               @"time" : @(timeCount)
                              };
        [EMSAPI insertSportWithParameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"%@",responseObject);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            ;
        }];
    }
    sender.selected = !sender.selected;
    [self updateStarButton];
    [self beginSatr:sender.selected];
}

-(void)countDown
{
    timeCount ++;
}

-(IBAction)lessClick:(id)sender
{
    if (rectViewSmall.power==1) {
        return;
    }
    rectViewSmall.power = rectViewSmall.power-1;
    [self beginSatr:YES];
}

-(IBAction)addClick:(id)sender
{
    if (rectViewSmall.power==11) {
        return;
    }
    rectViewSmall.power = rectViewSmall.power+1;
    [self beginSatr:YES];
}

-(IBAction)moreClick:(id)sender
{
    [self.viewDeckController openLeftViewAnimated:YES];
}

-(IBAction)momentsClick:(id)sender{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Other" bundle:nil];
    UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"MomentsNewVC"];//MomentsVC
    [self.viewDeckController.theNavigationController pushViewController:vc animated:YES];
}

-(IBAction)historyClick:(id)sender{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Course" bundle:nil];
    UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"CourseVC"];//MomentsVC
    [self.viewDeckController.theNavigationController pushViewController:vc animated:YES];
}
//send data
-(void)beginSatr:(BOOL)bo
{
    char byete[10] = {0x55,0xAA,0x02,0};
    int length = 5;
    if (bo) {
        NSInteger tag = selecttag%3;
        byete[3] = [array[tag][2] integerValue];
        byete[4] = rectViewSmall.power;
    }
    else
    {
        length = 4;
        byete[2] = 0x01;
        byete[3] = 0x83;
    }
    NSData *data = [NSData dataWithBytes:byete length:length];
    [self sendMsgToArduino:data];
}


- (void)sendMsgToArduino:(NSData *)data {
    if(data.length > 20)
    {
        int i = 0;
        while ((i + 1) * 20 <= data.length) {
            NSData *dataSend = [data subdataWithRange:NSMakeRange(i * 20, 20)];
            [sensor write:sensor.activePeripheral data:dataSend];
            i++;
        }
        i = data.length % 20;
        if(i > 0)
        {
            NSData *dataSend = [data subdataWithRange:NSMakeRange(data.length - i, i)];
            [sensor write:sensor.activePeripheral data:dataSend];
        }
    }
    else
    {
        [sensor write:sensor.activePeripheral data:data];
    }
}
#pragma mark - HMSoftSensorDelegate

-(void) peripheralFound:(CBPeripheral *)peripheral
{
//    [peripheralViewControllerArray addObject:peripheral];
//    if (sensor.activePeripheral && sensor.activePeripheral != controller.peripheral) {
//        [sensor disconnect:sensor.activePeripheral];
//    }
    sensor.activePeripheral = peripheral;
    [sensor connect:sensor.activePeripheral];
    [sensor stopScan];
}

- (void)serialGATTCharValueUpdated: (NSString *)UUID value: (NSData *)data
{
    NSLog(@"%@",data.description);
    //NSData *dataSend = [data subdataWithRange:NSMakeRange(i * 20, 20)];
    //[sensor write:sensor.activePeripheral data:dataSend];
}

- (void) setConnect
{
}

- (void) setDisconnect
{
}


-(void)didSelectDate:(NSDate *)date isToday:(BOOL)bo
{
    NSLog(@"%@",date);
    self.view1.hidden = !bo;
    self.view2.hidden = bo;
    if (!bo) {
        NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
        [formatter2 setDateFormat: @"MM/dd"];
        NSString *week = [formatter2 stringFromDate:date];
        NSDictionary *dic = dataDic[week];
        if (dic) {
            NSInteger time = [[dic objectForKey:@"time"] integerValue];
            double calorie = [[dic objectForKey:@"calorie"] doubleValue];
            self.label2top.text = [NSString stringWithFormat:@"共使用%ldmin",time];
            if(calorie == 0)
                self.label2cent.text = [NSString stringWithFormat:@"消耗%f大卡",calorie];
            else
                self.label2cent.text = [NSString stringWithFormat:@"消耗0大卡"];
        }
        else
        {
            self.label2top.text = [NSString stringWithFormat:@"共使用0min"];
            self.label2cent.text = [NSString stringWithFormat:@"消耗0大卡"];
        }
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
