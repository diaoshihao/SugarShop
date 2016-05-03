//
//  SHRegisterViewController.m
//  SugarShop
//
//  Created by mac on 16/4/23.
//  Copyright © 2016年 diaoshihao. All rights reserved.
//

#import "SHRegisterViewController.h"
#import "SHTools.h"
#import "SHVerificationViewController.h"


@interface SHRegisterViewController ()

@end

@implementation SHRegisterViewController
{
    UITextField *textField;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:236/255.0 green:236/255.0  blue:236/255.0  alpha:1];
    self.navigationItem.title = @"注册";
    
    [self initLeftBtn];
    
    [self initUI];
}

- (void)initLeftBtn {
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backToLastView:)];
    self.navigationItem.leftBarButtonItem = item;
}

- (void)backToLastView:(UIBarButtonItem *)item {
    //    self.navigationController.navigationBarHidden = ;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initUI {
    UILabel *tipsLable = [[UILabel alloc] initWithFrame:CGRectMake(20, 90, self.view.bounds.size.width - 40, 35)];
    tipsLable.text = @"请确保您的手机畅通，以接收验证码短信";
    tipsLable.font = [UIFont systemFontOfSize:15];
    tipsLable.textColor = [UIColor grayColor];
    [self.view addSubview:tipsLable];
    
    textField = [SHTools createUITextFieldWithFrame:CGRectMake(20, 120, self.view.bounds.size.width - 40, 35) placeholder:@"请输入手机号"];
    textField.keyboardType = UIKeyboardTypeNumberPad;
    textField.returnKeyType = UIReturnKeyNext;
    [self.view addSubview:textField];
    
    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeSystem];
    sendButton.frame = CGRectMake(40, 200, self.view.bounds.size.width - 80, 35);
    sendButton.layer.cornerRadius = 6;
    sendButton.clipsToBounds = YES;
    [sendButton setTitle:@"发送验证码到手机" forState:UIControlStateNormal];
    [sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sendButton.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.3];
    [sendButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sendButton];
}

- (void)buttonClick:(UIButton *)sender {
    
    [self isPhoneNumExists];
    
}

#pragma mark - 注册POST请求
//判断能否注册
- (void)isPhoneNumExists {
    [SHTools afPOST:kSHREGISTER parameters:@{@"mobile":textField.text} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"%@",responseObject);
        if ([responseObject[@"data"][@"exist"] integerValue] == 0) {
        }
        else {
            [self showFailedAlert:@"手机号已注册，请返回登录或重试"];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self showFailedAlert:@"手机号码有误，请重新输入"];
    }];
}

- (void)showFailedAlert:(NSString *)reason {
    NSString *message = reason;
    
    UIAlertController *failedAlert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *tryAgain = [UIAlertAction actionWithTitle:@"重试" style:UIAlertActionStyleDefault handler:nil];
    UIAlertAction *comeBack = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [textField resignFirstResponder];
        [self.navigationController popViewControllerAnimated:YES];
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
