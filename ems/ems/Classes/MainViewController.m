//
//  MainViewController.m
//  ems
//
//  Created by 刘向宏 on 15/9/1.
//  Copyright (c) 2015年 刘向宏. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    NSString *str = [[NSUserDefaults standardUserDefaults]objectForKey:@"verson"];
    if (![str isEqualToString:@"1"]) {//
        [self performSegueWithIdentifier:@"wlcomeHelp" sender:nil];
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"verson"];
    }
    else
    {
        static BOOL isFirst = YES;
        if (isFirst) {
            [self performSegueWithIdentifier:@"Login" sender:nil];
        }
        isFirst = NO;
    }
    //    [super viewDidAppear:animated];
    //    if (![[NSUserDefaults standardUserDefaults]objectForKey:@"token"]) {
    //        [self performSegueWithIdentifier:@"LoginSegueIdentifier" sender:nil];
    //    }
    
    [super viewDidAppear:animated];
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
