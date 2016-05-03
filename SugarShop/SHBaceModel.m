//
//  SHBaceModel.m
//  SweetHeart
//
//  Created by mac on 16/4/12.
//  Copyright (c) 2016年 diaoshihao. All rights reserved.
//

#import "SHBaceModel.h"

@implementation SHBaceModel

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        self.title = dict[@"title"];
        self.content_url = dict[@"content_url"];
        self.ID = dict[@"id"];
        self.cover_image_url = dict[@"cover_image_url"];
        self.likes_count = dict[@"likes_count"];
    }
    return self;
}

@end
