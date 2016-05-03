//
//  SHMeViewController.m
//  SweetHeart
//
//  Created by mac on 16/4/11.
//  Copyright (c) 2016年 diaoshihao. All rights reserved.
//

#import "SHMeViewController.h"
#import "SHTools.h"
#import "SHLoginViewController.h"
#import "SHEditViewController.h"

#define kHeight (self.view.bounds.size.width / 2.0)

@interface SHMeViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIImageView *headImage;
@property (nonatomic, strong) UILabel *userNameLabel;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation SHMeViewController
{
    UIImageView *headBackground;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBarHidden = YES;
    
    [self initUI];
    
    //查询登录状态
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"login"]) {
        
        NSString *avatar_url = [[NSUserDefaults standardUserDefaults] objectForKey:@"avatar_url"];
        NSString *nickname = [[NSUserDefaults standardUserDefaults] objectForKey:@"nickname"];
        
        self.headImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:avatar_url]]];
        self.userNameLabel.text = nickname;
    }
    
    //注册观察者
    //登录成功
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(login:) name:@"login" object:nil];
    //注册成功
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(login:) name:@"register" object:nil];
    //更新成功
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(login:) name:@"reset" object:nil];
    
}

- (void)dealloc {
    //移除观察者
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"login" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"register" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"reset" object:nil];
}

#pragma mark 通知使用方法
- (void)login:(NSNotification *)notification {
    NSDictionary *dataDict = notification.userInfo;
    if (dataDict[@"avatar_url"] != nil) {
        self.headImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:dataDict[@"avatar_url"]]]];
    }
    self.userNameLabel.text = dataDict[@"nickname"];
}

#pragma mark - 设置UI
- (void)initUI {
    
    [self headUI];
    
}

#pragma mark 头像UI
- (void)headUI {
    
    CGFloat width = self.view.bounds.size.width;
    CGFloat height = width / 2.0;
    
    //tableView
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    
    self.tableView.contentInset = UIEdgeInsetsMake(height, 0, 0, 0);
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableView];
    
    UISegmentedControl *segmented = [[UISegmentedControl alloc] initWithItems:@[@"喜欢的商品",@"喜欢的专题"]];
    segmented.frame = CGRectMake(0, 0, width, 35);
    segmented.selectedSegmentIndex = 0;
    segmented.tintColor = [UIColor colorWithRed:255/255.0 green:112/255.0 blue:117/255.0 alpha:1];
    self.tableView.tableHeaderView = segmented;
    self.tableView.tableFooterView = [[UIView alloc] init];

    
    //背景
    headBackground = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    headBackground.image = [UIImage imageNamed:@"Me_ProfileBackground"];
    //高度改变宽度也跟着改变(不设置只会被纵向拉伸)
    headBackground.contentMode = UIViewContentModeScaleAspectFill;
    //设置autoresizesSubviews让子类自动布局
    headBackground.autoresizesSubviews = YES;
    [self.tableView addSubview:headBackground];
    
    //头像
    CGFloat headHeight = height / 3.0;
    self.headImage = [[UIImageView alloc] initWithFrame:CGRectMake(width / 2.0 - headHeight / 2.0, headHeight, headHeight, headHeight)];
    self.headImage.contentMode = UIViewContentModeScaleAspectFill;
    //自动布局，自适应顶部
    _headImage.autoresizingMask = UIViewAutoresizingFlexibleTopMargin |UIViewAutoresizingFlexibleBottomMargin;
    
    //显示用户头像
    self.headImage.image = [UIImage imageNamed:@"icon_headimge_placeholder"];
    self.headImage.layer.cornerRadius = height / 3.0 / 2;
    self.headImage.clipsToBounds = YES;
    
    self.headImage.userInteractionEnabled = YES;
    headBackground.userInteractionEnabled = YES;//！！！给头像view添加手势时，背景view手势交互也要打开，原因不明！！！
    
    //添加点击手势
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    [self.headImage addGestureRecognizer:tapGesture];
    [headBackground addSubview:self.headImage];
    
    //用户名/昵称
    self.userNameLabel = [SHTools creatUILabelWithText:@"登录/注册" frame:CGRectMake(0, height * 2 / 3, width, 30) backgroundColor:[UIColor clearColor]];
    //自动布局，自适应顶部
    self.userNameLabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    self.userNameLabel.textColor = [UIColor whiteColor];
    self.userNameLabel.textAlignment = NSTextAlignmentCenter;
    [headBackground addSubview:self.userNameLabel];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat y = scrollView.contentOffset.y;
    //    +NavigationBarHight;//根据实际选择加不加上NavigationBarHight（44、64 或者没有导航条）
    if (y < -kHeight) {
        CGRect frame = headBackground.frame;
        frame.origin.y = y;
        frame.size.height =  -y;//contentMode = UIViewContentModeScaleAspectFill时，高度改变宽度也跟着改变
        headBackground.frame = frame;
    }
}

#pragma mark 点击头像触发
- (void)tapClick:(UITapGestureRecognizer *)tap {
    
    //已登录
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"login"]) {
        
        [self showAlertSheet];
        
    }
    else {//未登录
        
        SHLoginViewController *loginViewController = [[SHLoginViewController alloc] init];
        UINavigationController *loginNVC = [[UINavigationController alloc] initWithRootViewController:loginViewController];
        //导航栏标题颜色
        loginNVC.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
        loginNVC.navigationBar.barTintColor = [UIColor colorWithRed:255/255.0 green:112/255.0 blue:117/255.0 alpha:1];
        [self presentViewController:loginNVC animated:YES completion:nil];
    }
}

#pragma mark 底部弹出窗口
- (void)showAlertSheet {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *editAction = [UIAlertAction actionWithTitle:@"编辑资料" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        SHEditViewController *editViewContrller = [[SHEditViewController alloc] init];
        UINavigationController *editNVC = [[UINavigationController alloc] initWithRootViewController:editViewContrller];
        
        [self presentViewController:editNVC animated:YES completion:nil];
        
    }];
    UIAlertAction *quitAction = [UIAlertAction actionWithTitle:@"退出登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [SHTools afPOST:kSHLOGOUT parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"login"];
            
            self.headImage.image = [UIImage imageNamed:@"icon_headimge_placeholder"];
            self.userNameLabel.text = @"登录/注册";
            
            //通知侧滑菜单改变头像和昵称
            [[NSNotificationCenter defaultCenter] postNotificationName:@"logout" object:nil userInfo:nil];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:nil];
    
    [alertController addAction:editAction];
    [alertController addAction:quitAction];
    [alertController addAction:cancel];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - tableViewDelegate&DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"login"]) {
        return self.dataArray.count;
    }
    else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
