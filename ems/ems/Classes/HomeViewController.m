//
//  HomeViewController.m
//  ems
//
//  Created by 刘向宏 on 15/9/8.
//  Copyright (c) 2015年 刘向宏. All rights reserved.
//

#import "HomeViewController.h"
#import "IIViewDeckController.h"

@interface HomeViewController ()
@property (nonatomic ,strong) IIViewDeckController *containerController;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
    UIViewController *centerController = [storyboard instantiateViewControllerWithIdentifier:@"CenterViewController"];
    UIViewController *leftController = (UINavigationController *)[storyboard instantiateViewControllerWithIdentifier:@"LeftViewController"];
    UIViewController *rightController = (UINavigationController *)[storyboard instantiateViewControllerWithIdentifier:@"RightViewController"];
    self.containerController = [[IIViewDeckController alloc] initWithCenterViewController:centerController leftViewController:leftController rightViewController:rightController];
    self.containerController.rightSize = 100;
    self.containerController.leftSize = 100;
    self.containerController.view.frame = self.view.bounds;
    self.containerController.shadowEnabled = NO;
    self.containerController.theNavigationController = self.navigationController;
    [self.view addSubview:self.containerController.view];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [super viewWillAppear:animated];
    self.containerController.view.frame = self.view.bounds;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
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
