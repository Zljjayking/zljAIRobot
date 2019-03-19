//
//  secreteSetViewController.m
//  Financeteam
//
//  Created by Zccf on 16/8/4.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "secreteSetViewController.h"
#import "setHideTableViewCell.h"
#import "LoginPeopleModel.h"
@interface secreteSetViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property(nonatomic,assign)CGFloat cellHeight;
@property(nonatomic,strong)UITableView *DisTableView;
@property (nonatomic,assign) BOOL isON;
@property (nonatomic, strong) LoginPeopleModel *loginModel;
@property (nonatomic) BOOL isChanged;
@property (nonatomic, strong) NSString *titleStr;
@end

@implementation secreteSetViewController
- (NSUserDefaults *)userDefaults {
    if (!_userDefaults) {
        _userDefaults = [NSUserDefaults standardUserDefaults];
    }
    return _userDefaults;
}
- (UITableView *)DisTableView {
    if (!_DisTableView) {
        _DisTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NaviHeight, self.view.frame.size.width, self.view.frame.size.width-64) style:UITableViewStylePlain];
        
        _DisTableView.delegate = self;
        _DisTableView.dataSource = self;
        _DisTableView.bounces = NO;
        _DisTableView.backgroundColor = VIEW_BASE_COLOR;
        [self.view addSubview:_DisTableView];
    }
    return _DisTableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.isChanged = 0;
    self.navigationItem.title = @"隐私设置";
    self.view.backgroundColor = VIEW_BASE_COLOR;
    self.loginModel = [LoginPeopleModel requestWithDic:[[LocalMeManager sharedPersonalInfoManager] loginPeopleInfo]];
    if ([self.loginModel.isHide isEqualToString:@"0"]) {
        self.isON = 0;
        self.titleStr = @"隐藏手机号码";
    } else if ([self.loginModel.isHide isEqualToString:@"1"]) {
        self.isON = 1;
        self.titleStr = @"显示手机号码";
    }
    [self createUI];
    // Do any additional setup after loading the view.
}
- (void)createUI {
    UIView * view = [[UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [self.DisTableView setTableFooterView:view];
    
    [self.DisTableView registerClass:[setHideTableViewCell class] forCellReuseIdentifier:@"MDOneTableViewCellID"];
//    [self.DisTableView registerClass:[MDTwoTableViewCell class] forCellReuseIdentifier:@"MDTwoTableViewCellID"];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 13;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    setHideTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MDOneTableViewCellID" forIndexPath:indexPath];
    if (!cell) {
        cell = [[setHideTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MDOneTableViewCellID"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.leftLabel.text = self.titleStr;
    if (self.isON) {
        [cell.rightSwitch setOn:YES animated:NO];
    }
    //        cell.rightSwitch.on = self.isON;
    [cell.rightSwitch addTarget:self action:@selector(getValueOnClick:) forControlEvents:UIControlEventValueChanged];
    
    //        cell.rightSwitch.tag = 100;
    
    return cell;
}
-(void)getValueOnClick:(UISwitch *)sender{
    if (sender.isOn) {
        
        NSLog(@"On");
        self.isON = 1;
        self.titleStr = @"显示手机号码";
    } else {
        NSLog(@"Off");
        self.isON = 0;
        self.titleStr = @"隐藏手机号码";
    }
    NSString *uid = [NSString stringWithFormat:@"%ld",self.loginModel.userId];
    NSString *state = [NSString stringWithFormat:@"%d",self.isON];
    NSLog(@"uid == %@,state == %@",uid,state);
    [HttpRequestEngine setIsHideWithUid:uid state:state completion:^(id obj, NSString *errorStr) {
        if (errorStr.length == 0) {
            NSDictionary *dic = [NSDictionary changeType:obj];
            NSString *code = [NSString stringWithFormat:@"%@",dic[@"code"]];
            if ([code isEqualToString:@"0"]) {
                [MBProgressHUD showSuccess:@"设定成功"];
            } else {
                if (self.isON) {
                    self.isON = 0;
                    self.titleStr = @"隐藏手机号码";
                } else {
                    self.isON = 1;
                    self.titleStr = @"显示手机号码";
                }
                [MBProgressHUD showError:[NSString stringWithFormat:@"%@",dic[@"errorMsg"]]];
            }
        } else {
            if (self.isON) {
                self.isON = 0;
            } else {
                self.isON = 1;
            }
            [MBProgressHUD showError:@"网络故障,请重试!"];
        }
    }];
    self.isChanged = 1;
    [self.DisTableView reloadData];
    
}
- (void)viewWillDisappear:(BOOL)animated {
    NSLog(@"执行了");
    if (self.isChanged == 1) {
        NSLog(@"执行了1");
        [HttpRequestEngine loginWithName:[self.userDefaults objectForKey:@"name"] pwd:[self.userDefaults objectForKey:@"pwd"] completion:^(id obj, NSString *errorStr) {
            if (errorStr.length == 0) {
                NSDictionary *data = [NSDictionary changeType:obj];
                NSString *code = [NSString stringWithFormat:@"%@",[data objectForKey:@"code"]];
                if ([code isEqualToString:@"1"]) {
                    
                } else {
                    [[LocalMeManager sharedPersonalInfoManager] setLoginPeopleInfo:data];
                }
            } else {
                
            }
        }];
    }
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
