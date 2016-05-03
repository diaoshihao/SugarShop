//
//  SHShopViewController.m
//  SweetHeart
//
//  Created by mac on 16/4/11.
//  Copyright (c) 2016年 diaoshihao. All rights reserved.
//

#import "SHShopViewController.h"
#import "SHTools.h"
#import "SHCollectionViewCell.h"
#import "SHShopModel.h"
#import "SHDetailViewController.h"

@interface SHShopViewController () <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic) BOOL isDownRefresh;//下拉刷新

@property (nonatomic, strong) NSString *next_url;//下一页url

@end

@implementation SHShopViewController
{
    UICollectionView *shopCollectionView;
}

- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

#pragma mark - collectionView Delegate
- (void)creatCollectionView {
    
    CGFloat width = ([UIScreen mainScreen].bounds.size.width -30)/2;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    
    layout.itemSize = CGSizeMake(width, width * 6 / 5);
    
    shopCollectionView = [[UICollectionView alloc] initWithFrame:[UIScreen mainScreen].bounds collectionViewLayout:layout];
    shopCollectionView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    shopCollectionView.delegate = self;
    shopCollectionView.dataSource = self;
    
    [shopCollectionView registerNib:[UINib nibWithNibName:@"SHCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    [self.view addSubview:shopCollectionView];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SHCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    cell.layer.cornerRadius = 2;
    cell.clipsToBounds = YES;
    
    SHShopModel *model = self.dataArray[indexPath.item];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:model.cover_image_url] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    cell.titleLabel.text = model.title;
    cell.priceLabel.text = [NSString stringWithFormat:@"￥%@",model.price];
    cell.liked_countLabel.text = [NSString stringWithFormat:@"%@",model.likes_count];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SHDetailViewController *detailViewController = [[SHDetailViewController alloc] init];
    detailViewController.hidesBottomBarWhenPushed = YES;
    
    SHShopModel *model = self.dataArray[indexPath.item];
    detailViewController.url = model.url;
    
    [self.navigationController pushViewController:detailViewController animated:YES];
    
}

#pragma mark 网络请求
- (void)startRequestWithUrl:(NSString *)urlStr {
    
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    if (!delegate.shouldRefresh) {
        [shopCollectionView.mj_header endRefreshing];
        [shopCollectionView.mj_footer endRefreshing];
        return;
    }
    
    [SHTools afGET:urlStr parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [shopCollectionView.mj_header endRefreshing];
        [shopCollectionView.mj_footer endRefreshing];
        
        if (self.isDownRefresh) {
            //清除原有数据
            [self.dataArray removeAllObjects];
        }
        
        if (responseObject[@"data"][@"paging"][@"next_url"] != [NSNull null]) {
            self.next_url = responseObject[@"data"][@"paging"][@"next_url"];
        }
        
        NSArray *itemsArray = responseObject[@"data"][@"items"];
        
        for (NSDictionary *dict in itemsArray) {
            NSDictionary *dataDict = dict[@"data"];
            SHShopModel *model = [[SHShopModel alloc] initWithDictionary:dataDict];
            [self.dataArray addObject:model];
        }
        
        [shopCollectionView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

#pragma mark 上下拉刷新
- (void)refresh {

    shopCollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        self.isDownRefresh = YES;
        [self startRequestWithUrl:kSHDANPIN];
        
    }];
    
    shopCollectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        self.isDownRefresh = NO;
    
        [self startRequestWithUrl:self.next_url];
        
    }];
    
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    if (delegate.shouldRefresh) {
        
        [shopCollectionView.mj_header beginRefreshing];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupLeftMenuButton];
    
    self.next_url = kSHDANPIN;
    
    [self creatCollectionView];
    
    [self refresh];
}

#pragma mark 侧滑菜单按钮
- (void)setupLeftMenuButton {
    MMDrawerBarButtonItem *button = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftDrawerButtonPress:)];
    [self.navigationItem setLeftBarButtonItem:button animated:YES];
}

- (void)leftDrawerButtonPress:(id)sender {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
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
