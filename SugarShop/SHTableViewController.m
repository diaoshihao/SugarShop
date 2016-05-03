//
//  SHTableViewController.m
//  SugarShop
//
//  Created by mac on 16/4/18.
//  Copyright © 2016年 diaoshihao. All rights reserved.
//

#import "SHTableViewController.h"
#import "SHHomeTableViewCell.h"
#import "SHDetailViewController.h"
#import "SHBaceModel.h"
#import "SHTools.h"

@interface SHTableViewController () <UITableViewDelegate,UITableViewDataSource>

@end

@implementation SHTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark 请求网络数据
- (void)starRequestWithUrl:(NSString *)urlStr {
    
    //根据网络状态选择是否允许请求数据
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    if (!delegate.shouldRefresh) {
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        return;
    }
    
    //请求数据
    [SHTools afGET:urlStr parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        
        if (self.isDownRefresh) {
            [self.dataArray removeAllObjects];
        }
        
        if (responseObject[@"data"][@"paging"][@"next_url"] != [NSNull null]) {
            self.next_url = responseObject[@"data"][@"paging"][@"next_url"];
        }
        
        NSDictionary *dataDict = responseObject[@"data"];
        for (NSDictionary *dict in dataDict[@"posts"]) {
            SHBaceModel *model = [[SHBaceModel alloc] initWithDictionary:dict];
            [self.dataArray addObject:model];
        }
        [self.tableView reloadData];
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
