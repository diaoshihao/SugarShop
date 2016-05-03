//
//  SHMenuTableViewController.m
//  SugarShop
//
//  Created by mac on 16/4/19.
//  Copyright © 2016年 diaoshihao. All rights reserved.
//

#import "SHMenuTableViewController.h"
#import "SHMeViewController.h"
#import "SHLoginViewController.h"
#import "SHEditViewController.h"

@interface SHMenuTableViewController ()

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) UIImageView *headImage;
@property (nonatomic, strong) UILabel *userNameLabel;

@end

@implementation SHMenuTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];

    [self creatHeadViewForTableView];
    
    self.dataArray = @[@"我的消息",@"清除缓存",@"编辑资料",@"退出登录"];
    
    
    //查询登录状态,根据登录状态显示头像和昵称
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"login"]) {
        
        NSString *avatar_url = [[NSUserDefaults standardUserDefaults] objectForKey:@"avatar_url"];
        NSString *nickname = [[NSUserDefaults standardUserDefaults] objectForKey:@"nickname"];
        
        self.headImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:avatar_url]]];
        self.userNameLabel.text = nickname;
    }
    
    //注册观察者
    //成功登录
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(login:) name:@"login" object:nil];
    //退出登录
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logout) name:@"logout" object:nil];
    //成功注册
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(login:) name:@"register" object:nil];
    //更新成功
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(login:) name:@"reset" object:nil];
    
}

- (void)dealloc {
    //移除观察者
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"login" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"logout" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"register" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"reset" object:nil];
}

#pragma mark 响应成功登录
- (void)login:(NSNotification *)notification {
    NSDictionary *dataDict = notification.userInfo;
    if (dataDict[@"avatar_url"] != nil) {
        self.headImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:dataDict[@"avatar_url"]]]];
    }
    self.userNameLabel.text = dataDict[@"nickname"];
}

#pragma mark 响应退出登录
- (void)logout {
    
    self.headImage.image = [UIImage imageNamed:@"icon_headimge_placeholder"];
    self.userNameLabel.text = @"登录/注册";
}


#pragma mark headView
- (void)creatHeadViewForTableView {
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width * 2.0 / 3.0;
    CGFloat height = width * 2.0 / 3.0;
    UIImageView *headView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    headView.image = [UIImage imageNamed:@"Me_ProfileBackground"];
    
    self.headImage = [[UIImageView alloc] initWithFrame:CGRectMake(width / 5, height / 3, width / 5, width / 5)];
    
    //显示用户头像
    self.headImage.image = [UIImage imageNamed:@"icon_headimge_placeholder"];
    self.headImage.layer.cornerRadius = width / 5 / 2;
    self.headImage.clipsToBounds = YES;
    
    [headView addSubview:self.headImage];
    
    //用户名/昵称
    self.userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(2 * width / 5 + 10, height / 3, width - 2 * width / 5, height / 3)];
    self.userNameLabel.textColor = [UIColor whiteColor];
    self.userNameLabel.text = @"登录/注册";
    [headView addSubview:self.userNameLabel];
    
    self.tableView.tableHeaderView = headView;
    
    UIView *footView = [[UIView alloc] init];
    self.tableView.tableFooterView = footView;
    
    self.tableView.scrollEnabled = NO;
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.textLabel.text = self.dataArray[indexPath.row];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            if ([[NSUserDefaults standardUserDefaults] boolForKey:@"login"]) {
                
            }
            else {
                [self showAlert:@"你还没有登录哦"];
            }
            break;
        case 1:
            [self showAlert:@"缓存已清除"];
            break;
        case 2:
            [self jumpToEditView];
            break;
        case 3:
            
            break;
            
        default:
            break;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (void)jumpToEditView {
    SHEditViewController *editViewContrller = [[SHEditViewController alloc] init];
    UINavigationController *editNVC = [[UINavigationController alloc] initWithRootViewController:editViewContrller];
    
    [self presentViewController:editNVC animated:YES completion:nil];
}

- (void)showAlert:(NSString *)message {
    UIAlertController *tipAlert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [tipAlert addAction:action];
    [self presentViewController:tipAlert animated:YES completion:nil];
    
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
