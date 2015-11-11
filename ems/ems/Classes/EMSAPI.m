//
//  EMSAPI.m
//  ems
//
//  Created by 刘向宏 on 15/9/2.
//  Copyright (c) 2015年 刘向宏. All rights reserved.
//

#import "EMSAPI.h"

#define kMethodUserRegister @"/user/register"
#define kMethodUserGetAuthCode @"/user/getAuthCode"
#define kMethodUserLogin @"/user/userLogin"
#define kMethodForgetPassword @"/user/forgetPassword"
#define kMethodResetPassWord @"/user/resetPassWord"
#define kMethodUpdateUserInfo @"/user/updateUserInfo"
#define kMethodUpdateHeadImage @"/user/updateHeadImage"
#define kMethodGetMyFriendsCirCleList @"/friendsCircle/getMyFriendsCirCleList"
#define kMethodFriendsCirclePraise @"/friendsCircle/friendsCirclePraise"
#define kMethodPublishComment @"/friendsCircle/publishComment"
#define kMethodInsertFriendsCircle @"/friendsCircle/insertFriendsCircle"

@implementation EMSAPI

+(void)saveUserImformatin:(NSDictionary *)responseObject
{
    for(NSString *key in [responseObject allKeys])
    {
        [[NSUserDefaults standardUserDefaults]setObject:responseObject[key] forKey:key];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)UserRegisterWithParameters: (id)parameters success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [[self sharedManager]defaultHTTPWithMethod:kMethodUserRegister WithParameters:parameters post:YES success:success failure:failure];
}

+ (void)GetAuthCodeWithParameters: (id)parameters success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [[self sharedManager]defaultHTTPWithMethod:kMethodUserGetAuthCode WithParameters:parameters post:YES success:success failure:failure];
}

+ (void)UserLoginWithParameters: (id)parameters success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [[self sharedManager]defaultHTTPWithMethod:kMethodUserLogin WithParameters:parameters post:YES success:success failure:failure];
}

+ (void)ForgetPasswordWithParameters: (id)parameters success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [[self sharedManager]defaultHTTPWithMethod:kMethodForgetPassword WithParameters:parameters post:YES success:success failure:failure];
}

+ (void)ResetPassWordWithParameters: (id)parameters success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [[self sharedManager]defaultHTTPWithMethod:kMethodResetPassWord WithParameters:parameters post:YES success:success failure:failure];
}

+ (void)UpdateUserInfoWithParameters: (id)parameters success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [[self sharedManager]defaultHTTPWithMethod:kMethodUpdateUserInfo WithParameters:parameters post:YES success:success failure:failure];
}

+ (void)updateHeadImageWithParameters: (id)parameters success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [[self sharedManager]defaultHTTPWithMethod:kMethodUpdateHeadImage WithParameters:parameters post:YES success:success failure:failure];
}

+(void)UploadImage:(UIImage *)image success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [[self sharedManager] filePostWithUrl:uploadResourceURL WithParameters:UIImageJPEGRepresentation(image, 0.8) success:success failure:failure];
}

+ (void)getMyFriendsCirCleListWithParameters: (id)parameters success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [[self sharedManager]defaultHTTPWithMethod:kMethodGetMyFriendsCirCleList WithParameters:parameters post:YES success:success failure:failure];
}

+ (void)friendsCirclePraiseWithParameters: (id)parameters success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [[self sharedManager]defaultHTTPWithMethod:kMethodFriendsCirclePraise WithParameters:parameters post:YES success:success failure:failure];
}

+ (void)PublishCommentWithParameters: (id)parameters success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [[self sharedManager]defaultHTTPWithMethod:kMethodPublishComment WithParameters:parameters post:YES success:success failure:failure];
}

+ (void)insertFriendsCircleWithParameters: (id)parameters success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    
    [[self sharedManager]defaultHTTPWithMethod:kMethodInsertFriendsCircle WithParameters:parameters post:YES success:success failure:failure];
}
@end
