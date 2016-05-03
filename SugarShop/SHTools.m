//
//  SHTools.m
//  SweetHeart
//
//  Created by mac on 16/4/12.
//  Copyright (c) 2016年 diaoshihao. All rights reserved.
//

#import "SHTools.h"

@implementation SHTools


+(void)showAlertViewWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:action];
    [alertController addAction:cancel];
}

+ (void)AFNetworkReachabilityStatus {
    
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager startMonitoring];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        if (status == AFNetworkReachabilityStatusReachableViaWiFi ||
            status == AFNetworkReachabilityStatusReachableViaWWAN) {
            
            /*这里添加方法*/
            
        }
        else {
            /*
             
             [SHTools showAlertViewWithTitle:@"网络错误" message:@"哎呀！断网了..." delegate:nil];
             
             */
        }
    }];
}

+ (UIButton *)creatUIButtonWithTitle:(NSString *)title frame:(CGRect)frame normalImage:(UIImage *)image target:(id)target action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

+ (UILabel *)creatUILabelWithText:( NSString *)text frame:(CGRect)frame backgroundColor:(UIColor *)color {
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = text;
    label.backgroundColor = color;
    return label;
}

+ (UITextField *)createUITextFieldWithFrame:(CGRect)frame placeholder:(NSString *)placeholder {
    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
    textField.font = [UIFont systemFontOfSize:15];
    textField.backgroundColor = [UIColor whiteColor];
    textField.layer.cornerRadius = 4;
    textField.clipsToBounds = YES;
    textField.placeholder = placeholder;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    return textField;
}

+ (void)afGET:(NSString *)urlStr parameters:(id)parameters success:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nullable))success failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager GET:urlStr parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(task,responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(task,error);
    }];
}

+ (void)afPOST:(NSString *)URLString
    parameters:(nullable id)parameters
       success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
       failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager POST:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        success(task,responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failure(task,error);
        
    }];
}

+ (void)afPUT:(NSString *)URLString parameters:(id)parameters success:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nonnull))success failure:(void (^)(NSURLSessionDataTask * _Nonnull, NSError * _Nonnull))failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager PUT:URLString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(task,responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(task,error);
    }];
    
}

@end
