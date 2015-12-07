//
//  PublishViewController.m
//  ems
//
//  Created by 刘向宏 on 15/11/11.
//  Copyright © 2015年 刘向宏. All rights reserved.
//

#import "PublishViewController.h"
#import "EMSAPI.h"
#import <MBProgressHUD.h>
#import "MomentsCollectionViewCell.h"
#import "ImageSeeViewController.h"

#define CCellWidth (self.view.width-40-30)/3

@interface PublishViewController ()<UITextFieldDelegate,UITextViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic,weak) IBOutlet UITextField *titleField;
@property (nonatomic,weak) IBOutlet UITextView *messageView;
@property (nonatomic,weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic,weak) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;
@property (nonatomic,weak) IBOutlet UIButton *imageButton;
@end

@implementation PublishViewController
{
    NSMutableArray *images;
    NSMutableArray *imagesTrue;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
    //[topView setBarStyle:UIBarStyleBlack];
    topView.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(doneChoice)];
    NSArray * buttonsArray = [NSArray arrayWithObjects:btnSpace,doneButton,nil];
    [topView setItems:buttonsArray];
    self.messageView.inputAccessoryView = topView;
    
    imagesTrue = [[NSMutableArray alloc]init];
    images = [[NSMutableArray alloc]init];
    
    self.titleField.text = self.titleText;
    self.messageView.text = self.messageText;
    if (self.image) {
        [imagesTrue addObject:self.image];
        self.imageButton.hidden = YES;
        [images addObject:@"1"];
        self.messageLabel.hidden = YES;
        self.heightConstraint.constant = (([images count]-1)/3+1)*(CCellWidth+10);
    }
    [self.collectionView reloadData];
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

-(IBAction)sendClick:(id)sender{
    
    if([self.titleField.text length]<1)
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"提示";
        hud.detailsLabelText = @"请输入标题";
        [hud hide:YES afterDelay:1.5f];
        return;
    }
    if ([self.messageView.text length]<1) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"提示";
        hud.detailsLabelText = @"请输入内容";
        [hud hide:YES afterDelay:1.5f];
        return;
    }
    
    if (self.image) {
        [self uploadImage:self.image];
    }
    else
    {
        [self publish];
    }
}

-(void)publish{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
    NSDictionary *dic = @{
                          @"userid" : [[NSUserDefaults standardUserDefaults] objectForKey:@"id"],
                          @"title" : self.titleField.text,
                          @"content" : self.messageView.text,
                          @"images" : images
                          };
    [EMSAPI insertFriendsCircleWithParameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        if([responseObject[@"state"] integerValue] == 0)
        {
            hud.mode = MBProgressHUDModeText;
            hud.detailsLabelText = @"发帖成功";
            [hud hide:YES afterDelay:1.5f];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"提示";
            hud.detailsLabelText = @"发帖失败";
            [hud hide:YES afterDelay:1.5f];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabelText = error.domain;
        [hud hide:YES afterDelay:1.5f];
    }];
}

-(void)doneChoice
{
    [self.messageView resignFirstResponder];
}

-(void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length == 0) {
        self.messageLabel.hidden = NO;
    }else{
        self.messageLabel.hidden = YES;
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [images count];
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"GradientCell";
    MomentsCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor blackColor];
    CGFloat width = CCellWidth;
    cell.imageView.size = CGSizeMake(width, width);
    cell.imageView.image = imagesTrue[indexPath.row];//
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
    return cell;
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (images) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Other" bundle:nil];
        ImageSeeViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"seeImage"];
        vc.image = imagesTrue[indexPath.row];
        [self presentViewController:vc animated:NO completion:nil];
    }
    
}


#pragma mark --UICollectionViewDelegateFlowLayout

//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = CCellWidth;
    return CGSizeMake(width, width);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

- (IBAction)chooseApproveImage{
    if ([images count]>=9) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"提示";
        hud.detailsLabelText = @"最多九张图片";
        [hud hide:YES afterDelay:1.5f];
        return;
    }
    [self.messageView resignFirstResponder];
    [self.titleField resignFirstResponder];
    UIActionSheet *sheet;
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        sheet  = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从手机相册选择", nil];
    }
    else {
        sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从手机相册选择", nil];
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
    imagePickerController.allowsEditing = NO;
    imagePickerController.sourceType = sourceType;
    [self presentViewController:imagePickerController animated:YES completion:nil];
    //    }
}
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *image2=[info objectForKey:UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:^{
        [self uploadImage:image2];
    }];
    
    
}

-(void)uploadImage:(UIImage *)image
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
    hud.dimBackground = YES;
    hud.labelText = @"图片上传中...";
    [EMSAPI UploadImage:image success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if([[responseObject[@"state"] safeString] integerValue]==0)
        {
            NSString *imageNmae = responseObject[@"data"][@"name"];
            if (self.image) {
                [images removeObjectAtIndex:0];
                [images addObject:imageNmae];
                [hud hide:YES];
                [self publish];
                return ;
            }
            else
            {
                [images addObject:imageNmae];
                [imagesTrue addObject:image];
            }
            CGFloat width = CCellWidth;
            self.heightConstraint.constant = (([images count]-1)/3+1)*(width+10);
            [self.collectionView reloadData];
            [hud hide:YES];
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
