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
#import "AlertViewController.h"
#import "PublishViewController.h"
#import "BleMessageViewController.h"
#import "CmodelView.h"
#import "ModelScrollView.h"

@interface CenterViewController ()<BTSmartSensorDelegate,DateScrollViewDelegate,AlertViewControllerDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
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

@property (nonatomic,weak) IBOutlet UILabel *label2top;
@property (nonatomic,weak) IBOutlet UILabel *label2cent;
@property (nonatomic,weak) IBOutlet UIButton *btnShare;

@property (nonatomic,weak) IBOutlet DateScrollView *scrollViewDate;
@property (nonatomic,weak) IBOutlet TimeScrollView *scrollViewTime;

@property (nonatomic,weak) IBOutlet UIButton *btnLess;
@property (nonatomic,weak) IBOutlet UIButton *btnAdd;

@property (nonatomic,weak) IBOutlet UIImageView *bgImageView;
@property (nonatomic,weak) IBOutlet UIImageView *bgRectImageView;
@property (nonatomic,weak) IBOutlet UIView *bgView;

@property (nonatomic,weak) IBOutlet ModelScrollView *modelScrollView;
@end

@implementation CenterViewController
{
    NSArray *array;
    NSInteger selecttag;
    
    RectView *rectViewSmall;
    
    BOOL first;
    BOOL share;
    
    NSMutableDictionary *dataDic;
    
    NSTimer *countDownTimer;
    long timeCount;
    
    BOOL connected;
    
    NSArray *powerArray;
    NSArray *modelArray;
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
    array = @[@[@"瘦身",[UIColor blueColor],@(0x80)],@[@"按摩",[UIColor yellowColor],@(0x81)],@[@"塑形",[UIColor redColor],@(0x82)]];
    powerArray = @[@10,@13,@16,@18,@20,@22,@24,@26,@28,@30,@31];
    modelArray = @[@[@7,@8],@[@1,@1],@[@9,@10]];
    selecttag = 1;
    [self updateButton];
    [self updateStarButton];
    
    self.viewcolor1.layer.cornerRadius = 4;
    self.viewcolor1.layer.masksToBounds = YES;
    
    self.viewcolor2.layer.cornerRadius = 4;
    self.viewcolor2.layer.masksToBounds = YES;
    
    rectViewSmall.power = 1;
    
    connected = NO;
    first = YES;
    dataDic = [[NSMutableDictionary alloc]init];
    
    share = NO;
    self.btnShare.hidden = YES;
    
    [self.modelScrollView.buttonDO addTarget:self action:@selector(buttonstarclick:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.modelScrollView doLayout];
    NSString *bgNmae = [[NSUserDefaults standardUserDefaults] objectForKey:@"viewBG"];
    if ([bgNmae isEqualToString:@"bg_activity-1.png"]) {
        self.bgImageView.image = [UIImage imageNamed:@"bg_activity-1.png"];
        self.bgRectImageView.image = [UIImage imageNamed:@"bg-1.png"];
        self.bgView.backgroundColor = [UIColor colorWithRed:98/255.0 green:200/255.0 blue:251/255.0 alpha:1.0f];
        [self.modelScrollView.buttonDO setBackgroundImage:[UIImage imageNamed:@"ic_play_normal-1.png"] forState:UIControlStateNormal];
    }
    else
    {
        self.bgImageView.image = [UIImage imageNamed:@"bg_activity.png"];
        self.bgRectImageView.image = [UIImage imageNamed:@"bg.png"];
        self.bgView.backgroundColor = [UIColor colorWithRed:231/255.0 green:141/255.0 blue:133/255.0 alpha:1.0f];
        [self.modelScrollView.buttonDO setBackgroundImage:[UIImage imageNamed:@"ic_play_normal.png"] forState:UIControlStateNormal];
    }
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
                NSArray *arrays = responseObject[@"data"];
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
                for (NSDictionary *sportDic in arrays) {
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

-(IBAction)rightButtonclick:(id)sender
{
    [self.viewDeckController toggleRightViewAnimated:YES];
}

-(IBAction)buttontopclick:(id)sender
{
    if (self.modelScrollView.buttonDO.selected) {
        return;
        //[self beginSatr:YES];
    }
    selecttag--;
    [self updateButton];
    
}

-(IBAction)buttonbottomclick:(id)sender
{
    if (self.modelScrollView.buttonDO.selected) {
        return;
        //[self beginSatr:YES];
    }
    selecttag++;
    [self updateButton];
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
    self.btnAdd.hidden = !self.modelScrollView.buttonDO.selected;
    self.btnLess.hidden = !self.modelScrollView.buttonDO.selected;
    rectViewSmall.hidden = !self.modelScrollView.buttonDO.selected;
    //self.labelcentleft.hidden = self.buttondo.selected;
    //self.labelcentright.hidden = self.buttondo.selected;
}

-(IBAction)buttonstarclick:(UIButton *)sender
{
    if(!sender.selected)
    {
        if (!sensor.activePeripheral || !connected) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
            hud.detailsLabelText = @"设备没有连接，请检查设备是否已开启或已被其它手机连接";
            hud.mode = MBProgressHUDModeText;
            [hud hide:YES afterDelay:2.0f];
            return;
        }
        timeCount = 0;
        countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
    }
    else
    {
        if (countDownTimer) {
            [countDownTimer invalidate];
            countDownTimer = nil;
        }
        
        NSInteger pwerT = [powerArray[rectViewSmall.power-1] intValue];
        NSInteger modelT = [self.modelScrollView getModel];
        NSInteger modelTT = [modelArray[modelT][0] intValue];
        NSInteger modelTTT = [modelArray[modelT][1] intValue];
        double caloriess = timeCount*modelTT*pwerT*pwerT/modelTTT/500*0.239;
        self.view1.hidden = YES;
        self.view2.hidden = NO;
        self.label2top.text = [NSString stringWithFormat:@"共使用%ldmin",timeCount/60];
        self.label2cent.text = [NSString stringWithFormat:@"消耗%.2f大卡",caloriess];
        share = YES;
        self.btnShare.hidden = NO;
        
        if (timeCount<1) {
        }
        else
        {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
            
            NSDictionary *dic = @{
                                  @"userid" : [[NSUserDefaults standardUserDefaults] objectForKey:@"id"],
                                  @"calorie" :@(caloriess),
                                  @"mode" : @(modelT),
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
        
        
    }
    sender.selected = !sender.selected;
    self.modelScrollView.scrollEnabled = !sender.selected;
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

-(IBAction)shareClick:(id)sender
{
    if (share) {
        self.view1.hidden = NO;
        self.view2.hidden = YES;
        self.btnShare.hidden = YES;
        share = NO;
    }
}

-(IBAction)shareButtonClick:(id)sender
{
    [self didClick:1 withTag:0];
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

#pragma mark - AlertViewControllerDelegate
-(void)didClick:(NSInteger)index withTag:(NSInteger)tag
{
    if (index==1) {
        UIGraphicsBeginImageContext(self.view.size);
        [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        UIImage *viewImage2 = [self getSubImage:CGRectMake(0, self.farherView.superview.top, self.view.width, self.scrollViewTime.superview.top) image:viewImage];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Other" bundle:nil];
        PublishViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"PublishViewController"];
        vc.image = viewImage2;
        vc.titleText = self.label2top.text;
        vc.messageText = self.label2cent.text;
        [self.viewDeckController.theNavigationController pushViewController:vc animated:YES];
    }
}


-(UIImage*)getSubImage:(CGRect)rect image:(UIImage *)image
{
    CGImageRef subImageRef = CGImageCreateWithImageInRect(image.CGImage, rect);
    CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
    
    UIGraphicsBeginImageContext(smallBounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, smallBounds, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();
    
    return smallImage;
}

//

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
    connected = YES;
}

- (void) setDisconnect
{
    connected = NO;
}


-(void)didSelectDate:(NSDate *)date isToday:(BOOL)bo
{
    NSLog(@"%@",date);
    share = NO;
    self.view1.hidden = !bo;
    self.view2.hidden = bo;
    self.btnShare.hidden = YES;
    if (!bo) {
        NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
        [formatter2 setDateFormat: @"MM/dd"];
        NSString *week = [formatter2 stringFromDate:date];
        NSDictionary *dic = dataDic[week];
        if (dic) {
            NSInteger time = [[dic objectForKey:@"time"] integerValue];
            double calorie = [[dic objectForKey:@"calorie"] doubleValue];
            self.label2top.text = [NSString stringWithFormat:@"共使用%ldmin",time/60];
            if(calorie != 0)
                self.label2cent.text = [NSString stringWithFormat:@"消耗%.2f大卡",calorie];
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

-(void)didUpdateState:(CBCentralManagerState)state
{
    if (state == CBCentralManagerStatePoweredOff) {
        //bleMessage
        //[self performSegueWithIdentifier:@"bleMessage" sender:@0];
    }
    else if (state == CBCentralManagerStateUnauthorized)
    {
        //[self performSegueWithIdentifier:@"bleMessage" sender:@2];
    }
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"sharealertvc"]){
        AlertViewController *vc = segue.destinationViewController;
        vc.delegate = self;
    }
    else if([segue.identifier isEqualToString:@"bleMessage"]){
        BleMessageViewController *vc = segue.destinationViewController;
        vc.str = [sender boolValue] ? @"请打开手机蓝牙进行连接" : @"请授权允许ems使用蓝牙";
    }
}


@end
