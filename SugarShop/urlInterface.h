//
//  urlInterface.h
//  SweetHeart
//
//  Created by mac on 16/4/11.
//  Copyright (c) 2016年 diaoshihao. All rights reserved.
//

#ifndef SweetHeart_urlInterface_h
#define SweetHeart_urlInterface_h


#pragma mark - 登录注册
//登录 param mobile=182*****285&password=******
#define kSHLOGIN @"http://api.dantangapp.com/v1/account/signin"
//校验手机号param mobile=182*****285
#define kSHREGISTER @"http://api.dantangapp.com/v1/account/mobile_exist"
//校验token access_token=*************&mobile=182*****285
#define kSHSENDSMS @"http://api.dantangapp.com/v1/account/send_verification_code"
//接收token
#define kSHSMSTOKEN @"http://api.dantangapp.com/v1/account/sms_token"
//注册 param code=213429&mobile=18218456285
#define kSHVERIFY @"http://api.dantangapp.com/v1/account/mobile_verify"

//退出登录
#define kSHLOGOUT @"http://api.dantangapp.com/v1/account/signout"
//重置密码 param code=213429&mobile=18218456285&password=123456
#define kSHRESETPSW @"http://api.dantangapp.com/v1/account/mobile_reset_password"

//编辑资料 param nickname=1234
#define kSHEDIT @"http://api.dantangapp.com/v1/users/me"


#pragma mark - 分类
//精选
#define kSHJINGXUAN @"http://api.dantangapp.com/v1/channels/4/items?gender=1&generation=1&limit=20&offset=0"
//美食
#define kSHMEISHI @"http://api.dantangapp.com/v1/channels/14/items?gender=1&generation=1&limit=20&offset=0"
//家居
#define kSHJIAJU @"http://api.dantangapp.com/v1/channels/16/items?gender=1&generation=1&limit=20&offset=0"
//数码
#define kSHSHUMA @"http://api.dantangapp.com/v1/channels/17/items?gender=1&generation=1&limit=20&offset=0"
//美物
#define kSHMEIWU @"http://api.dantangapp.com/v1/channels/13/items?gender=1&generation=1&limit=20&offset=0"
//杂货
#define kSHZAHUO @"http://api.dantangapp.com/v1/channels/22/items?gender=1&generation=1&limit=20&offset=0"
//美护
#define kSHMEIHU @"http://api.dantangapp.com/v1/channels/15/items?gender=1&generation=1&limit=20&offset=0"
//运动
#define kSHYUNDONG @"http://api.dantangapp.com/v1/channels/18/items?gender=1&generation=1&limit=20&offset=0"


#pragma mark - 搜索
//SEARCH
#define kSHHOTWORD @"http://api.dantangapp.com/v1/search/hot_words"

#define kSHRESULT @"http://api.dantangapp.com/v1/search/item?keyword=%@&limit=20&offset=0&sort="


/**
 *  keyword is searchText(搜索关键词)
 *  sort with hot(热度) or price%3Aasc(升序) or price%3Adesc(降序)
 */
#define kSHSORT @"http://api.dantangapp.com/v1/search/item?keyword=%@&limit=20&offset=0&sort=%@"


#pragma mark - 购物
//单品
#define kSHDANPIN @"http://api.dantangapp.com/v2/items?gender=1&generation=1&limit=20&offset=0"


#pragma mark - 专题
//全部专题
#define kSHQUANBUZHUANTI @"http://api.dantangapp.com/v1/collections?limit=20&offset=0"

//=======================ID=========================
#define kSHSUBJCET @"http://api.dantangapp.com/v1/collections/%@/posts?gender=1&generation=1&limit=20&offset=0"//============

//风格/品类
#define kSHFENGGEPINLEI @"http://api.dantangapp.com/v1/channel_groups/all"

//实用神器
#define kSHSHIYONGSHENQI @"http://api.dantangapp.com/v1/collections/4/posts?gender=1&generation=1&limit=20&offset=%d"

//零食控
#define kSHLINGSHIKONG @"http://api.dantangapp.com/v1/collections/3/posts?gender=1&generation=1&limit=20&offset=%d"

//耳机盘点
#define kSHERJIPANDIAN @"http://api.dantangapp.com/v1/collections/2/posts?gender=1&generation=1&limit=20&offset=%d"

//实用指南
#define kSHSHIYONGZHINAN @"http://api.dantangapp.com/v1/collections/1/posts?gender=1&generation=1&limit=20&offset=%d"




#pragma mark - 风格
//=============ID=============
#define kSHFENGGE @"http://api.dantangapp.com/v1/channels/%@/items?limit=20&offset=0"//===============================
//风格
//创意
#define kSHCHUANGYI @"http://api.dantangapp.com/v1/channels/12/items?limit=20&offset=0"

//文艺范
#define kSHWENYIFAN @"http://api.dantangapp.com/v1/channels/19/items?limit=20&offset=0"

//设计感
#define kSHSHEJIGAN @"http://api.dantangapp.com/v1/channels/20/items?limit=20&offset=0"

//科技范
#define kSHKEJIFAN @"http://api.dantangapp.com/v1/channels/21/items?limit=20&offset=0"



#endif
