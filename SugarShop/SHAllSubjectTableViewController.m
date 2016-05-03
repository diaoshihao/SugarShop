//
//  SHAllSubjectTableViewController.m
//  SugarShop
//
//  Created by mac on 16/4/20.
//  Copyright © 2016年 diaoshihao. All rights reserved.
//

#import "SHAllSubjectTableViewController.h"
#import "SHAllSubjectTableViewCell.h"
#import "SHSubjectModel.h"
#import "SHTools.h"
#import "SHTableViewController.h"

@interface SHAllSubjectTableViewController ()

@end

@implementation SHAllSubjectTableViewController

- (NSArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSArray new];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.tableView.frame = self.view.bounds;
    self.tableView.rowHeight = ([UIScreen mainScreen].bounds.size.height - 64) / 3.5;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"SHAllSubjectTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SHAllSubjectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    SHSubjectModel *model = self.dataArray[indexPath.row];
    [cell.coverImageView sd_setImageWithURL:[NSURL URLWithString:model.cover_image_url] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    cell.coverImageView.layer.cornerRadius = 6;
    cell.coverImageView.clipsToBounds = YES;
    cell.titleLabel.text = model.title;
    cell.subTitleLabel.text = model.subTitle;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SHSubjectModel *model = self.dataArray[indexPath.row];
    
    SHTableViewController *tableViewController = [[SHTableViewController alloc] init];
    tableViewController.url = [NSString stringWithFormat:kSHSUBJCET,model.ID];
    tableViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:tableViewController animated:YES];
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
