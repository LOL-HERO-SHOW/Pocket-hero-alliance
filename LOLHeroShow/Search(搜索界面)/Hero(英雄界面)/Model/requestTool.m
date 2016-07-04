//
//  requestTool.m
//  LOLHeroShow
//
//  Created by tarenayj on 16/6/28.
//  Copyright © 2016年 TR. All rights reserved.
//

#import "requestTool.h"
#import <AFNetworking.h>

@implementation requestTool

+(void)requestAllHeroCallBack:(MyCallback)callback
{
    
    NSString *path = [NSString stringWithFormat:@"http://lolapi.games-cube.com/Champion"];//路径
    
    NSDictionary *params = @{};//参数
    
    AFHTTPSessionManager *manager =[AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //[manager.requestSerializer setValue:@"DAIWAN-API-TOKEN" forHTTPHeaderField:@"JBVWJ-KCMUY-GVWLG-VZQBC"];
    
    [manager.requestSerializer setValue:[NSString stringWithFormat:TOKEN] forHTTPHeaderField:@"DAIWAN-API-TOKEN"];
    
    [manager GET:path parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        
        
        NSArray *arr = dic[@"data"];
        
              
        callback(arr);
       
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败%@",error);
        
    }];
    
    
    
    
}


//根据英雄ID 请求英雄信息
+(void)requestHeroNameWithHeroID:(NSString *)ID  CallBack:(MyCallback)callback
{
    NSString *pathAddID = [NSString stringWithFormat:@"http://lolapi.games-cube.com/GetChampionCNName?id=%@",ID];
    NSString *path = pathAddID;//路径
    
    NSDictionary *params = @{};//参数
    
    AFHTTPSessionManager *manager =[AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //[manager.requestSerializer setValue:@"DAIWAN-API-TOKEN" forHTTPHeaderField:@"JBVWJ-KCMUY-GVWLG-VZQBC"];
    
    [manager.requestSerializer setValue:[NSString stringWithFormat:TOKEN] forHTTPHeaderField:@"DAIWAN-API-TOKEN"];
    
    [manager GET:path parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        
        
        NSArray *arr = dic[@"data"];
        
        callback(arr);
        
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败%@",error);
        
    }];
    

}


//周免
+(void)requestWeeklyHeroCallBack:(MyCallback)callback
{
   
    NSString *path =  @"http://lolapi.games-cube.com/Free";//路径
    
    NSDictionary *params = @{};//参数
    
    AFHTTPSessionManager *manager =[AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //[manager.requestSerializer setValue:@"DAIWAN-API-TOKEN" forHTTPHeaderField:@"JBVWJ-KCMUY-GVWLG-VZQBC"];
    
    [manager.requestSerializer setValue:[NSString stringWithFormat:TOKEN] forHTTPHeaderField:@"DAIWAN-API-TOKEN"];
    
    [manager GET:path parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        
        
        NSArray *arr = dic[@"data"];
       
        callback(arr);
        
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败%@",error);
        
    }];
    
    
}

//我的英雄
+(void)requestQQuid:(NSString *)qquid Vaid:(NSString *)vaid HeroCallBack:(MyCallback)callback
{
    
    NSString *path = [NSString stringWithFormat:@"http://lolapi.games-cube.com/UserExtInfo?qquin=%@&vaid=%@",qquid,vaid];//路径
    
    NSDictionary *params = @{};//参数
    
    AFHTTPSessionManager *manager =[AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //[manager.requestSerializer setValue:@"DAIWAN-API-TOKEN" forHTTPHeaderField:@"JBVWJ-KCMUY-GVWLG-VZQBC"];
    
    [manager.requestSerializer setValue:[NSString stringWithFormat:TOKEN] forHTTPHeaderField:@"DAIWAN-API-TOKEN"];
    
    [manager GET:path parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
       
        
        NSArray *arr = dic[@"data"];
        
        callback(arr);
        
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败%@",error);
        
    }];
    
    
}


@end
