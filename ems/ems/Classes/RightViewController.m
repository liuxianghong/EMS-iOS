//
//  RightViewController.m
//  ems
//
//  Created by 刘向宏 on 15/11/7.
//  Copyright © 2015年 刘向宏. All rights reserved.
//

#import "RightViewController.h"
#import "IIViewDeckController.h"

@interface RightViewController ()

@end

@implementation RightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)backClick:(id)sender
{
    [self.viewDeckController closeRightViewAnimated:YES];
}

-(IBAction)buttonClick:(UIButton *)sender
{
    [self.viewDeckController.theNavigationController performSegueWithIdentifier:@"detailSee" sender:nil];
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
