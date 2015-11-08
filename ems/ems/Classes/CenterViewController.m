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
    sender.selected = !sender.selected;
    [self updateStarButton];
    [self beginSatr:sender.selected];
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
    self.view1.hidden = !bo;
    self.view2.hidden = bo;
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
