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

@interface CenterViewController ()<BTSmartSensorDelegate>
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
    array = @[@[@"瘦身",[UIColor blueColor]],@[@"放松",[UIColor yellowColor]],@[@"塑形",[UIColor redColor]]];
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
}

-(IBAction)buttonbottomclick:(id)sender
{
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
}

-(IBAction)lessClick:(id)sender
{
    if (rectViewSmall.power==1) {
        return;
    }
    rectViewSmall.power = rectViewSmall.power-1;
}

-(IBAction)addClick:(id)sender
{
    if (rectViewSmall.power==11) {
        return;
    }
    rectViewSmall.power = rectViewSmall.power+1;
}

-(IBAction)moreClick:(id)sender
{
    [self.viewDeckController openLeftViewAnimated:YES];
}
#pragma mark - HMSoftSensorDelegate

-(void) peripheralFound:(CBPeripheral *)peripheral
{
    [peripheralViewControllerArray addObject:peripheral];
//    if (sensor.activePeripheral && sensor.activePeripheral != controller.peripheral) {
//        [sensor disconnect:sensor.activePeripheral];
//    }
    sensor.activePeripheral = peripheral;
    [sensor connect:sensor.activePeripheral];
    [sensor stopScan];
}

- (void) serialGATTCharValueUpdated: (NSString *)UUID value: (NSData *)data
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
