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


@implementation EMSAPI

+(void)saveUserImformatin:(NSDictionary *)responseObject
{
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
@end
