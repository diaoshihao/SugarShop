//
//  SHDetailViewController.m
//  SweetHeart
//
//  Created by mac on 16/4/13.
//  Copyright (c) 2016年 diaoshihao. All rights reserved.
//

#import "SHDetailViewController.h"

@interface SHDetailViewController ()

@end

@implementation SHDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
        
    self.title = @"商品详情";
    UIWebView *webView = [[UIWebView alloc] init];
    webView.frame = self.view.bounds;
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    
    [self.view addSubview:webView];
    
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
