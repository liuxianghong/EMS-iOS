//
//  AttentionViewController.m
//  ems
//
//  Created by 刘向宏 on 15/11/12.
//  Copyright © 2015年 刘向宏. All rights reserved.
//

#import "AttentionViewController.h"
#import "EMSAPI.h"
#import "AttentionTableViewCell.h"
#import <MJRefresh.h>
#import <UIImageView+WebCache.h>
#import <MBProgressHUD.h>

@interface AttentionViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,AttentionTableViewDelegate>
@property (nonatomic,weak) IBOutlet UIButton *numberButton;
@property (nonatomic,weak) IBOutlet UISearchBar *searchBar;
@property (nonatomic,weak) IBOutlet UITableView *tableView;
@end

@implementation AttentionViewController
{
    NSMutableArray *tableViewArray;
    
    BOOL first;
    
    NSInteger page;
    NSInteger rows;
    NSString *keyword;
    
    NSDictionary *pageDic;
    
    NSInteger nmuberCount;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSDictionary *dic = @{
                          @"userid" : [[NSUserDefaults standardUserDefaults] objectForKey:@"id"],
                          @"rows" : @"1",
                          @"page" : @"1"
                          };
    
    [EMSAPI getFriendsConcernedByUserIdWithParameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        if ([responseObject[@"state"] integerValue] == 0) {
            nmuberCount = [responseObject[@"pages"][@"itemCount"] integerValue];
            [self.numberButton setTitle:[NSString stringWithFormat:@"已关注：%ld",nmuberCount] forState:UIControlStateNormal];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        ;
    }];
    
    tableViewArray = [[NSMutableArray alloc]init];
    keyword = @"";
    first = YES;
    
    self.tableView.tableFooterView = [UIView new];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    if (first) {
        first = NO;
        page = 1;
        rows = 10;
        __weak AttentionViewController *weakSelf = self;
        self.tableView.mj_header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
            if (weakSelf.tableView.mj_footer.isRefreshing) {
                [weakSelf.tableView.mj_header endRefreshing];
                return ;
            }
            page = 1;
            dispatch_after(dispatch_time(0, 0), dispatch_get_main_queue(), ^{
                [self loadData];
            });
            
        }];
        
        self.tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
            if ([pageDic[@"next"] integerValue] == 0) {
                [self.tableView.mj_footer endRefreshing];
                return ;
            }
            if (self.tableView.mj_header.isRefreshing) {
                [self.tableView.mj_footer endRefreshing];
                return ;
            }
            page++;
            dispatch_after(dispatch_time(0, 0), dispatch_get_main_queue(), ^{
                [self loadData];
            });
        }];
        [self.tableView.mj_header beginRefreshing];
    }
}

-(void)loadData{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *dic = @{
                          @"userid" : [[NSUserDefaults standardUserDefaults] objectForKey:@"id"],
                          @"rows" : @(10),
                          @"page" : @(page),
                          @"keyword" : keyword
                          };
    [EMSAPI getFriendsUnConcernedListByUserIdWithParameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        if ([responseObject[@"state"] integerValue] == 0) {
            pageDic = responseObject[@"pages"];
            if (page == 1) {
                [tableViewArray removeAllObjects];
                
            }
            [tableViewArray addObjectsFromArray:responseObject[@"data"]];
            if ([pageDic[@"next"] integerValue] == 0) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            else
            {
                [self.tableView.mj_footer resetNoMoreData];
            }
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            [self.tableView reloadData];
            
        }
        [hud hide:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [hud hide:YES];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

-(IBAction)backClick:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -scrollView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.tableView) {
        [self.searchBar resignFirstResponder];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [tableViewArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AttentionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" forIndexPath:indexPath];
    
    // Configure the cell...
    NSDictionary *dic = tableViewArray[indexPath.row];
    [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",emsresourceURL,dic[@"headimage"]]] placeholderImage:[UIImage imageNamed:@"ic_login_icon.png"]];
    cell.nameLabel.text = dic[@"nickname"];
    cell.sexLabel.text = [dic[@"sex"] integerValue]==1?@"男":@"女";
    cell.delegate = self;
    cell.tag = indexPath.row;
    return cell;
}

-(void)addClick:(NSInteger)tag
{
    NSDictionary *dic = tableViewArray[tag];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *rDic = @{
                           @"userid" : [[NSUserDefaults standardUserDefaults] objectForKey:@"id"],
                           @"concern_userid" : dic[@"id"]
                           };
    [EMSAPI friendsConcernWithParameters:rDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject[@"state"] integerValue]==1) {
            hud.detailsLabelText = @"添加关注成功";
            [tableViewArray removeObjectAtIndex:tag];
            nmuberCount++;
            [self.numberButton setTitle:[NSString stringWithFormat:@"已关注：%ld",nmuberCount] forState:UIControlStateNormal];
            [self.tableView reloadData];
        }
        else
        {
             hud.detailsLabelText = @"添加关注失败";
        }
        hud.mode = MBProgressHUDModeText;
        [hud hide:YES afterDelay:1.5f];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabelText = error.domain;
        [hud hide:YES afterDelay:1.5f];
    }];
    
}
#pragma mark - UISearchBar
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    keyword = searchBar.text;
    [self.tableView.mj_header beginRefreshing];
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
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
