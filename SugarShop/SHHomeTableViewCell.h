//
//  SHHomeTableViewCell.h
//  SugarShop
//
//  Created by mac on 16/4/14.
//  Copyright © 2016年 diaoshihao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHHomeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *brandImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIImageView *likeImage;

@property (weak, nonatomic) IBOutlet UIButton *likeButton;

- (IBAction)likeOrNot:(id)sender;

@end
