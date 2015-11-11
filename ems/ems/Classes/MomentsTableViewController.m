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
#import <MJRefresh.h>
#import "InputView.h"

@interface MomentsTableViewController ()<UITextFieldDelegate,MomentsTableViewCellDelegate>
@property (nonatomic,strong) NSMutableArray *tableViewArray;
@property (nonatomic,strong) NSDictionary *keyBoardDic;
@end

@implementation MomentsTableViewController
{
    UIView *bottom;
    UIView *top;
    
    BOOL first;
    BOOL loadFirst;
    
    NSInteger page;
    NSInteger rows;
    
    NSDictionary *pageDic;
    
    InputView *inputView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    //self.tableView.tableFooterView = [UIView new];
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
    loadFirst = YES;
    self.tableViewArray = [[NSMutableArray alloc]init];
    
    //当键盘出来的时候通过通知来获取键盘的信息
    //注册为键盘的监听着
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(keyNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //bottom.frame = CGRectMake(0, self.view.height-60, self.view.width, 40);
    [self.tableView reloadData];
    if (first) {
        first = NO;
        page = 1;
        rows = 10;
        __weak MomentsTableViewController *weakSelf = self;
        self.tableView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
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
    NSDictionary *dic = @{
                          @"userid" : [[NSUserDefaults standardUserDefaults] objectForKey:@"id"],
                          @"rows" : @(5),
                          @"page" : @(page)
                          };
    [EMSAPI getMyFriendsCirCleListWithParameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        if ([responseObject[@"state"] integerValue] == 0) {
            pageDic = responseObject[@"pages"];
            if (page == 1) {
                [self.tableViewArray removeAllObjects];
                
            }
            NSMutableArray *newArray = [[NSMutableArray alloc]init];
            for (NSDictionary *dic in responseObject[@"data"]) {
                NSMutableArray *array = [[NSMutableArray alloc] initWithArray:dic[@"comments"]];
                NSMutableDictionary *mdic = [[NSMutableDictionary alloc]initWithDictionary:dic];
                [mdic setObject:array forKey:@"comments"];
                [newArray addObject:mdic];
            }
            [self.tableViewArray addObjectsFromArray:newArray];
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
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
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

-(void)doComment:(NSDictionary *)dic
{
    [inputView.field becomeFirstResponder];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                     atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

//当键盘出来的时候改变toolView的位置（接到键盘出来的通知要做的方法）
-(void) keyNotification : (NSNotification *) notification
{
    NSLog(@"%@", notification.userInfo);
    
    self.keyBoardDic = notification.userInfo;
    //获取键盘移动后的坐标点的坐标点
    CGRect rect = [self.keyBoardDic[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    
    //把键盘的坐标系改成当前我们window的坐标系
    CGRect r1 = [self.view convertRect:rect fromView:self.view.window];
    
    [UIView animateWithDuration:[self.keyBoardDic[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        
        //动画曲线
        [UIView setAnimationCurve:[self.keyBoardDic[UIKeyboardAnimationCurveUserInfoKey] doubleValue]];
        
        CGRect frame = inputView.frame;
        
        frame.origin.y = r1.origin.y - frame.size.height;
        
        //根据键盘的高度来改变toolView的高度
        //inputView.frame = frame;
    }];
}
#pragma mark -scrollView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.tableView) {
        top.frame = CGRectMake(0, scrollView.contentOffset.y, self.view.width, 20);
        bottom.frame = CGRectMake(0, self.view.height+scrollView.contentOffset.y-40, self.view.width, 40);
        [self.tableView bringSubviewToFront:top];
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
    cell.delegate = self;
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
