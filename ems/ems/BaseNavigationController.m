//
//  WViewController.m
//  ems
//
//  Created by 刘向宏 on 15/8/3.
//  Copyright (c) 2015年 刘向宏. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(1, 1), NO, 0.0);
    UIImage *blank = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //[self.navigationBar setBackgroundImage:blank forBarMetrics:UIBarMetricsCompact];
    self.navigationBar.shadowImage = blank;
    [self.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    self.navigationBar.barStyle = UIBarStyleBlack;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"123" message:@"12345" preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction *a = [UIAlertAction actionWithTitle:@"1" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
//        ;
//    }];
//    [ac addAction:a];
//    UIAlertAction *b = [UIAlertAction actionWithTitle:@"2" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//        ;
//    }];
//    [ac addAction:b];
//    UIAlertAction *c = [UIAlertAction actionWithTitle:@"3" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
//        ;
//    }];
//    [ac addAction:c];
//    [self presentViewController:ac animated:YES completion:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
