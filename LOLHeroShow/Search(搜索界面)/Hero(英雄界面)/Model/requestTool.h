//
//  requestTool.h
//  LOLHeroShow
//
//  Created by tarenayj on 16/6/28.
//  Copyright © 2016年 TR. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^MyCallback)(id obj);
@interface requestTool : NSObject
+(void)requestAllHeroCallBack:(MyCallback)callback;

+(void)requestHeroNameWithHeroID:(NSString *)ID  CallBack:(MyCallback)callback;

//周免英雄
+(void)requestWeeklyHeroCallBack:(MyCallback)callback;


//我的英雄
+(void)requestQQuid:(NSString *)qquid Vaid:(NSString *)vaid HeroCallBack:(MyCallback)callback;

@end
