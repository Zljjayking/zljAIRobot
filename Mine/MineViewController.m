//
//  MineViewController.m
//  Financeteam
//
//  Created by Zccf on 16/5/12.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "MineViewController.h"
#import "MineTableViewCell.h"
#import "TouXiangTableViewCell.h"
#import "ExitTableViewCell.h"
#import "LoginPeopleModel.h"
#import "SettingViewController.h"
#import "MineInfoViewController.h"
#import "MemberPayViewController.h"
#import "UsinghelpViewController.h"
#import "MyWalletViewController.h"
#import "checkPwdView.h"
#import "buyMeViewController.h"
#import "howToUseViewController.h"

@interface MineViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSMutableArray *_InfoArr;
    NSMutableArray *_InfoImageArr;
    NSUserDefaults *_userDefaults;
    LoginPeopleModel *loginModel;
    
}
@property (nonatomic, strong) UITableView *mineTableView;
@property (nonatomic, strong) AppDelegate *Mydelegate;
@property (nonatomic, strong) checkPwdView *checkView;
@property (nonatomic, assign) BOOL isCrps;
@property (nonatomic, assign) BOOL isOnTime;
@end

@implementation MineViewController
//懒加载tableView
- (UITableView *)mineTableView {
    if (!_mineTableView) {
        _mineTableView = [[UITableView alloc]init];
        _mineTableView.backgroundColor = VIEW_BASE_COLOR;
        UIView *v = [UIView new];
        v.backgroundColor = VIEW_BASE_COLOR;
        _mineTableView.tableFooterView = v;
    }
    return _mineTableView;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    loginModel = [LoginPeopleModel requestWithDic:[[LocalMeManager sharedPersonalInfoManager] loginPeopleInfo]];
    [self.mineTableView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    loginModel = [LoginPeopleModel requestWithDic:[[LocalMeManager sharedPersonalInfoManager] loginPeopleInfo]];
    
    _userDefaults = [NSUserDefaults standardUserDefaults];
    
    UIView *vi = [UIView new];
    vi.backgroundColor = [UIColor clearColor];
    self.navigationItem.titleView = vi;
    
    UIView *view = [self getLineViewInNavigationBar:self.navigationController.navigationBar];
    view.hidden = YES;

    self.isOnTime = 0;
    _InfoArr = [NSMutableArray arrayWithObjects:loginModel.realName,@"工资条",@"使用帮助",@"设置",nil];
    if ([Utils isBlankString:self.MyUserInfoModel.iconURL]) {
        _InfoImageArr = [NSMutableArray arrayWithObjects:@"聊天头像",@"工资条",@"helpToUse",@"设置", nil];
    } else {
        _InfoImageArr = [NSMutableArray arrayWithObjects:self.MyUserInfoModel.iconURL,@"工资条",@"helpToUse",@"设置", nil];
    }
    
//    if (![self.myMobile isEqualToString:@"15255353386"]) {
//        self.isOnTime = 1;
//        _InfoArr = [NSMutableArray arrayWithObjects:loginModel.realName,@"我的钱包",@"工资条",@"使用帮助",@"设置",nil];
//        if ([Utils isBlankString:self.MyUserInfoModel.iconURL]) {
//            _InfoImageArr = [NSMutableArray arrayWithObjects:@"聊天头像",@"我的钱包",@"工资条",@"helpToUse",@"设置", nil];
//        } else {
//            _InfoImageArr = [NSMutableArray arrayWithObjects:self.MyUserInfoModel.iconURL,@"我的钱包",@"工资条",@"helpToUse",@"设置", nil];
//        }
//
//        self.isCrps = 0;
//        if ([self.MyUserInfoModel.isCp isEqualToString:@"1"]) {
//            self.isCrps = 1;
//            _InfoArr = [NSMutableArray arrayWithObjects:loginModel.realName,@"我的钱包",@"工资条",@"软件付费",@"使用帮助",@"设置",nil];
//            if ([Utils isBlankString:self.MyUserInfoModel.iconURL]) {
//                _InfoImageArr = [NSMutableArray arrayWithObjects:@"聊天头像",@"我的钱包",@"工资条",@"buyMe",@"helpToUse",@"设置", nil];
//            } else {
//                _InfoImageArr = [NSMutableArray arrayWithObjects:self.MyUserInfoModel.iconURL,@"我的钱包",@"工资条",@"buyMe",@"helpToUse",@"设置", nil];
//            }
//            
//        }
//    }
    
    [self.mineTableView reloadData];
    self.mineTableView.delegate = self;
    self.mineTableView.dataSource = self;
    self.mineTableView.bounces = NO;
    self.mineTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //另外两个没有头像的cell
    [self.mineTableView registerClass:[MineTableViewCell class] forCellReuseIdentifier:@"cell"];
    //注册有头像的cell
    [self.mineTableView registerClass:[TouXiangTableViewCell class] forCellReuseIdentifier:@"touxiang"];
    self.mineTableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
#ifdef __IPHONE_11_0
    if ([self.mineTableView respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]) {
        if (@available(iOS 11.0, *)) {
            self.mineTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
    }
#endif
//    if (iOS11Later) {
//        self.mineTableView.frame = CGRectMake(0, -64, kScreenWidth, kScreenHeight);
//    }
    [self.view addSubview:self.mineTableView];
    
    // Do any additional setup after loading the view.
}

- (UIImageView *)getLineViewInNavigationBar:(UIView *)view
{
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self getLineViewInNavigationBar:subview];
        if (imageView) {
            return imageView;
        }
    }
    
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _InfoArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        UIView *vi = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 12)];
        vi.backgroundColor = VIEW_BASE_COLOR;
        return vi;
    } else {
        UIView *vi = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 6)];
        
        vi.backgroundColor = VIEW_BASE_COLOR;
        return vi;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 181*KAdaptiveRateWidth;
    } else {
        return 50;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }
    if (section == 1) {
        return 12;
    } else {
        return 6;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        TouXiangTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"touxiang" forIndexPath:indexPath];
        if (!cell) {
            cell = [[TouXiangTableViewCell  alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"touxiang"];
        }
        
        NSString *imagePath = [NSString stringWithFormat:@"%@%@",PHOTO_ADDRESS,self.MyUserInfoModel.iconURL];
        NSURL *imageURL = [NSURL URLWithString:imagePath];
        [cell.InfoImage sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"聊天头像"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
        }];
        cell.InfoLB.text = [NSString stringWithFormat:@"%@",loginModel.realName];
        cell.mobileLB.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"name"];
        return cell;
        
    } else {
        MineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        if (!cell) {
            cell = [[MineTableViewCell  alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        
        cell.InfoImage.image = [UIImage imageNamed:_InfoImageArr[indexPath.section]];
        
        cell.InfoLB.text = _InfoArr[indexPath.section];
        return cell;
        
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (!self.isOnTime) {
        switch (indexPath.section) {
            case 0:
            {
                MineInfoViewController *MineInfo = [[MineInfoViewController alloc]init];
                MineInfo.hidesBottomBarWhenPushed = YES;
                [MineInfo returnStr:^(NSString *returnStr) {
                    NSLog(@"returnStr == %@",returnStr);
                    if ([returnStr isEqualToString:@"1"]) {
                        loginModel = [LoginPeopleModel requestWithDic:[[LocalMeManager sharedPersonalInfoManager] loginPeopleInfo]];
                        [self.mineTableView reloadData];
                    }
                }];
                [self.navigationController pushViewController:MineInfo animated:YES];
            }
                break;
            case 1:
            {
                [self changeClick];
            }
                break;
            case 2:
            {
                howToUseViewController *webV = [[howToUseViewController alloc]init];
                webV.urlStr = @"http://www.rongeoa.com/usinghelpphone/quickStart.jsp";//
                webV.isPullRefresh = NO;
                
                webV.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:webV animated:YES];
            }
                break;
            default:
            {
                SettingViewController *settingVc = [[SettingViewController alloc]init];
                settingVc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:settingVc animated:YES];
            }
                break;
        }

    } else {
        if (self.isCrps) {
            switch (indexPath.section) {
                case 0:
                {
                    MineInfoViewController *MineInfo = [[MineInfoViewController alloc]init];
                    MineInfo.hidesBottomBarWhenPushed = YES;
                    [MineInfo returnStr:^(NSString *returnStr) {
                        NSLog(@"returnStr == %@",returnStr);
                        if ([returnStr isEqualToString:@"1"]) {
                            loginModel = [LoginPeopleModel requestWithDic:[[LocalMeManager sharedPersonalInfoManager] loginPeopleInfo]];
                            [self.mineTableView reloadData];
                        }
                    }];
                    [self.navigationController pushViewController:MineInfo animated:YES];
                }
                    break;
                    //            case 1:
                    //            {
                    //                [self changeClick];
                    //            }
                    //                break;
                case 1:
                {
                    MyWalletViewController *myWalletVc = [[MyWalletViewController alloc]init];
                    myWalletVc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:myWalletVc animated:YES];
                }
                    break;
                case 2:
                {
                    [self changeClick];
                }
                    break;
                case 3:
                {
                    
                    buyMeViewController *usingHelp = [[buyMeViewController alloc]init];
                    usingHelp.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:usingHelp animated:YES];
                }
                    break;
                case 4:
                {
                    howToUseViewController *webV = [[howToUseViewController alloc]init];
                    webV.urlStr = @"http://www.rongeoa.com/usinghelpphone/quickStart.jsp";
                    webV.isPullRefresh = NO;
                    
                    webV.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:webV animated:YES];
                }
                    break;
                    
                default:
                {
                    SettingViewController *settingVc = [[SettingViewController alloc]init];
                    settingVc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:settingVc animated:YES];
                }
                    break;
            }
        } else {
            switch (indexPath.section) {
                case 0:
                {
                    MineInfoViewController *MineInfo = [[MineInfoViewController alloc]init];
                    MineInfo.hidesBottomBarWhenPushed = YES;
                    [MineInfo returnStr:^(NSString *returnStr) {
                        NSLog(@"returnStr == %@",returnStr);
                        if ([returnStr isEqualToString:@"1"]) {
                            loginModel = [LoginPeopleModel requestWithDic:[[LocalMeManager sharedPersonalInfoManager] loginPeopleInfo]];
                            [self.mineTableView reloadData];
                        }
                    }];
                    [self.navigationController pushViewController:MineInfo animated:YES];
                }
                    break;
                    //            case 1:
                    //            {
                    //                [self changeClick];
                    //            }
                    //                break;
                    //            case 2:
                    //            {
                    //                SettingViewController *settingVc = [[SettingViewController alloc]init];
                    //                settingVc.hidesBottomBarWhenPushed = YES;
                    //                [self.navigationController pushViewController:settingVc animated:YES];
                    //            }
                    //                break;
                case 1:
                {
                    MyWalletViewController *myWalletVc = [[MyWalletViewController alloc]init];
                    myWalletVc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:myWalletVc animated:YES];
                }
                    break;
                case 2:
                {
                    [self changeClick];
                }
                    break;
                case 3:
                {
                    howToUseViewController *webV = [[howToUseViewController alloc]init];
                    webV.urlStr = @"http://www.rongeoa.com/usinghelpphone/quickStart.jsp";
                    webV.isPullRefresh = NO;
                    
                    webV.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:webV animated:YES];
                }
                    break;
                case 4:
                {
                    SettingViewController *settingVc = [[SettingViewController alloc]init];
                    settingVc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:settingVc animated:YES];
                }
                    break;
            }
        }
    }
    
    
}
- (void)changeClick {
    
    self.checkView = [[checkPwdView alloc]initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 160)];
    
    self.checkView.bgView.hidden = YES;
    
    [self.tabBarController.view addSubview:self.checkView.bgView];
    [self.tabBarController.view addSubview:self.checkView];
    
    self.checkView.bgView.hidden = NO;
    __weak typeof(self) weakSelf = self;
    self.checkView.isPopBlock = ^(){
        weakSelf.navigationController.fd_fullscreenPopGestureRecognizer.enabled = YES;
    };
    self.checkView.isSuccessBlock = ^(){
        UsinghelpViewController *usingHelp = [[UsinghelpViewController alloc]init];
        usingHelp.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:usingHelp animated:YES];
    };
    
    [UIView animateWithDuration:0.2 animations:^{
        
        self.checkView.frame = CGRectMake(0, kScreenHeight-160, kScreenWidth, 160);
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
