//
//  PersonDetailEditeTableViewController.m
//  ems
//
//  Created by 刘向宏 on 15/11/10.
//  Copyright © 2015年 刘向宏. All rights reserved.
//

#import "PersonDetailEditeTableViewController.h"
#import <MBProgressHUD.h>
#import "EMSAPI.h"
#import <UIImageView+WebCache.h>

@interface PersonDetailEditeTableViewController ()<UIScrollViewDelegate>

@property (nonatomic,weak) IBOutlet UIImageView *imageView;

@property (nonatomic,weak) IBOutlet TopView *topView;
@property (nonatomic,weak) IBOutlet UILabel *nameLabel;
@property (nonatomic,weak) IBOutlet UILabel *phoneLabel;

@property (nonatomic,weak) IBOutlet UIButton *sexManButton;
@property (nonatomic,weak) IBOutlet UIButton *sexWomanButton;

@property (nonatomic,weak) IBOutlet UITextField *nickNameField;
@property (nonatomic,weak) IBOutlet UITextField *heightField;
@property (nonatomic,weak) IBOutlet UITextField *wightField;
@end

@implementation PersonDetailEditeTableViewController
{
    UIView *bottom;
    UIView *top;
    
    UIPickerView *wightPickView;
    UIPickerView *heightPickView;
    
    NSString *weight;
    NSString *height;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.tableView.tableFooterView = [UIView new];
    
    self.topView.title = @"个人档案";
    
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
    
    wightPickView = [[UIPickerView alloc]init];
    //wightPickView.backgroundColor = [UIColor whiteColor];
    wightPickView.delegate = self;
    wightPickView.dataSource = self;
    self.wightField.inputView = wightPickView;
    self.wightField.inputAccessoryView = [self creactinputAccessoryView:1];
    
    heightPickView = [[UIPickerView alloc]init];
    //heightPickView.backgroundColor = [UIColor whiteColor];
    heightPickView.delegate = self;
    heightPickView.dataSource = self;
    self.heightField.inputView = heightPickView;
    self.heightField.inputAccessoryView = [self creactinputAccessoryView:2];
    
    
    [self updateUI];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    bottom.frame = CGRectMake(0, self.view.height-60, self.view.width, 40);
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
    self.nickNameField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"nickname"];
    self.heightField.text = [NSString stringWithFormat:@"%ldcm",[[[NSUserDefaults standardUserDefaults] objectForKey:@"height"] integerValue]];
    self.wightField.text = [NSString stringWithFormat:@"%ldkg",[[[NSUserDefaults standardUserDefaults] objectForKey:@"weight"] integerValue]];
    self.sexManButton.selected = [[[NSUserDefaults standardUserDefaults] objectForKey:@"sex"] integerValue] ==1;
    self.sexWomanButton.selected = [[[NSUserDefaults standardUserDefaults] objectForKey:@"sex"] integerValue] == 2;
    height = [[[NSUserDefaults standardUserDefaults] objectForKey:@"height"] stringValue];
    weight = [[[NSUserDefaults standardUserDefaults] objectForKey:@"weight"] stringValue];
    
    [wightPickView selectRow:(5000-5000%350-20+[weight integerValue]) inComponent:0 animated:NO];
    [heightPickView selectRow:(5000-5000%250-50+[height integerValue]) inComponent:0 animated:NO];
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",emsresourceURL,[[NSUserDefaults standardUserDefaults] objectForKey:@"headimage"]]] placeholderImage:self.imageView.image];
    
}

-(IBAction)backClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)womanClick:(id)sender
{
    self.sexWomanButton.selected = YES;
    self.sexManButton.selected = NO;
}

-(IBAction)manClick:(id)sender
{
    self.sexWomanButton.selected = NO;
    self.sexManButton.selected = YES;
}

-(UIView *)creactinputAccessoryView:(NSInteger)tag{
    UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
    topView.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem * cancelButton = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancelChoice:)];
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(doneChoice:)];
    NSArray * buttonsArray = [NSArray arrayWithObjects:cancelButton,btnSpace,doneButton,nil];
    doneButton.tag = cancelButton.tag = tag;
    [topView setItems:buttonsArray];
    [self doneChoice:doneButton];
    return topView;
}

-(void)keyboardHide:(id)sender
{
    [self.nickNameField resignFirstResponder];
    [self.wightField resignFirstResponder];
    [self.heightField resignFirstResponder];
}

-(void)cancelChoice:(UIBarButtonItem *)sender
{
    [self keyboardHide:nil];
}

-(void)doneChoice:(UIBarButtonItem *)sender
{
    [self keyboardHide:nil];
    switch (sender.tag) {
        case 1:
        {
            self.wightField.text = [NSString stringWithFormat:@"%ldkg",[wightPickView selectedRowInComponent:0]%350+20];
            weight = [NSString stringWithFormat:@"%ld",[wightPickView selectedRowInComponent:0]%350+20];
        }
            break;
        case 2:
        {
            self.heightField.text = [NSString stringWithFormat:@"%ldcm",[heightPickView selectedRowInComponent:0]%250+50];
            height = [NSString stringWithFormat:@"%ld",[heightPickView selectedRowInComponent:0]%250+50];
        }
            break;
            
        default:
            break;
    }
}

-(IBAction)saveClick:(id)sender
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
    hud.dimBackground = YES;
    if ([self.nickNameField.text length]<1) {
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabelText = @"请输入昵称";
        [hud hide:YES afterDelay:1.5f];
    }
    NSDictionary *dic = @{
                          @"id" : [[NSUserDefaults standardUserDefaults] objectForKey:@"id"],
                          @"nickname" : self.nickNameField.text,
                          @"sex" : self.sexManButton.selected?@"1":@"2",
                          @"height" : height,
                          @"weight" : weight,
                          @"longitude" : [[NSUserDefaults standardUserDefaults] objectForKey:@"longitude"],
                          @"latitude" : [[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"],
                          @"address" : [[NSUserDefaults standardUserDefaults] objectForKey:@"address"]
                          };
    [EMSAPI UpdateUserInfoWithParameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        if(![[responseObject[@"state"] safeString] integerValue])
        {
            hud.mode = MBProgressHUDModeText;
            hud.detailsLabelText = @"修改成功";
            [hud hide:YES];
            [EMSAPI saveUserImformatin:[responseObject[@"data"] firstObject]];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else if([responseObject[@"state"] integerValue]==1)
        {
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"提示";
            hud.detailsLabelText = @"用户名不存在";
            [hud hide:YES afterDelay:1.5f];
        }
        else
        {
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"提示";
            hud.detailsLabelText = @"服务器内部错误";
            [hud hide:YES afterDelay:1.5f];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabelText = error.domain;
        [hud hide:YES afterDelay:1.5f];
    }];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    //    if ([pickerView isEqual:sexPickView]) {
    //        return 10000;
    //    }
    //    else if ([pickerView isEqual:wightPickView])
    //    {
    //        return 10000;
    //    }
    //    else if ([pickerView isEqual:heightPickView])
    //    {
    //        return 10000;
    //    }
    return 10000;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if ([pickerView isEqual:wightPickView])
    {
        return [NSString stringWithFormat:@"%ldkg",row%350+20];
    }
    else if ([pickerView isEqual:heightPickView])
    {
        return [NSString stringWithFormat:@"%ldcm",row%250+50];;
    }
    return nil;
}
#pragma mark - Table view data source

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.tableView) {
        top.frame = CGRectMake(0, scrollView.contentOffset.y, self.view.width, 20);
    }
}
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

- (IBAction)chooseApproveImage{
    UIActionSheet *sheet;
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        sheet  = [[UIActionSheet alloc] initWithTitle:@"更新您的Show Ya!头像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从手机相册选择", nil];
    }
    else {
        sheet = [[UIActionSheet alloc] initWithTitle:@"更新您的Show Ya!头像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从手机相册选择", nil];
    }
    [sheet showInView:self.view];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    NSUInteger sourceType = 0;
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        switch (buttonIndex) {
            case 0:
                // 相机
                sourceType = UIImagePickerControllerSourceTypeCamera;
                break;
            case 1:
                // 相册
                sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                break;
            default:
                return;
        }
    }
    else {
        if (buttonIndex == 1) {
            return;
        } else {
            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
    }
    //    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    imagePickerController.sourceType = sourceType;
    [self presentViewController:imagePickerController animated:YES completion:nil];
    //    }
}
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *image2=[info objectForKey:UIImagePickerControllerEditedImage];
    [picker dismissViewControllerAnimated:YES completion:^{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
        hud.dimBackground = YES;
        [EMSAPI UploadImage:image2 success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if([[responseObject[@"state"] safeString] integerValue]==0)
            {
                NSString *imageNmae = responseObject[@"data"][@"name"];
                NSDictionary *dic = @{
                                      @"id" : [[NSUserDefaults standardUserDefaults] objectForKey:@"id"],
                                      @"headimage" : imageNmae
                                      };
                [EMSAPI updateHeadImageWithParameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    if([[responseObject[@"state"] safeString] integerValue]==0)
                    {
                        [[NSUserDefaults standardUserDefaults] setObject:imageNmae forKey:@"headimage"];
                        self.imageView.image = image2;
                    }
                    [hud hide:YES];
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    hud.mode = MBProgressHUDModeText;
                    hud.labelText = @"提示";
                    hud.detailsLabelText = error.domain;
                    [hud hide:YES afterDelay:1.5f];
                }];
            }
            else
            {
                hud.mode = MBProgressHUDModeText;
                hud.labelText = @"提示";
                hud.detailsLabelText = @"上传图片失败";
                [hud hide:YES afterDelay:1.5f];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"提示";
            hud.detailsLabelText = error.domain;
            [hud hide:YES afterDelay:1.5f];
        }];
    }];
    
    
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
