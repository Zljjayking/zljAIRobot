//
//  SettingViewController.m
//  Financeteam
//
//  Created by 徐兆阳 on 16/5/27.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "SettingViewController.h"
#import "SettingTableViewCell.h"
#import "newLoginViewController.h"
#import <RongIMKit/RongIMKit.h>
#import "MessageDisturbViewController.h"
#import "secreteSetViewController.h"
#import "AboutUsViewController.h"
#import "ChangeMobileViewController.h"
#import "SearchViewController.h"
#import "UIAdaption.h"
@interface SettingViewController ()<UITableViewDataSource,UITableViewDelegate,JKAlertViewDelegate>{
    
    UITableView *_settingTableV;
    NSArray     *imageNameArr;
    NSArray     *titleNameArr;
}
@property (nonatomic,assign)float cache;
@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString * cachPath = [ NSSearchPathForDirectoriesInDomains ( NSCachesDirectory , NSUserDomainMask , YES ) firstObject ];
    self.cache = [self folderSizeAtPath:cachPath];
    NSLog(@"**%.2f",self.cache);
    
    
    [self initDatas];
    [self initUIs];

}
#pragma mark -- data
-(void)initDatas{
    imageNameArr = @[@[@"提醒设置-1",@"隐私设置"],@[@"客服热线",@"关于我们-1",@"更换登录手机号"],@[@"清除缓存"]];
    titleNameArr = @[@[@"提醒设置",@"隐私设置"],@[@"客服热线",@"关于我们",@"更改登录手机号码"],@[@"清除缓存"]];
//    imageNameArr = @[@[@"提醒设置-1",@"隐私设置"],@[@"客服热线",@"更换登录手机号"],@[@"清除缓存"]];
//    titleNameArr = @[@[@"提醒设置",@"隐私设置"],@[@"客服热线",@"更改登录手机号码"],@[@"清除缓存"]];
}
#pragma mark -- UI
-(void)initUIs{
    self.title = @"设置";
    self.view.backgroundColor = VIEW_BASE_COLOR;
  
    // tableView
    _settingTableV = [[UITableView alloc]initWithFrame:[UIAdaption getAdaptiveRectWith6Rect:CGRectMake(0, 0, 375, 600)] style:UITableViewStyleGrouped];
    _settingTableV.frame = CGRectMake(0, 64, kScreenWidth, 400);
    
    _settingTableV.scrollEnabled = NO;
    _settingTableV.delegate   = self;
    _settingTableV.dataSource = self;
    _settingTableV.backgroundColor = VIEW_BASE_COLOR;
    _settingTableV.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_settingTableV registerClass:[SettingTableViewCell class] forCellReuseIdentifier:@"settingCell"];
    [self.view addSubview:_settingTableV];
    
    // 退出登录
    UIButton *exitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self layoutUIInMindWithWidth:335 andHeight:47 andY:380 andView:exitBtn];
    exitBtn.frame = CGRectMake((kScreenWidth-280*KAdaptiveRateWidth)/2.0,450, 280*KAdaptiveRateWidth, 50);
    if (IS_IPHONE_X) {
        _settingTableV.frame = CGRectMake(0, 88, kScreenWidth, 400);
        exitBtn.frame = CGRectMake((kScreenWidth-280*KAdaptiveRateWidth)/2.0,450, 280*KAdaptiveRateWidth, 50);
    }
    exitBtn.layer.masksToBounds = YES;
    exitBtn.layer.cornerRadius  = [UIAdaption getAdaptiveHeightWith6Height:5];
    [exitBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    [exitBtn setBackgroundImage:[UIImage imageWithColor:MYORANGE] forState:UIControlStateNormal];
    [exitBtn setBackgroundImage:[UIImage imageWithColor:GRAY229] forState:UIControlStateHighlighted];
    exitBtn.titleLabel.textColor    =[UIColor whiteColor];
    [exitBtn addTarget:self action:@selector(clickExitBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:exitBtn];

    
}
#pragma mark -- UITableViewDelegate & UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 2;
            break;
        case 1:
            return 3;
            break;
        case 2:
            return 1;
            break;
        default:
            return 0;
            break;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [UIAdaption getAdaptiveHeightWith6Height:5];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return [UIAdaption getAdaptiveHeightWith6Height:5];
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SettingTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"settingCell" forIndexPath:indexPath];
    cell.accessoryType    = UITableViewCellAccessoryDisclosureIndicator;
    cell.iconImageV.image  = [UIImage imageNamed:imageNameArr[indexPath.section][indexPath.row]];
    cell.titleLb.text     = titleNameArr[indexPath.section][indexPath.row];
    
    UILabel *phoneNumLb = [[UILabel alloc]init];
    [cell.contentView addSubview:phoneNumLb];
    [phoneNumLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cell.mas_centerY);
        make.right.equalTo(cell.mas_right).offset(-30*KAdaptiveRateWidth);
        make.height.mas_equalTo(20);
    }];
    
    phoneNumLb.font     = [UIFont systemFontOfSize:15];
    phoneNumLb.textAlignment = NSTextAlignmentRight;
    
    if (indexPath.section == 1 && indexPath.row == 0) {
         phoneNumLb.tag = 3;
        phoneNumLb.textColor= TABBAR_BASE_COLOR;
        phoneNumLb.text     = @"025-57724660";
    }else if(indexPath.section == 2){
        [cell.iconImageV mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.mas_left).offset(15.5*KAdaptiveRateWidth);
        }];
        [cell layoutIfNeeded];
        phoneNumLb.tag = 4;
        phoneNumLb.textColor= [UIColor grayColor];
        phoneNumLb.text    = [NSString stringWithFormat:@"%.2fM",self.cache];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1 &&indexPath.row == 0) {
        // 拨打电话
        NSMutableString * str = [[NSMutableString alloc] initWithFormat:@"tel:%@",@"025-57724660"];
        UIWebView * callWebview = [[UIWebView alloc] init];
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
        [self.view addSubview:callWebview];
        
    }else if (indexPath.section == 2 && indexPath.row == 0){
        
        NSString * message = [NSString stringWithFormat:@"缓存大小为%.2fM,确定要清理缓存吗？",self.cache];
        
        JKAlertView *alertVi =[[JKAlertView alloc]initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertVi show];
        alertVi.tag = 2;
    }else if (indexPath.section == 0 && indexPath.row == 0){
        
        MessageDisturbViewController * mdVC = [[MessageDisturbViewController alloc]init];
        [self.navigationController pushViewController:mdVC animated:YES];
        
    } else if (indexPath.section == 0 && indexPath.row == 1) {
        secreteSetViewController *secreteSet = [secreteSetViewController new];
        [self.navigationController pushViewController:secreteSet animated:YES];
    } else if (indexPath.section == 1 && indexPath.row == 1){
        AboutUsViewController * absVC = [[AboutUsViewController alloc]init];
        [self.navigationController pushViewController:absVC animated:YES];
    } else if (indexPath.section == 1 && indexPath.row == 2){
        ChangeMobileViewController * absVC = [[ChangeMobileViewController alloc]init];
        [self.navigationController pushViewController:absVC animated:YES];
    }
    
}
#pragma mark -- 按钮点击事件
-(void)clickExitBtn:(UIButton *)sender{
    
    JKAlertView *alertV =[[JKAlertView alloc]initWithTitle:@"退出登录" message:@"确定退出登录吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertV show];
    
    alertV.tag = 1;
//    SearchViewController *search = [SearchViewController new];
//    search.seType = 2;
//    search.num = 1;
//    [self.navigationController pushViewController:search animated:YES];
}

-(void)alertView:(JKAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1) {
        if (buttonIndex) {
            // 清除数据
            NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
            [userdefaults removeObjectForKey:@"name"];
            [userdefaults removeObjectForKey:@"pwd"];
            //        [[LocalMeManager sharedPersonalInfoManager] setLoginPeopleInfo:nil];
            [[RCIM sharedRCIM] logout];
            // 退到登录界面
            UIWindow * window = [UIApplication sharedApplication].delegate.window;
            UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:[newLoginViewController new]];
            window.rootViewController = navi;
            
        }
    }else if (alertView.tag == 2){
        if (buttonIndex) {
            
            NSString * cachPath = [ NSSearchPathForDirectoriesInDomains ( NSCachesDirectory , NSUserDomainMask , YES ) firstObject ];
            
            [self clearCache:cachPath];
            
            self.cache = [self folderSizeAtPath:cachPath];
            NSLog(@"==%.2f",self.cache);
        
            [_settingTableV reloadData];
            
            UILabel * label1 = [_settingTableV viewWithTag:3];
            [label1 removeFromSuperview];
            
            UILabel * label2 = [_settingTableV viewWithTag:4];
            [label2 removeFromSuperview];
            
            [MBProgressHUD showSuccess:@"清理成功"];
            
        }
    }
}

//计算缓存大小
-(float)folderSizeAtPath:(NSString *)path{
    
    NSFileManager *fileManager=[NSFileManager defaultManager];
    float folderSize = 0.0;
    if ([fileManager fileExistsAtPath:path]) {
    
        folderSize+=[[SDImageCache sharedImageCache] getSize]/1024.0/1024.0;
        return folderSize;
    }
    return 0;
}

//清理缓存
-(void)clearCache:(NSString *)path{
    
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        
        [[SDImageCache sharedImageCache] clearDisk];
        
    }
    
}
@end
