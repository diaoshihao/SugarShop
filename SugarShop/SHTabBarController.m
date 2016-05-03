//
//  SHTabBarController.m
//  SweetHeart
//
//  Created by mac on 16/4/11.
//  Copyright (c) 2016年 diaoshihao. All rights reserved.
//

#import "SHTabBarController.h"
#import "SHTools.h"
#import <MMDrawerController.h>
#import "SHMenuTableViewController.h"

@interface SHTabBarController ()

@end

@implementation SHTabBarController

#pragma mark 判断网络状态
- (void)AFNetworkReachabilityStatus {
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager startMonitoring];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusReachableViaWWAN) {
            [self showAlertViewWithTitle:@"提示" message:@"正在使用流量模式,是否继续?" delegate:nil];
        }
        else if (status == AFNetworkReachabilityStatusReachableViaWiFi) {
            
            appDelegate.shouldRefresh = YES;
            
            [self creatTabBar];
            
            //登录
            if ([[NSUserDefaults standardUserDefaults] boolForKey:@"login"]) {
                [self login];
                return;
            }
        }
        else {
            [self showAlertViewWithTitle:@"网络错误" message:@"好像木有联网哦" delegate:nil];
            
            appDelegate.shouldRefresh = NO;
            
            [self creatTabBar];
            
        }
    }];
    
}

#pragma mark 网络提示框
- (void)showAlertViewWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate{
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        appDelegate.shouldRefresh = NO;
        
        [self creatTabBar];
       
    }];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"继续" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        appDelegate.shouldRefresh = YES;
        
        [self creatTabBar];
        
    }];
    
    [alertController addAction:action];
    [alertController addAction:cancel];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.tabBar.tintColor = [UIColor colorWithRed:255/255.0 green:112/255.0 blue:117/255.0 alpha:1];
    
    
    //用户决定是否允许数据请求后再创建标签栏
    [self AFNetworkReachabilityStatus];
    
}

#pragma mark 创建tabBar
- (void)creatTabBar {
    NSArray *array = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"class" ofType:@"plist"]];
    
    NSMutableArray *arrM = [[NSMutableArray alloc] init];
    for (NSDictionary *dict in array) {
        UIViewController *viewController = [[NSClassFromString(dict[@"className"]) alloc] init];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
        navigationController.navigationBar.tintColor = [UIColor whiteColor];
        navigationController.navigationBar.barTintColor = [UIColor colorWithRed:255/255.0 green:116/255.0 blue:117/255.0 alpha:1];
        navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
        
        viewController.title = dict[@"title"];
  
        viewController.tabBarItem.image = [UIImage imageNamed:dict[@"image"]];
        
        [arrM addObject:navigationController];
    }
    self.viewControllers = arrM;
}

#pragma mark 登录
- (void)login {
    
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
    
    NSDictionary *parameter = @{@"mobile":userName,@"password":password};
    [SHTools afPOST:kSHLOGIN parameters:parameter success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
        [[NSNotificationCenter defaultCenter] postNotificationName:@"loginOrLogout" object:nil userInfo:responseObject[@"data"]];
        
        //保存登录信息
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"login"];
        
        [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"data"][@"avatar_url"] forKey:@"avatar_url"];
        [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"data"][@"nickname"] forKey:@"nickname"];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
