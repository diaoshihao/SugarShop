//
//  SHShopCollectionCell.m
//  SugarShop
//
//  Created by mac on 16/4/14.
//  Copyright © 2016年 diaoshihao. All rights reserved.
//

#import "SHShopCollectionCell.h"

@implementation SHShopCollectionCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.width)];
        self.likeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.width)];
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.width)];
        self.priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.width)];
        self.liked_countLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.width)];
    }
    return self;
}

@end
