//
//  HeroShowHubView.m
//  LOLHeroShow
//
//  Created by tarenayj on 16/6/26.
//  Copyright © 2016年 TR. All rights reserved.
//

#import "HeroShowHubView.h"
#import "requestTool.h"
#import <UIImageView+AFNetworking.h>
#define SCROLLWIDTH self.scrollView.frame.size.width



//表格的cell
#import "MyHeroTableViewCell.h"
#import "AllHeroTableViewCell.h"
#import "WeeklyFreeHeroTableViewCell.h"

@interface HeroShowHubView ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *myHero;
@property (weak, nonatomic) IBOutlet UITableView *weeklyHero;
@property (weak, nonatomic) IBOutlet UITableView *allHero;


@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
//滚动视图 切换按钮 (用于设置 按钮选中状态)
@property (weak, nonatomic) IBOutlet UIButton *myHeroButton;

@property (weak, nonatomic) IBOutlet UIButton *weeklyButton;

@property (weak, nonatomic) IBOutlet UIButton *allHeroButton;




//data =     (
//            {
//                "avg_a_num" = 1008;
//                "avg_d_num" = 749;
//                "avg_k_num" = 795;
//                "champion_id" = 64;
//                "gold_earned_per_min" = 36809;
//                kda = 722;
//                "minions_killed_per_min" = 319;
//                rank = 1;
//                "use_ratio" = 456;
//                "win_ratio" = 4708;
//            },

//请求回来的全英雄列表 里面装着字典
@property (strong, nonatomic)NSArray *AllHeroArr;

//周免
@property (strong, nonatomic)NSArray *WeeklyHeroArr;

//用户(我的)英雄
@property(strong,nonatomic)NSArray *MyHeroArr;
@end

@implementation HeroShowHubView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    
    
    
    //分别代理 数据源 设置为 类 为何不行
//    myHeroTableView *my=[myHeroTableView new];
//   self.myHero.delegate = my;
//    self.myHero.dataSource = my;
//    
//    weeklyFreeHeroTableView *week = [weeklyFreeHeroTableView new];
//    self.weeklyHero.delegate = week;
//    self.weeklyHero.dataSource = week;
//    
//    AllHeroTableView *all = [AllHeroTableView new];
//   self.allHero.delegate = all;
//    self.allHero.dataSource = all;
    
//    请求全英雄数据
    [requestTool requestAllHeroCallBack:^(id obj) {
       
        self.AllHeroArr = obj;
    
        
        
        [self.allHero reloadData];
        
    }];
  
    //请求周免英雄数据
    [requestTool requestWeeklyHeroCallBack:^(id obj) {
        
        
        NSArray *tmp = obj;
        NSDictionary *tmpd = tmp[0];
        NSMutableArray *heroarr = [NSMutableArray array];
        NSArray *allkeys = [tmpd allKeys];
        for (NSString *key in allkeys  ) {
            
            [heroarr addObject:tmpd[key]];
            
        }
        
        self.WeeklyHeroArr = heroarr;
        
        [self.weeklyHero reloadData];

        
    }];
    
    //请求我的英雄数据
    
    [requestTool requestQQuid:@"U13267560124171473800" Vaid:@"22" HeroCallBack:^(id obj) {
        
        NSArray *arr  = obj;
        NSDictionary *myd = arr[3];
        self.MyHeroArr = myd[@"champion_list"];
        [self.myHero reloadData];
    }];
    
    
    //设置滚动view
    self.scrollView.contentSize = CGSizeMake(3*SCROLLWIDTH,1);//内容高度=0 没有垂直滚动  self.view.frame.size.height-100
    
    self.myHero.frame = CGRectMake(0, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
    [self.scrollView addSubview:self.myHero];
    
    self.weeklyHero.frame = CGRectMake(SCROLLWIDTH, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
     [self.scrollView addSubview:self.weeklyHero];
    
    
    
    self.allHero.frame = CGRectMake(SCROLLWIDTH*2, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
     [self.scrollView addSubview:self.allHero];
    //进页面 我的英雄 按钮 是选中的 显示 我的英雄tableview
    self.myHeroButton.selected = YES;
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





//滚动视图 切换按钮

- (IBAction)myHeroButton:(id)sender {
    
    
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    
//  self.myHeroButton.selected = YES;
//   self.weeklyButton.selected = NO;
//    self.allHeroButton.selected = NO;

}

- (IBAction)weeklyHeroButton:(id)sender {
    [self.scrollView setContentOffset:CGPointMake(SCROLLWIDTH, 0) animated:NO];
//    self.myHeroButton.selected = NO;
//    self.weeklyButton.selected = YES;
//    self.allHeroButton.selected = NO;
 
}

- (IBAction)allHeroButton:(id)sender {
    [self.scrollView setContentOffset:CGPointMake(SCROLLWIDTH*2, 0) animated:NO];
//    self.myHeroButton.selected = NO;
//    self.weeklyButton.selected = NO;
//    self.allHeroButton.selected = YES;
}

//滚动视图 发生改变的时候(代理方法) 改变按钮的选中状态
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //只有当 主scollview 滚动的时候 才改变(taibleview 也是scrollview  所以要限定是 主scollvew)
    if (self.scrollView.contentOffset.x==0) {
        self.myHeroButton.selected = YES;
        self.weeklyButton.selected = NO;
        self.allHeroButton.selected = NO;

        
    }else if (self.scrollView.contentOffset.x==SCROLLWIDTH) {
        self.myHeroButton.selected = NO;
        self.weeklyButton.selected = YES;
        self.allHeroButton.selected = NO;
        
    }else if (self.scrollView.contentOffset.x==SCROLLWIDTH*2) {
        self.myHeroButton.selected = NO;
        self.weeklyButton.selected = NO;
        self.allHeroButton.selected = YES;

        
    }
    
}

//表格数据设置
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //tag 0 是我的英雄 ,1 是周免 2 是全英雄
    if (tableView.tag == 2) {
        //全英雄来设置行数
        
        return self.AllHeroArr.count/2;
    }
    if (tableView.tag == 1) {
               return self.WeeklyHeroArr.count/2;
    }
   
    if (tableView.tag == 0) {
        NSLog(@"-----%ld",self.MyHeroArr.count);
        return self.MyHeroArr.count;
    }

    
    
//    if ([self.allHero isEqual:tableView]) //方法:222222
//    {
//                //全英雄来设置行数
//                      return self.AllHeroArr.count;
//            }

    return 3;

}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.myHero isEqual:tableView]) {//我的英雄表设置
        
    
    MyHeroTableViewCell *cell = [MyHeroTableViewCell cellForTableview:tableView];
        
        NSString *champion_id =   self.MyHeroArr[indexPath.row][@"champion_id"];
        
        [requestTool requestHeroNameWithHeroID:champion_id CallBack:^(id obj) {
            
            NSArray *arr = obj;
            NSDictionary *ddd = arr[0];
            
            cell.HeroName.text = ddd[@"return"];
            [cell.layer needsLayout];
            
        }];
        
        cell.HeroNickName.text= [self.MyHeroArr[indexPath.row][@"champion_id"] stringValue];
        cell.UseTimes.text = [self.MyHeroArr[indexPath.row][@"use_num"] stringValue];
        cell.WinRate.text = [self.MyHeroArr[indexPath.row][@"win_num"] stringValue];
        
        NSString *imagePath = [NSString stringWithFormat:@"http://cdn.tgp.qq.com/pallas/images/champions_id/%@.png",champion_id];
        [cell.HeroImageView setImageWithURL:[NSURL URLWithString:imagePath]];
        
        //添加点击事件
        cell.HeroImageView.tag = champion_id.intValue;//用tag值传参数到点击事件里面
        cell.HeroImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(UesrClicked:)];
        [cell.HeroImageView addGestureRecognizer:singleTap];

        
    
    return cell;
    }else
    if ([self.weeklyHero isEqual:tableView]) {//周免英雄表设置
        
        
        WeeklyFreeHeroTableViewCell *cell = [WeeklyFreeHeroTableViewCell cellForTableview:tableView];
        
       NSDictionary *wdic1 = self.WeeklyHeroArr[indexPath.row*2];
       
        cell.LeftHeroTypeLabel.text = wdic1[@"name"];
        cell.LeftNameLabel.text = wdic1[@"title"];
        cell.LeftNickNameLabel.text = wdic1[@"name"];
        //添加点击事件
        cell.LeftImageview.tag = [wdic1[@"key"] intValue];//用tag值传参数到点击事件里面 把英雄id
        cell.LeftImageview.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTap1 =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(UesrClicked:)];
        [cell.LeftImageview addGestureRecognizer:singleTap1];

        
        
        NSString *imagePath1 = [NSString stringWithFormat:@"http://cdn.tgp.qq.com/pallas/images/champions_id/%@.png",wdic1[@"key"]];
        [cell.LeftImageview setImageWithURL:[NSURL URLWithString:imagePath1]];

    //*******************************************
        NSDictionary *wdic2 = self.WeeklyHeroArr[indexPath.row*2+1];
        cell.RightHeroTypeLabel.text = wdic2[@"name"];
        cell.RightNameLabel.text = wdic2[@"title"];
        cell.RightNickNameLabel.text = wdic2[@"name"];
        
        
        //添加点击事件
        cell.RightImageview.tag = [wdic2[@"key"] intValue];//用tag值传参数到点击事件里面 把英雄id
        cell.RightImageview.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTap2 =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(UesrClicked:)];
        [cell.RightImageview addGestureRecognizer:singleTap2];
        
        
        
        NSString *imagePath2 = [NSString stringWithFormat:@"http://cdn.tgp.qq.com/pallas/images/champions_id/%@.png",wdic2[@"key"]];
        [cell.RightImageview setImageWithURL:[NSURL URLWithString:imagePath2]];
        
        return cell;
        
        
        
    }else
        {//所有英雄表设置
        //因为和weekly 的 cell 一样 所以复用
            WeeklyFreeHeroTableViewCell *cell = [WeeklyFreeHeroTableViewCell cellForTableview:tableView];
            
                //一行 2个英雄   所以  有 count/2 行
            
                
                NSDictionary *dic1 = self.AllHeroArr[indexPath.row*2+1];
                
                
                NSString *champion_id = [dic1[@"champion_id"] stringValue];
                cell.LeftHeroTypeLabel.text = [NSString stringWithFormat:@"英雄ID:%@",champion_id];
                
                NSString *imagePath = [NSString stringWithFormat:@"http://cdn.tgp.qq.com/pallas/images/champions_id/%@.png",champion_id];
                [cell.LeftImageview setImageWithURL:[NSURL URLWithString:imagePath]];
                
              //添加点击事件
            cell.LeftImageview.tag = champion_id.intValue;//用tag值传参数到点击事件里面
            cell.LeftImageview.userInteractionEnabled = YES;
            UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(UesrClicked:)];
            [cell.LeftImageview addGestureRecognizer:singleTap];
            
            
            __block NSString *name = nil;
            
            [requestTool requestHeroNameWithHeroID:champion_id CallBack:^(id obj) {
                
                NSArray *arr = obj;
                NSDictionary *ddd = arr[0];
                name = ddd[@"return"];
                cell.LeftNameLabel.text = name;
                [cell.layer needsLayout];
                
            }];
           
            
            NSNumber *s = dic1[@"win_ratio"];
            float win = s.floatValue/100.0;
            
            cell.LeftNickNameLabel.text = [NSString stringWithFormat:@"胜率:%lg", win];

            
            
            
            if (indexPath.row<self.AllHeroArr.count) {
                NSDictionary *dic2 = self.AllHeroArr[indexPath.row*2+2];
                
                NSString *champion_id = [dic2[@"champion_id"] stringValue];
                cell.RightHeroTypeLabel.text = [NSString stringWithFormat:@"英雄ID:%@",champion_id];
                
                NSString *imagePath = [NSString stringWithFormat:@"http://cdn.tgp.qq.com/pallas/images/champions_id/%@.png",champion_id];
             
                 cell.RightImageview.tag = champion_id.intValue;//用tag值传参数到点击事件里面
                [cell.RightImageview setImageWithURL:[NSURL URLWithString:imagePath]];
                
                //添加点击事件
                cell.RightImageview.userInteractionEnabled = YES;
                UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(UesrClicked:)];
                
                [cell.RightImageview addGestureRecognizer:singleTap];
                
                __block NSString *name = nil;
                
                [requestTool requestHeroNameWithHeroID:champion_id CallBack:^(id obj) {
                    
                    NSArray *arr = obj;
                    NSDictionary *ddd = arr[0];
                    name = ddd[@"return"];
                    cell.RightNameLabel.text = name;
                    [cell.layer needsLayout];
                    
                }];
                //胜率
                
                NSNumber *s = dic2[@"win_ratio"];
                float win = s.floatValue/100.0;
                
                cell.RightNickNameLabel.text = [NSString stringWithFormat:@"胜率:%lg", win];
            }
          
                //http://cdn.tgp.qq.com/pallas/images/champions_id/101.png 英雄头像
        
        
        return cell;
    }

    
    
    
    
}


-(void)UesrClicked:(UITapGestureRecognizer *)singleTap
{
    UIImageView *iv = (UIImageView *)singleTap.view;//获得点击事件所在的view
    NSLog(@"英雄id%ld",iv.tag);
    //此时的tag 代表 英雄id
}











-(NSString *)heroName:( NSString *)champion_id
{
   __block NSString* name = nil;
 [requestTool requestHeroNameWithHeroID:champion_id CallBack:^(id obj) {
                             
    NSArray *arr = obj;
    NSDictionary *ddd = arr[0];
    name = ddd[@"return"];
     
     
 }];
    return name;
                             
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}


@end
