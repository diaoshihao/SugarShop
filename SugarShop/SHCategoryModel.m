//
//  SHCategoryModel.m
//  SugarShop
//
//  Created by mac on 16/4/16.
//  Copyright © 2016年 diaoshihao. All rights reserved.
//

#import "SHCategoryModel.h"

@implementation SHCategoryModel

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        self.title = dict[@"name"];
        self.ID = dict[@"id"];
        self.cover_image_url = dict[@"icon_url"];
    }
    return self;
}

@end
