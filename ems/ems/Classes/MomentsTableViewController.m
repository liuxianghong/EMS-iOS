//
//  MomentsTableViewController.m
//  ems
//
//  Created by 刘向宏 on 15/11/10.
//  Copyright © 2015年 刘向宏. All rights reserved.
//

#import "MomentsTableViewController.h"
#import "MomentsTableViewCell.h"
#import "EMSAPI.h"

@interface MomentsTableViewController ()
@property (nonatomic,strong) NSMutableArray *tableViewArray;
@end

@implementation MomentsTableViewController
{
    UIView *bottom;
    UIView *top;
    
    BOOL first;
    
    NSInteger page;
    NSInteger rows;
    
    NSDictionary *pageDic;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.estimatedRowHeight = 300.0f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    top = [[UIView alloc] initWithFrame:CGRectMake(0, -20, self.view.width, 20)];
    top.backgroundColor = [UIColor blackColor];
    [self.tableView addSubview:top];
    [self.tableView bringSubviewToFront:top];
    
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
    
    first = YES;
    self.tableViewArray = [[NSMutableArray alloc]init];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    bottom.frame = CGRectMake(0, self.view.height-60, self.view.width, 40);
    [self.tableView reloadData];
    if (first) {
        first = NO;
        page = 1;
        rows = 10;
        NSDictionary *dic = @{
                              @"userid" : [[NSUserDefaults standardUserDefaults] objectForKey:@"id"],
                              @"rows" : @(10),
                              @"page" : @(page)
                              };
        [EMSAPI getMyFriendsCirCleListWithParameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"%@",responseObject);
            if ([responseObject[@"state"] integerValue] == 0) {
                pageDic = responseObject[@"pages"];
                if (page == 0) {
                    [self.tableViewArray removeAllObjects];
                }
                [self.tableViewArray addObjectsFromArray:responseObject[@"data"]];
                [self.tableView reloadData];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            ;
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)backClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
#pragma mark -scrollView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.tableView) {
        top.frame = CGRectMake(0, scrollView.contentOffset.y, self.view.width, 20);
        bottom.frame = CGRectMake(0, self.view.height+scrollView.contentOffset.y-40, self.view.width, 40);
    }
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.tableViewArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MomentsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" forIndexPath:indexPath];
    
    // Configure the cell...
    cell.dic = self.tableViewArray[indexPath.section];
    return cell;
}


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
