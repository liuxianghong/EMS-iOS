//
//  WelcomeHelpViewController.m
//  ems
//
//  Created by 刘向宏 on 15/11/4.
//  Copyright © 2015年 刘向宏. All rights reserved.
//

#import "WelcomeHelpViewController.h"

@interface WelcomeHelpViewController ()<UIScrollViewDelegate>
@property (nonatomic,weak) IBOutlet UIPageControl *pageControl;
@property (nonatomic,weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic,weak) IBOutlet UILabel *label;
@end

@implementation WelcomeHelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)inClick:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSLog(@"%f  %f",scrollView.contentOffset.x,scrollView.contentSize.width);
    NSInteger tag = scrollView.contentOffset.x/(scrollView.contentSize.width/4)+0.5;
    self.pageControl.currentPage = tag;
    switch (tag) {
        case 0:
        {
            self.label.text = @"在商场...";
        }
            break;
        case 1:
        {
            self.label.text = @"在公司...";
        }
            break;
        case 2:
        {
            self.label.text = @"在机场...";
        }
            break;
        case 3:
        {
            self.label.text = @"在家中...";
        }
            break;
            
        default:
            break;
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
