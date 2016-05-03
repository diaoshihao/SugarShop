//
//  SHHomeTableViewController.m
//  SweetHeart
//
//  Created by mac on 16/4/12.
//  Copyright (c) 2016年 diaoshihao. All rights reserved.
//

#import "SHHomeTableViewController.h"
#import "SHTools.h"
#import "SHBaceModel.h"
#import "SHHomeTableViewCell.h"
#import "SHDetailViewController.h"

@interface SHHomeTableViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UIScrollView *shHomeScrollview;


@end

@implementation SHHomeTableViewController

- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}
#pragma mark -
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
        for (NSDictionary *dict in dataDict[@"items"]) {
            SHBaceModel *model = [[SHBaceModel alloc] initWithDictionary:dict];
            [self.dataArray addObject:model];
        }
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

#pragma mark 上下拉刷新
- (void)refresh {
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    
    //上拉刷新
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        self.isDownRefresh = NO;
        [self starRequestWithUrl:self.next_url];

    }];
    
    //下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        self.isDownRefresh = YES;
        [self starRequestWithUrl:self.url];

    }];
    
    if (appDelegate.shouldRefresh) {
        [self.tableView.mj_header beginRefreshing];
    }
    
}

#pragma mark -
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SHHomeTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self refresh];
        
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;sh
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [UIScreen mainScreen].bounds.size.width / 2.0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SHHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    // Configure the cell...
    SHBaceModel *model = self.dataArray[indexPath.row];
    [cell.brandImageView sd_setImageWithURL:[NSURL URLWithString:model.cover_image_url] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    cell.brandImageView.layer.cornerRadius = 6;
    cell.brandImageView.clipsToBounds = YES;
    cell.titleLabel.text = model.title;
    cell.countLabel.text = [NSString stringWithFormat:@"%@",model.likes_count];
    cell.backView.layer.cornerRadius = 10;
    cell.backView.clipsToBounds = YES;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SHDetailViewController *detailViewController = [[SHDetailViewController alloc] init];
    detailViewController.hidesBottomBarWhenPushed = YES;
    
    SHBaceModel *model = self.dataArray[indexPath.row];
    detailViewController.url = model.content_url;
    
    [self.navigationController pushViewController:detailViewController animated:YES];
    
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
