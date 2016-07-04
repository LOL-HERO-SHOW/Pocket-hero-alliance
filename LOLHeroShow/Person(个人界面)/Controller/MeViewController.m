//
//  MeViewController.m
//  ME
//
//  Created by tarena1 on 16/6/29.
//  Copyright © 2016年 DAEDAE. All rights reserved.
//

#import "MeViewController.h"
#import "RecordTableViewCell.h"
#import "SettingViewController.h"
#import "Utils.h"
#import "User.h"
#import "Combat.h"

@interface MeViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *recordTableView;
@property (weak, nonatomic) IBOutlet UIImageView *icon_id;
@property (weak, nonatomic) IBOutlet UIView *personMessageViewOne;
@property (weak, nonatomic) IBOutlet UIView *personMessageViewTwo;

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *userLevel;
@property (weak, nonatomic) IBOutlet UILabel *area_ID;
@property (weak, nonatomic) IBOutlet UILabel *tier;
@property (weak, nonatomic) IBOutlet UILabel *power_value;
@property (weak, nonatomic) IBOutlet UILabel *win_point;



@property (nonatomic, strong) NSArray *userInfo;
@property (nonatomic, strong) NSArray *combats;
@property (nonatomic, strong) NSMutableArray *heroesImagePath;
@property (nonatomic, strong) User *personUser;
@property (nonatomic, strong) User *personalMessage;
@property (nonatomic, strong) NSDictionary *tierDic;
@property (nonatomic, strong) NSDictionary *queueDic;
@property (nonatomic, strong) NSDictionary *game_typeDic;
@property (nonatomic, strong) NSDictionary *winDic;
@property (nonatomic, strong) NSString *userImagePath;
@property (nonatomic, strong) NSString *combatHeroImagePath;

@end


@implementation MeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.recordTableView.delegate = self;
    self.userInfo = [NSArray array];
    self.combats = [NSArray array];
    self.heroesImagePath = [NSMutableArray array];
    
//    self.personUser = [[User alloc]init];
//    self.personalMessage = [[User alloc]init];
//    self.userImagePath = [[NSString alloc]init];
//    self.combatHeroImagePath = [[NSString alloc]init];
//    
    self.navigationItem.title = @"我";
    self.navigationController.navigationBar.backgroundColor = [UIColor blackColor];
    UIBarButtonItem *setupButton = [[UIBarButtonItem alloc]initWithTitle:@"设置" style:UIBarButtonItemStylePlain target:self action:@selector(setUp:)];
    self.navigationItem.rightBarButtonItem = setupButton;
    
    UIView *headView = [self setHeaderView];
    self.recordTableView.tableHeaderView = headView;
    
    [self getUserInfo];
    [self.view setNeedsDisplay];
    
}

- (void)setUp:(UIBarButtonItem *)button {
    SettingViewController *settingVC = [[SettingViewController alloc]init];
    [self.navigationController pushViewController:settingVC animated:YES];
}

- (void)getUserInfo {
    self.tierDic =@{@(0):@"最强王者",@(1):@"钻石",@(2):@"白金",@(3):@"黄金",@(4):@"白银",@(5):@"青铜",@(6):@"大师",@(255):@"无"};
    self.queueDic = @{@(0):@"I",@(1):@"II",@(2):@"III",@(3):@"V",@(4):@"VI",@(255):@"无"};
    self.game_typeDic = @{@(4):@"排位赛",@(6):@"极地大乱斗"};
    self.winDic = @{@(1):@"胜利",@(2):@"失败"};
    //得到用户数据
    [Utils getUserInfoWithCode:@"DAESSI" andCallback:^(id obj) {
        self.userInfo = obj;//根据游戏用户名，得到用户对象数组
    
        for (User *user in self.userInfo) {
            if (user.area_id.intValue == 27) {
                self.personUser = user;
            }
        }
        
        [Utils getUserIconWithIconid:self.personUser.icon_id andCallback:^(id obj) {
            self.userImagePath = obj;
            self.icon_id.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.userImagePath]]];
        }];
        
        [Utils getUserHotInfoWithQQuin:self.personUser.qquin andVaid:self.personUser.area_id.stringValue andCallback:^(id obj) {
            self.personalMessage = obj;
            
            self.area_ID.text = [NSString stringWithFormat:@"区服:%@", self.personalMessage.area_id.stringValue];
            self.userLevel.text = [NSString stringWithFormat:@"等级:%@", self.personalMessage.level.stringValue];
            self.power_value.text = [NSString stringWithFormat:@"战斗力:%@", self.personalMessage.power_value.stringValue];
            self.tier.text = [NSString stringWithFormat:@"段位:%@", self.tierDic[self.personalMessage.tier]];
            self.win_point.text = [NSString stringWithFormat:@"胜点:%@", self.personalMessage.win_point.stringValue];
            
            
        }];
        
        [Utils requestCombatListWithQQuin:self.personUser.qquin andVaid:self.personUser.area_id.stringValue andCallback:^(id obj) {
            self.combats = obj;
//            for (int i = 0; i < self.combats.count; i++) {
//                [Utils getChampionIconWithChampion_id:((Combat *)self.combats[i]).champion_id andCallback:^(id obj) {
//                    self.combatHeroImagePath = obj;
//                    NSLog(@"!!!%@", self.combatHeroImagePath);
//                    [self.heroesImagePath addObject:self.combatHeroImagePath];
//                }];
//            }
            [self.recordTableView reloadData];
        }];
    }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.combats.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Record"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"RecordTableViewCell" owner:nil options:nil] lastObject];
    }
//    NSLog(@"%@", self.combats);
    Combat *combat = self.combats[indexPath.row];
    
    cell.champion_id.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://cdn.tgp.qq.com/pallas/images/champions_id/%@.png", combat.champion_id]]]];
    
    cell.win.text = self.winDic[combat.win];
    if ([cell.win.text isEqualToString:@"胜利"]) {
        cell.win.textColor = [UIColor greenColor];
    }
    else {
        cell.win.textColor = [UIColor redColor];
    }
    
    cell.battle_map.text = self.game_typeDic[combat.game_type];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (UIView *)setHeaderView {
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 184, 414, 50)];
    UILabel *combatLable = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 100, 50)];
    combatLable.text = @"战绩";
    combatLable.textAlignment = NSTextAlignmentLeft;
    combatLable.textColor = [UIColor purpleColor];
    [view addSubview:combatLable];
    return view;
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
