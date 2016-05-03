//
//  SHHomeTableViewController.h
//  SweetHeart
//
//  Created by mac on 16/4/12.
//  Copyright (c) 2016年 diaoshihao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHHomeTableViewController : UITableViewController

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) NSString *url;

@property (nonatomic, strong) NSString *next_url;

@property (nonatomic) BOOL isDownRefresh;

- (void)starRequestWithUrl:(NSString *)urlStr;

- (void)refresh;

@end
