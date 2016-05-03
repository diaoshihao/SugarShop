//
//  SHEditViewController.m
//  SugarShop
//
//  Created by mac on 16/4/27.
//  Copyright © 2016年 diaoshihao. All rights reserved.
//

#import "SHEditViewController.h"
#import "SHTools.h"

@interface SHEditViewController () <UITextFieldDelegate>

@property (nonatomic, strong) UIImageView *headImage;

@property (nonatomic) BOOL didEdit;

@end

@implementation SHEditViewController
{
    UITextField *nickName;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:255/255.0 green:112/255.0 blue:117/255.0 alpha:1];
    
    self.view.backgroundColor = [UIColor colorWithRed:236/255.0 green:236/255.0  blue:236/255.0  alpha:1];
    self.navigationItem.title = @"编辑资料";
    
    self.didEdit = NO;
        
    [self initNavigationItem];
    
    [self initUI];
    
}

- (void)initUI {
    
    CGFloat width = self.view.bounds.size.width;
    CGFloat height = width / 2.0;
    CGFloat headHeight = height / 3.0;
    self.headImage = [[UIImageView alloc] initWithFrame:CGRectMake(width / 2.0 - headHeight / 2.0, 64 + headHeight, headHeight, headHeight)];
    self.headImage.contentMode = UIViewContentModeScaleAspectFill;
    //自动布局，自适应顶部
    _headImage.autoresizingMask = UIViewAutoresizingFlexibleTopMargin |UIViewAutoresizingFlexibleBottomMargin;
    
    //显示用户头像
    NSString *avatar_url = [[NSUserDefaults standardUserDefaults] objectForKey:@"avatar_url"];
    self.headImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:avatar_url]]];
    self.headImage.layer.cornerRadius = height / 3.0 / 2;
    self.headImage.clipsToBounds = YES;
    
    self.headImage.userInteractionEnabled = YES;
    
    //添加点击手势
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    [self.headImage addGestureRecognizer:tapGesture];
    [self.view addSubview:self.headImage];

    
    nickName = [SHTools createUITextFieldWithFrame:CGRectMake(20, 2 * headHeight + 100, self.view.bounds.size.width - 40, 35) placeholder:@"昵称"];
    nickName.delegate = self;
    nickName.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"nickname"];
    nickName.textAlignment = NSTextAlignmentCenter;
    nickName.returnKeyType = UIReturnKeyDone;
    [self.view addSubview:nickName];
    
}

- (void)tapClick:(UITapGestureRecognizer *)tap {
    
}

- (void)initNavigationItem {
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(backToLastView:)];
    leftItem.tag = 10;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(backToLastView:)];
    rightItem.tag = 20;
    
    self.navigationItem.leftBarButtonItem = leftItem;
    self.navigationItem.rightBarButtonItem = rightItem;
    
}

- (void)backToLastView:(UIBarButtonItem *)sender {
    
    if (sender.tag == 10) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else if (sender.tag == 20) {
        if (self.didEdit) {
            if (nickName.text.length == 0) {
                [self showFailedAlert:@"昵称不能为空"];
                return;
            }
            
            [SHTools afPUT:kSHEDIT parameters:@{@"nickname":nickName.text} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                
                [self showSuccessAlert];
                
                //通知中心发布广播
                [[NSNotificationCenter defaultCenter] postNotificationName:@"reset" object:nil userInfo:responseObject[@"data"]];
                
                //更新信息
                [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"data"][@"nickname"] forKey:@"nickname"];
                
            } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                [self showFailedAlert:@"更新资料失败,请检查网络"];
            }];
        }
        else {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
    else;
}

#pragma mark textFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.didEdit = YES;
}

- (void)showSuccessAlert {
    UIAlertController *successAlert = [UIAlertController alertControllerWithTitle:nil message:@"资料已更新" preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:successAlert animated:YES completion:nil];
    [UIView animateWithDuration:2.5 animations:^{
        [self dismissViewControllerAnimated:YES completion:^{
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
    }];
    
}

- (void)showFailedAlert:(NSString *)message {

    UIAlertController *failedAlert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *tryAgain = [UIAlertAction actionWithTitle:@"重试" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [nickName becomeFirstResponder];
    }];
    UIAlertAction *comeBack = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [failedAlert addAction:tryAgain];
    [failedAlert addAction:comeBack];
    [self presentViewController:failedAlert animated:YES completion:nil];
}



@end
