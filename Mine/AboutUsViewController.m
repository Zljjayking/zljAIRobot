//
//  AboutUsViewController.m
//  Financeteam
//
//  Created by 张正飞 on 16/8/18.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "AboutUsViewController.h"

@interface AboutUsViewController ()

@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"关于我们";
    self.view.backgroundColor = VIEW_BASE_COLOR;
    
    [self creatUI];
}

-(void)creatUI{
    
    UIImageView * imageV = [[UIImageView alloc]init];
    imageV.image = [UIImage imageNamed:@"180"];
   // imageV.backgroundColor = TABBAR_BASE_COLOR;
    [self.view addSubview:imageV];
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
    
        make.top.equalTo(self.view.mas_top).offset(30*KAdaptiveRateHeight+64);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(80*KAdaptiveRateWidth);
        make.height.mas_equalTo(80*KAdaptiveRateWidth);
    }];
    
    UILabel * oneLabel = [[UILabel alloc]init];
    oneLabel.text = @"瀚语智能";
    oneLabel.textAlignment = NSTextAlignmentCenter;
    oneLabel.font = [UIFont systemFontOfSize:22];
    oneLabel.textColor = [UIColor lightGrayColor];
    [self.view addSubview:oneLabel];
    [oneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.equalTo(imageV.mas_bottom).offset(10*KAdaptiveRateHeight);
//        make.width.mas_equalTo(80*KAdaptiveRateWidth);
        make.height.mas_equalTo(30*KAdaptiveRateWidth);
        
    }];
    
    UILabel * twoLabel = [[UILabel alloc]init];
    twoLabel.backgroundColor = [UIColor whiteColor];
    twoLabel.text = @"  产品说明:";
    twoLabel.textAlignment = NSTextAlignmentLeft;
    twoLabel.font = [UIFont systemFontOfSize:18];
    twoLabel.textColor = [UIColor lightGrayColor];
    [self.view addSubview:twoLabel];
    [twoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.equalTo(oneLabel.mas_bottom).offset(15*KAdaptiveRateHeight);
        make.width.mas_equalTo(kScreenWidth);
        make.height.mas_equalTo(30*KAdaptiveRateWidth);
        
    }];
    
    UIView * vv = [[UIView alloc]init];
    vv.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:vv];
    [vv mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.equalTo(twoLabel.mas_bottom).offset(0*KAdaptiveRateHeight);
        make.width.mas_equalTo(kScreenWidth);
        make.height.mas_equalTo(130*KAdaptiveRateWidth);
        
    }];
    
    
    UILabel * threeLabel = [[UILabel alloc]init];
    threeLabel.backgroundColor = [UIColor whiteColor];
    threeLabel.text = @"这是一款为销售团队量身打造的管理软件，功能包含组织架构建成、团队在线交流、团队管理、任务管理、客户管理、即时对话等，主要服务的客户群体针对于所有需要部署管理的企业和团队。";
    threeLabel.numberOfLines = 0;
    threeLabel.textAlignment = NSTextAlignmentCenter;
    threeLabel.font = [UIFont systemFontOfSize:14*KAdaptiveRateWidth];
    threeLabel.textColor = [UIColor lightGrayColor];
    [vv addSubview:threeLabel];
    [threeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.equalTo(twoLabel.mas_bottom).offset(0*KAdaptiveRateHeight);
        make.width.mas_equalTo(kScreenWidth-80);
        make.height.mas_equalTo(130*KAdaptiveRateWidth);
        
    }];
    
    UILabel * fourLabel = [[UILabel alloc]init];
    fourLabel.backgroundColor = [UIColor whiteColor];
    fourLabel.text = @"  客服热线:";
    fourLabel.textAlignment = NSTextAlignmentLeft;
    fourLabel.font = [UIFont systemFontOfSize:18];
    fourLabel.textColor = [UIColor lightGrayColor];
    [self.view addSubview:fourLabel];
    [fourLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.equalTo(threeLabel.mas_bottom).offset(5*KAdaptiveRateHeight);
        make.width.mas_equalTo(kScreenWidth);
        make.height.mas_equalTo(30*KAdaptiveRateWidth);
        
    }];
    
    UILabel * fiveLabel = [[UILabel alloc]init];
    fiveLabel.backgroundColor = [UIColor whiteColor];
    fiveLabel.text = @"025-57724660";
    fiveLabel.textAlignment = NSTextAlignmentCenter;
    fiveLabel.font = [UIFont systemFontOfSize:14];
    fiveLabel.textColor = [UIColor redColor];
    [self.view addSubview:fiveLabel];
    [fiveLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.equalTo(fourLabel.mas_bottom).offset(0*KAdaptiveRateHeight);
        make.width.mas_equalTo(kScreenWidth);
        make.height.mas_equalTo(30*KAdaptiveRateWidth);
        
    }];

    

    UILabel * sixLabel = [[UILabel alloc]init];
    sixLabel.backgroundColor = VIEW_BASE_COLOR;
    sixLabel.text = @"南京瀚承鸿澜信息科技有限公司  版权所有";
    sixLabel.textAlignment = NSTextAlignmentCenter;
    sixLabel.font = [UIFont systemFontOfSize:14];
    sixLabel.textColor = [UIColor lightGrayColor];
    [self.view addSubview:sixLabel];
    [sixLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.view.mas_bottom).offset(-10*KAdaptiveRateHeight);
        make.width.mas_equalTo(kScreenWidth);
        make.height.mas_equalTo(30*KAdaptiveRateWidth);
        
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
