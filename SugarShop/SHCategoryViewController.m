//
//  CategoryViewController.m
//  SugarShop
//
//  Created by mac on 16/4/25.
//  Copyright © 2016年 diaoshihao. All rights reserved.
//

#import "SHCategoryViewController.h"
#import "SHTools.h"
#import "SHFenggeDelegate.h"
#import "SHPinleiDelegate.h"
#import "SHSubjectModel.h"
#import "SHCategoryModel.h"
#import "SHTableViewController.h"
#import "SHAllSubjectTableViewController.h"

@interface SHCategoryViewController () <UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UITableView *tableView;

@property (strong, nonatomic) UIScrollView *subjectScrollView;
@property (strong, nonatomic) UICollectionView *fenggeCollectionView;
@property (strong, nonatomic) UICollectionView *pinleiCollectionView;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *subjectArray;

@end

@implementation SHCategoryViewController
{
    SHFenggeDelegate *fenggeDelegate;
    SHPinleiDelegate *pinleiDelegate;
    NSArray *titleArray;
}


- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (NSMutableArray *)subjectArray {
    if (_subjectArray == nil) {
        _subjectArray = [[NSMutableArray alloc] init];
    }
    return _subjectArray;
}

#pragma mark 网络请求
- (void)startRequestWithSubjectUrl:(NSString *)subjectUrl othersUrl:(NSString *)othersUrl {
    //专题合集
    [SHTools afGET:subjectUrl parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSArray *collectionArray = responseObject[@"data"][@"collections"];
        for (NSDictionary *dict in collectionArray) {
            SHSubjectModel *model = [[SHSubjectModel alloc] initWithDictionary:dict];
            [self.subjectArray addObject:model];
        }
        
        [self scrollViewSetting];
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    //风格和品类数据
    [SHTools afGET:othersUrl parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSArray *groupsArray = responseObject[@"data"][@"channel_groups"];
        
        for (NSDictionary *channelDict in groupsArray) {
            NSArray *itemsArray = channelDict[@"channels"];
            NSMutableArray *dictArray = [[NSMutableArray alloc] init];
            for (NSDictionary *dict in itemsArray) {
                SHCategoryModel *model = [[SHCategoryModel alloc] initWithDictionary:dict];
                [dictArray addObject:model];
            }
            [self.dataArray addObject:dictArray];
        }
        
        fenggeDelegate.dataArray = self.dataArray[0];
        pinleiDelegate.dataArray = self.dataArray[1];
        [self.fenggeCollectionView reloadData];
        [self.pinleiCollectionView reloadData];
        
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}

#pragma mark 设置collectionview的代理
- (void)collectionviewSetting {
    
    CGFloat width = ([UIScreen mainScreen].bounds.size.width - 80) / 4;
    
    UICollectionViewFlowLayout *fenggeLayout = [[UICollectionViewFlowLayout alloc] init];
    fenggeLayout.itemSize = CGSizeMake(width, width + 20);
    fenggeLayout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
    
    self.fenggeCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, width + 20) collectionViewLayout:fenggeLayout];
    self.fenggeCollectionView.backgroundColor = [UIColor whiteColor];
    
    UICollectionViewFlowLayout *pinleiLayout = [[UICollectionViewFlowLayout alloc] init];
    pinleiLayout.itemSize = CGSizeMake(width, width + 20);
    pinleiLayout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
    self.pinleiCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 2 * (width + 20) +10) collectionViewLayout:pinleiLayout];
    self.pinleiCollectionView.backgroundColor = [UIColor whiteColor];
    
    fenggeDelegate = [[SHFenggeDelegate alloc] init];
    pinleiDelegate = [[SHPinleiDelegate alloc] init];
    
    self.fenggeCollectionView.delegate = fenggeDelegate;
    self.fenggeCollectionView.dataSource = fenggeDelegate;
    
    self.pinleiCollectionView.delegate = pinleiDelegate;
    self.pinleiCollectionView.dataSource = pinleiDelegate;
    
    [self.fenggeCollectionView registerNib:[UINib nibWithNibName:@"SHCategoryCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    [self.pinleiCollectionView registerNib:[UINib nibWithNibName:@"SHCategoryCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    
}

#pragma mark 设置专题scrollView
- (void)scrollViewSetting {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = width / 5.5;
    self.subjectScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    CGFloat imageWidth = height * 2;
    for (NSInteger i = 0; i < self.subjectArray.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10 + i * (10 + imageWidth), 0, imageWidth, height)];
        SHSubjectModel *model = self.subjectArray[i];
        [imageView sd_setImageWithURL:[NSURL URLWithString:model.banner_image_url] placeholderImage:[UIImage imageNamed:@"placeholder"]];
        imageView.layer.cornerRadius = 6;
        imageView.clipsToBounds = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)];
        [imageView addGestureRecognizer:tap];
        imageView.userInteractionEnabled = YES;
        
        [self.subjectScrollView addSubview:imageView];
    }
    
    self.subjectScrollView.showsHorizontalScrollIndicator = NO;
    self.subjectScrollView.contentSize = CGSizeMake(10 + self.subjectArray.count * (imageWidth + 10), height);
}

#pragma mark 点击专题图片
- (void)tapImage:(UITapGestureRecognizer *)tap {
    NSInteger index = (tap.view.frame.origin.x - 10) / (NSInteger)(tap.view.frame.size.width + 10);
    SHSubjectModel *model = self.subjectArray[index];
    
    SHTableViewController *tableViewController = [[SHTableViewController alloc] init];
    tableViewController.url = [NSString stringWithFormat:kSHSUBJCET,model.ID];
    tableViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:tableViewController animated:YES];
    
}

- (void)pushViewControllerWithID:(NSString *)ID {
    SHHomeTableViewController *tableViewController = [[SHHomeTableViewController alloc] init];
    tableViewController.url = [NSString stringWithFormat:kSHFENGGE,ID];
    tableViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:tableViewController animated:YES];
}

#pragma mark 侧滑菜单按钮
- (void)setupLeftMenuButton {
    MMDrawerBarButtonItem *button = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftDrawerButtonPress:)];
    [self.navigationItem setLeftBarButtonItem:button animated:YES];
}

- (void)leftDrawerButtonPress:(id)sender {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

#pragma mark 初始化UI
- (void)initUI {
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:self.tableView];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupLeftMenuButton];
    
    [self collectionviewSetting];
    
    titleArray = @[@"专题合集",@"风格",@"品类"];
    [self initUI];
    
    self.fenggeCollectionView.scrollEnabled = NO;
    self.pinleiCollectionView.scrollEnabled = NO;
    
    [self startRequestWithSubjectUrl:kSHQUANBUZHUANTI othersUrl:kSHFENGGEPINLEI];
    
    
    __weak SHCategoryViewController *weakSelf = self;
    
    [fenggeDelegate setBlock:^(NSString *ID) {
        [weakSelf pushViewControllerWithID:ID];
    }];
    
    [pinleiDelegate setBlock:^(NSString *ID) {
        [weakSelf pushViewControllerWithID:ID];
    }];
}

#pragma mark - tableView代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return self.subjectScrollView.frame.size.height + 10;
    }
    else if (indexPath.section == 1) {
        return self.fenggeCollectionView.frame.size.height + 10;
    }
    else if (indexPath.section == 2) {
        return self.pinleiCollectionView.frame.size.height + 20;
    }
    else {
        return 44;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 30)];
    view.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 30)];
    label.text = titleArray[section];
    [view addSubview:label];
    if (section == 0) {
        UIButton *checkAll = [UIButton buttonWithType:UIButtonTypeSystem];
        checkAll.frame = CGRectMake(self.view.bounds.size.width - 80, 0, 60, 30);
        [checkAll setTitle:@"查看全部" forState:UIControlStateNormal];
        [checkAll setTitleColor:[UIColor colorWithRed:255/255.0 green:112/255.0 blue:117/255.0 alpha:1] forState:UIControlStateNormal];
        [checkAll addTarget:self action:@selector(checkAll:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:checkAll];
    }
    return view;
}
#pragma mark 查看全部专题
- (void)checkAll:(UIButton *)sender {
    SHAllSubjectTableViewController *allSubjectVC = [[SHAllSubjectTableViewController alloc] init];
    allSubjectVC.dataArray = self.subjectArray;
    allSubjectVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:allSubjectVC animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
//    [self scrollViewSetting];
//    [self collectionviewSetting];
    if (indexPath.section == 0) {
        [cell.contentView addSubview:self.subjectScrollView];
    }
    else if (indexPath.section == 1) {
        [cell.contentView addSubview:self.fenggeCollectionView];
    }
    else if (indexPath.section == 2) {
        [cell.contentView addSubview:self.pinleiCollectionView];
    }
    else;
    
    return cell;
}


@end
