//
//  SHSubjectModel.m
//  SugarShop
//
//  Created by mac on 16/4/16.
//  Copyright © 2016年 diaoshihao. All rights reserved.
//

#import "SHSubjectModel.h"

@implementation SHSubjectModel

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        self.title = dict[@"title"];
        self.ID = dict[@"id"];
        self.cover_image_url = dict[@"cover_image_url"];
        self.subTitle = dict[@"subtitle"];
        self.banner_image_url = dict[@"banner_image_url"];
    }
    return self;
}

@end
