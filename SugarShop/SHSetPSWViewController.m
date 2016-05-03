//
//  SHSetPSWViewController.m
//  SugarShop
//
//  Created by mac on 16/4/25.
//  Copyright © 2016年 diaoshihao. All rights reserved.
//

#import "SHSetPSWViewController.h"
#import "SHTools.h"

@interface SHSetPSWViewController ()

@end

@implementation SHSetPSWViewController
{
    UITextField *textField;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:236/255.0 green:236/255.0  blue:236/255.0  alpha:1];
    self.navigationItem.title = @"设置密码";
    
    [self initUI];
}

//初始化UI
- (void)initUI {
    
    textField = [SHTools createUITextFieldWithFrame:CGRectMake(20, 80, self.view.bounds.size.width - 40, 35) placeholder:@"请设置一个密码，最少6位"];
    [self.view addSubview:textField];
    
    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeSystem];
    sendButton.frame = CGRectMake(40, 160, self.view.bounds.size.width - 80, 35);
    sendButton.layer.cornerRadius = 6;
    sendButton.clipsToBounds = YES;
    [sendButton setTitle:@"完成" forState:UIControlStateNormal];
    [sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sendButton.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.3];
    [sendButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sendButton];
}

//校验验证码
- (void)buttonClick:(UIButton *)sender {
    
    if (textField.text.length < 6) {
        [self showFailedAlert];
    }
    else {
        [self setPassword];
    }
    
}

- (void)setPassword {
    [SHTools afPOST:@"http://api.dantangapp.com/v1/account/mobile_set_password" parameters:@{@"code":@"123456",@"mobile":@"18218456285",@"password":@"123456"} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

- (void)showSuccessAlert {
    UIAlertController *successAlert = [UIAlertController alertControllerWithTitle:@"提示" message:@"注册成功!" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        //[[NSNotificationCenter defaultCenter] postNotificationName:@"register" object:nil userInfo:@{}];
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [successAlert addAction:action];
    [self presentViewController:successAlert animated:YES completion:nil];
}
 
- (void)showFailedAlert {
    NSString *message = @"密码不能少于6位，请重新设置";
    
    UIAlertController *failedAlert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *tryAgain = [UIAlertAction actionWithTitle:@"重试" style:UIAlertActionStyleDefault handler:nil];
    
    [failedAlert addAction:tryAgain];
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
