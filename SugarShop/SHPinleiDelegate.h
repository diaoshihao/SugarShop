//
//  SHPinleiDelegate.h
//  SweetHeart
//
//  Created by mac on 16/4/13.
//  Copyright (c) 2016年 diaoshihao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SHPinleiDelegateCallBack)(NSString *ID);

@interface SHPinleiDelegate : UICollectionViewController <UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, copy) SHPinleiDelegateCallBack block;

@end
