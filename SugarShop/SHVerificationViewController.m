//
//  SHVerificationViewController.m
//  SugarShop
//
//  Created by mac on 16/4/24.
//  Copyright © 2016年 diaoshihao. All rights reserved.
//

#import "SHVerificationViewController.h"
#import "SHTools.h"
#import "SHSetPSWViewController.h"

@interface SHVerificationViewController ()

@end

@implementation SHVerificationViewController
{
    UITextField *textField;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithRed:236/255.0 green:236/255.0  blue:236/255.0  alpha:1];
    self.navigationItem.title = @"填写注册码";
    
    [self initUI];
}

//初始化UI
- (void)initUI {
    UILabel *tipsLable = [[UILabel alloc] initWithFrame:CGRectMake(20, 90, self.view.bounds.size.width - 40, 35)];
    tipsLable.text = [NSString stringWithFormat:@"已发送验证码短信至%@,请稍后",self.phoneNum];
    tipsLable.font = [UIFont systemFontOfSize:15];
    tipsLable.textColor = [UIColor grayColor];
    [self.view addSubview:tipsLable];
    
    textField = [SHTools createUITextFieldWithFrame:CGRectMake(20, 120, self.view.bounds.size.width - 40, 35) placeholder:@"请输入验证码"];
    textField.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:textField];
    
    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeSystem];
    sendButton.frame = CGRectMake(40, 200, self.view.bounds.size.width - 80, 35);
    sendButton.layer.cornerRadius = 6;
    sendButton.clipsToBounds = YES;
    [sendButton setTitle:@"下一步" forState:UIControlStateNormal];
    [sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sendButton.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.3];
    [sendButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sendButton];
}

//校验验证码
- (void)buttonClick:(UIButton *)sender {
 
//    [SMSSDK commitVerificationCode:textField.text phoneNumber:self.phoneNum zone:@"86" result:^(NSError *error) {
//    
//        if (!error) {
//            //向服务器注册
//            [self registerWithVerifyCode:textField.text phoneNumber:self.phoneNum];
//            
//        }
//        else
//        {
//            NSLog(@"错误信息：%@",error);
//            [self showFailedAlert];
//        }
//    }];
    
}

- (void)registerWithVerifyCode:(NSString *)code phoneNumber:(NSString *)phoneNum {
    [SHTools afPOST:kSHVERIFY parameters:@{@"code":code,@"mobile":phoneNum} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"%@",responseObject);
        SHSetPSWViewController *setPSW = [[SHSetPSWViewController alloc] init];
        setPSW.verifyCode = code;
        setPSW.phoneNum = phoneNum;
        [self.navigationController pushViewController:setPSW animated:YES];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        [self showFailedAlert];
    }];
}

- (void)showFailedAlert {
    NSString *message = @"验证码错误或失效,请重试";
    
    UIAlertController *failedAlert = [UIAlertController alertControllerWithTitle:@"验证码错误" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *tryAgain = [UIAlertAction actionWithTitle:@"重试" style:UIAlertActionStyleDefault handler:nil];
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
