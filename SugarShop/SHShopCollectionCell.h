//
//  SHShopCollectionCell.h
//  SugarShop
//
//  Created by mac on 16/4/14.
//  Copyright © 2016年 diaoshihao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHShopCollectionCell : UICollectionViewCell

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *priceLabel;
@property (nonatomic, strong) UIImageView *likeImageView;
@property (strong, nonatomic) UILabel *liked_countLabel;

@end
