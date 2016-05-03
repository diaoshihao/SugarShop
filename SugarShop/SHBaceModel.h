//
//  SHBaceModel.h
//  SweetHeart
//
//  Created by mac on 16/4/12.
//  Copyright (c) 2016年 diaoshihao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHBaceModel : NSObject

@property (nonatomic, strong) NSString *content_url;
@property (nonatomic, strong) NSString *cover_image_url;
@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *likes_count;
@property (nonatomic, strong) NSString *title;


- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
