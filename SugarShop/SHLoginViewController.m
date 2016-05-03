//
//  SHLoginViewController.m
//  SugarShop
//
//  Created by mac on 16/4/23.
//  Copyright © 2016年 diaoshihao. All rights reserved.
//

#import "SHLoginViewController.h"
#import "SHTools.h"
#import "SHRegisterViewController.h"

@interface SHLoginViewController ()

@end

@implementation SHLoginViewController
{
    UITextField *userNameTextField;
    UITextField *passwordTextField;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor colorWithRed:236/255.0 green:236/255.0  blue:236/255.0  alpha:1];
    self.navigationItem.title = @"登录";
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    [self initNavigationItem];
    
    [self initUI];
    
}

- (void)initNavigationItem {
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(backToLastView:)];
    leftItem.tag = 1;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"注册" style:UIBarButtonItemStylePlain target:self action:@selector(backToLastView:)];
    rightItem.tag = 2;
    
    self.navigationItem.leftBarButtonItem = leftItem;
    self.navigationItem.rightBarButtonItem = rightItem;
    
}

- (void)backToLastView:(UIBarButtonItem *)sender {
    
    if (sender.tag == 1) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else if (sender.tag == 2) {
        SHRegisterViewController *registerVC = [[SHRegisterViewController alloc] init];
        [self.navigationController pushViewController:registerVC animated:YES];
    }
    
}

- (void)initUI {
    
    //用户名和密码框
    userNameTextField = [SHTools createUITextFieldWithFrame:CGRectMake(20, 120, self.view.bounds.size.width - 40, 35) placeholder:@"手机号"];
    userNameTextField.keyboardType = UIKeyboardTypeNumberPad;
    userNameTextField.returnKeyType = UIReturnKeyNext;
    [self.view addSubview:userNameTextField];
    
    passwordTextField = [SHTools createUITextFieldWithFrame:CGRectMake(20, 170, self.view.bounds.size.width - 40, 35) placeholder:@"密码"];
    passwordTextField.secureTextEntry = YES;
    [self.view addSubview:passwordTextField];
    
    //登录按钮
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeSystem];
    loginButton.frame = CGRectMake(40, 230, self.view.bounds.size.width - 80, 35);
    loginButton.layer.cornerRadius = 6;
    loginButton.clipsToBounds = YES;
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginButton.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.3];
    [loginButton addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginButton];
}

- (void)login:(UIButton *)sender {
    [userNameTextField resignFirstResponder];
    [passwordTextField resignFirstResponder];
    
    NSDictionary *parameter = @{@"mobile":userNameTextField.text,@"password":passwordTextField.text};
    [SHTools afPOST:kSHLOGIN parameters:parameter success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [self showSuccessAlert];
        
        //通知中心发布广播
        [[NSNotificationCenter defaultCenter] postNotificationName:@"login" object:nil userInfo:responseObject[@"data"]];
        
        //保存登录信息
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"login"];
        
        [[NSUserDefaults standardUserDefaults] setObject:userNameTextField.text forKey:@"userName"];
        [[NSUserDefaults standardUserDefaults] setObject:passwordTextField.text forKey:@"password"];
        [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"data"][@"avatar_url"] forKey:@"avatar_url"];
        [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"data"][@"nickname"] forKey:@"nickname"];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self showFailedAlert];
        
    }];
}

- (void)showSuccessAlert {
    UIAlertController *successAlert = [UIAlertController alertControllerWithTitle:@"提示" message:@"登录成功!" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [userNameTextField resignFirstResponder];
        [passwordTextField resignFirstResponder];
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [successAlert addAction:action];
    [self presentViewController:successAlert animated:YES completion:nil];
}

- (void)showFailedAlert {
    NSString *message = nil;

    if (userNameTextField.text == nil) {
        message = @"用户名是空的";
    }
    else if (passwordTextField.text == nil) {
        message = @"没有填写密码";
    }
    else {
        message = @"用户名或密码错误";
    }
    UIAlertController *failedAlert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *tryAgain = [UIAlertAction actionWithTitle:@"重试" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [userNameTextField becomeFirstResponder];
    }];
    UIAlertAction *comeBack = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [failedAlert addAction:tryAgain];
    [failedAlert addAction:comeBack];
    [self presentViewController:failedAlert animated:YES completion:nil];
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
