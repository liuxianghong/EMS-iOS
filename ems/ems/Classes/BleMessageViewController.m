//
//  BleMessageViewController.m
//  ems
//
//  Created by 刘向宏 on 15/12/7.
//  Copyright © 2015年 刘向宏. All rights reserved.
//

#import "BleMessageViewController.h"

@interface BleMessageViewController ()
@property (nonatomic,weak) IBOutlet UILabel *label;
@end

@implementation BleMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.label.text = self.str;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self dismissViewControllerAnimated:NO completion:nil];
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
