//
//  SHTools.h
//  SweetHeart
//
//  Created by mac on 16/4/12.
//  Copyright (c) 2016年 diaoshihao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SHHeader.h"

@interface SHTools : NSObject

NS_ASSUME_NONNULL_BEGIN
/**
 *  根据标题和信息显示一个提示框
 */
+ (void)showAlertViewWithTitle:(NSString *)title message:(NSString *)message delegate:(nullable id)delegate;
/**
 *  判断并根据网络状况传递消息
 */
+ (void)AFNetworkReachabilityStatus;
/**
 *  根据标题、图片创建UIButton
 */
+ (UIButton *)creatUIButtonWithTitle:(NSString *)title frame:(CGRect)frame normalImage:(nullable UIImage *)image target:(nullable id)target  action:(nullable SEL)action;
/**
 *  创建UILabel
 */
+ (UILabel *)creatUILabelWithText:(NSString *)text frame:(CGRect)frame backgroundColor:(UIColor *)color;
/**
 *  创建UITextField
 */
+ (UITextField *)createUITextFieldWithFrame:(CGRect)frame placeholder:(NSString *)placeholder;

+ (void)afPUT:(NSString *)URLString
                   parameters:(id)parameters
                      success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
    failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

+ (void)afPOST:(NSString *)URLString
    parameters:(nullable id)parameters
       success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
       failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure;

/**
 *  GET网络请求
 *
 *  @param urlStr     网络路径
 *  @param parameters 网络参数
 *  @param success    成功block
 *  @param failure    失败block
 */
NS_ASSUME_NONNULL_END

+ (void)afGET:(nonnull NSString *)urlStr parameters:(nullable id)parameters
      success:(nullable void (^)(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject))success
      failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failure;




@end
