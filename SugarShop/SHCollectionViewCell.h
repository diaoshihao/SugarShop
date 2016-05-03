//
//  SHCollectionViewCell.h
//  SugarShop
//
//  Created by mac on 16/4/14.
//  Copyright © 2016年 diaoshihao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *liked_countLabel;

@end
