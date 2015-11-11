//
//  PersonDetailTableViewController.m
//  ems
//
//  Created by 刘向宏 on 15/11/10.
//  Copyright © 2015年 刘向宏. All rights reserved.
//

#import "PersonDetailTableViewController.h"
#import "TopView.h"
#import <UIImageView+WebCache.h>
#import "EMSAPI.h"

@interface PersonDetailTableViewController ()

@property (nonatomic,weak) IBOutlet UIImageView *headImageView;

@property (nonatomic,weak) IBOutlet TopView *topView;
@property (nonatomic,weak) IBOutlet UILabel *nameLabel;
@property (nonatomic,weak) IBOutlet UILabel *phoneLabel;

@property (nonatomic,weak) IBOutlet UILabel *markLabel;
@property (nonatomic,weak) IBOutlet UILabel *highestLabel;
@property (nonatomic,weak) IBOutlet UILabel *usetimeLabel;
@property (nonatomic,weak) IBOutlet UILabel *useLabel;
@end

@implementation PersonDetailTableViewController
{
    UIView *bottom;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.tableView.tableFooterView = [UIView new];
    
    self.topView.title = @"个人档案";
    
    UIView *top = [[UIView alloc] initWithFrame:CGRectMake(0, -20, self.view.width, 20)];
    top.backgroundColor = [UIColor blackColor];
    [self.tableView addSubview:top];
    
    bottom = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.height-60, self.view.width, 40)];
    bottom.backgroundColor = [UIColor blackColor];
    [self.tableView addSubview:bottom];
    
    UIButton *buttom = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttom setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
    buttom.width = 40;
    buttom.height = 24;
    buttom.left = 0;
    buttom.centerY = 20;
    [bottom addSubview:buttom];
    
    [buttom addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    bottom.frame = CGRectMake(0, self.view.height-60, self.view.width, 40);
    [self updateUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

-(void)updateUI{
    self.nameLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"nickname"];
    self.phoneLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"loginname"];
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",emsresourceURL,[[NSUserDefaults standardUserDefaults] objectForKey:@"headimage"]]] placeholderImage:self.headImageView.image];
}

-(IBAction)backClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
//    return 0;
//}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
