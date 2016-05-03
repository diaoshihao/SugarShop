//
//  SHHomeViewController.m
//  SweetHeart
//
//  Created by mac on 16/4/11.
//  Copyright (c) 2016年 diaoshihao. All rights reserved.
//

#import "SHHomeViewController.h"
#import "SHTools.h"
#import "SHHomeTableViewController.h"

@interface SHHomeViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *shHomeScrollview;

@property (nonatomic, strong) UIView *redBarView;

@end

@implementation SHHomeViewController
{
    CGFloat buttonWidth;
}


- (SHHomeTableViewController *)creatTableVC {
    SHHomeTableViewController *VC = [[SHHomeTableViewController alloc] init];
    [self.shHomeScrollview addSubview:VC.tableView];
    [self addChildViewController:VC];
    return VC;
}

- (void)addViewToScrollView {
    
    NSMutableArray *VCArray = [[NSMutableArray alloc] init];
    
    for (NSInteger i = 0; i < 6; i++) {
        
        [VCArray addObject:[self creatTableVC]];
        
    }
    
    NSArray *urlArray = @[kSHJINGXUAN,kSHMEISHI,kSHJIAJU,kSHSHUMA,kSHMEIWU,kSHZAHUO];
    
    for (NSInteger i = 0; i < 6; i++) {
        
        SHHomeTableViewController *VC = (SHHomeTableViewController *)VCArray[i];
        VC.url = urlArray[i];
        VC.next_url = urlArray[i];
        VC.tableView.frame = CGRectMake(self.view.bounds.size.width * i, 0, self.view.bounds.size.width, self.view.bounds.size.height - 138);
        
    }
}

- (void)creatUIButton {
    
    NSArray *titleArray = @[@"精选",@"美食",@"家居",@"数码",@"美物",@"杂货"];
    
    for (NSInteger i = 0; i < 6; i++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(10 + buttonWidth * i, 64, buttonWidth, 30);
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        if (i == 0) {
            [button setTitleColor:[UIColor colorWithRed:255/255.0 green:112/255.0 blue:117/255.0 alpha:1] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:18];
        }
        else {
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:17];
        }
        button.tag = i + 1;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
}

- (void)creatScrollView {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    self.shHomeScrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 96, width, height - 140)];
    
    self.shHomeScrollview.contentSize = CGSizeMake(self.view.bounds.size.width * 6, 0);
    self.shHomeScrollview.showsHorizontalScrollIndicator = NO;
    self.shHomeScrollview.pagingEnabled = YES;
    self.shHomeScrollview.delegate = self;
    
    [self.view addSubview:self.shHomeScrollview];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupLeftMenuButton];
    
    buttonWidth = ([UIScreen mainScreen].bounds.size.width - 70) / 6;
    
    [self creatUIButton];
    self.redBarView = [[UIView alloc] initWithFrame:CGRectMake(17, 94, 30, 2)];
    self.redBarView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.redBarView];
    [self creatScrollView];
    
    [self addViewToScrollView];
    
}

#pragma mark 侧滑菜单按钮
- (void)setupLeftMenuButton {
    MMDrawerBarButtonItem *button = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftDrawerButtonPress:)];
    [self.navigationItem setLeftBarButtonItem:button animated:YES];
}

- (void)leftDrawerButtonPress:(id)sender {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    [UIView animateWithDuration:0.25 animations:^{
        
        NSInteger index = scrollView.contentOffset.x / [UIScreen mainScreen].bounds.size.width;
        CGRect frame = self.redBarView.frame;
        frame.origin.x = index * buttonWidth + 17;
        self.redBarView.frame = frame;
    }];
}

- (void)buttonClick:(UIButton *)sender {
    
    for (NSInteger i = 1; i <= 6; i++) {
        UIButton *button = (UIButton *)[self.view viewWithTag:i];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:17];
    }
    
    [sender setTitleColor:[UIColor colorWithRed:255/255.0 green:112/255.0 blue:117/255.0 alpha:1] forState:UIControlStateNormal];
    sender.titleLabel.font = [UIFont systemFontOfSize:18];
    
    [UIView animateWithDuration:0.25 animations:^{
        CGRect frame = self.redBarView.frame;
        frame.origin.x = (sender.tag - 1) * 56 + 17;
        self.redBarView.frame = frame;
        
        self.shHomeScrollview.contentOffset = CGPointMake((sender.tag - 1) * [UIScreen mainScreen].bounds.size.width, 0);
        
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
