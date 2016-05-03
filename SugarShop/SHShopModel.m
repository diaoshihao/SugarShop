//
//  SHShopModel.m
//  SweetHeart
//
//  Created by mac on 16/4/12.
//  Copyright (c) 2016年 diaoshihao. All rights reserved.
//

#import "SHShopModel.h"

@implementation SHShopModel

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        self.title = dict[@"name"];
        self.shopDescription = dict[@"description"];
        self.price = dict[@"price"];
        self.ID = dict[@"id"];
        self.url = dict[@"url"];
        self.cover_image_url = dict[@"cover_image_url"];
        self.likes_count = dict[@"favorites_count"];
    }
    return self;
}

@end
