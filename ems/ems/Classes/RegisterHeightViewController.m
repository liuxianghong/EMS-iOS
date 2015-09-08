//
//  RegisterHeightViewController.m
//  ems
//
//  Created by 刘向宏 on 15/9/7.
//  Copyright (c) 2015年 刘向宏. All rights reserved.
//

#import "RegisterHeightViewController.h"
#import "ZHRulerView.h"
#import <MBProgressHUD.h>
#import "UserManager.h"

static CGFloat const rulerMultiple=10;
@interface RegisterHeightViewController ()<ZHRulerViewDelegate>
@property (nonatomic,weak) IBOutlet UIButton *nextButton;
@property(nonatomic,weak) IBOutlet ZHRulerView *rulerview;
@property(nonatomic,weak) IBOutlet UILabel *valueLable;
@end

@implementation RegisterHeightViewController
{
    CGFloat value;
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
    
    self.rulerview.layer.cornerRadius = 3;
    self.rulerview.layer.borderWidth = 1;
    self.rulerview.layer.borderColor = [[UIColor grayColor] CGColor];
    self.rulerview.layer.masksToBounds = YES;
    [self.rulerview setWithMixNuber:100 maxNuber:251 showType:rulerViewshowVerticalType rulerMultiple:rulerMultiple];
    value = self.rulerview.defaultVaule=150;
    _valueLable.text=[NSString stringWithFormat:@"%dkg",(int)150];
    self.rulerview.delegate=self;
    self.rulerview.backgroundColor = [UIColor colorWithRed:0xb5/255.0  green:0xb5/255.0 blue:0xb5/255.0 alpha:0.4f];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)backButtonClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)nextClicked:(id)sender
{
    if (![UserManager sharedManager].registerModel) {
        [UserManager sharedManager].registerModel = [[RegisterModel alloc] init];
    }
    [UserManager sharedManager].registerModel.height = [NSString stringWithFormat:@"%d",(int)value];
    //[self performSegueWithIdentifier:@"nextIdentifier" sender:nil];
}

#pragma mark rulerviewDelagete
-(void)getRulerValue:(CGFloat)rulerValue withScrollRulerView:(ZHRulerView *)rulerView{
    _valueLable.text=[NSString stringWithFormat:@"%dcm",(int)rulerValue];
    value = rulerValue;
    NSLog(@"rulerValue %f",rulerValue);
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
