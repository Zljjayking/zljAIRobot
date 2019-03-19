//
//  PaySuccessViewController.m
//  Financeteam
//
//  Created by 张正飞 on 16/7/21.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "PaySuccessViewController.h"
#import "PaySuccessOneCell.h"
#import "PaySuccessTwoCell.h"

@interface PaySuccessViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView * paySuccessTableView;

@end

@implementation PaySuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"支付结果";
    self.view.backgroundColor = VIEW_BASE_COLOR;
    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"返回（左）"] style:UIBarButtonItemStylePlain target:self action:@selector(GoBack)];
    self.navigationItem.leftBarButtonItem = left;
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];

    
    [self setUI];
}


-(void)setUI{
    
    _paySuccessTableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _paySuccessTableView.delegate = self;
    _paySuccessTableView.dataSource = self;
    _paySuccessTableView.bounces = NO;
    
    [self.view addSubview:_paySuccessTableView];
    
    UIView * view = [[UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [_paySuccessTableView setTableFooterView:view];
    
    [_paySuccessTableView registerClass:[PaySuccessOneCell class] forCellReuseIdentifier:@"PaySuccessOneCellID"];
    [_paySuccessTableView registerClass:[PaySuccessTwoCell class] forCellReuseIdentifier:@"PaySuccessTwoCellID"];
    
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectio{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }

    
    if (indexPath.row == 0) {
        
        PaySuccessOneCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PaySuccessOneCellID" forIndexPath:indexPath];
        if (!cell) {
            cell = [[PaySuccessOneCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PaySuccessOneCellID"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.leftImageView.image = [UIImage imageNamed:@"支付成功"];
        cell.rightLabel.text = @"支付成功";
        
        return cell;
    }else if (indexPath.row == 1){
        
        PaySuccessTwoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PaySuccessTwoCellID" forIndexPath:indexPath];
        if (!cell) {
            cell = [[PaySuccessTwoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PaySuccessTwoCellID"];
        }
        cell.leftLabel.text = @"充值时长";
        
        return cell;
        
    }else if (indexPath.row == 2){
        
        PaySuccessTwoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PaySuccessTwoCellID" forIndexPath:indexPath];
        if (!cell) {
            cell = [[PaySuccessTwoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PaySuccessTwoCellID"];
        }
        cell.leftLabel.text = @"有效期至";
        
        return cell;
        
        

    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 45;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 13;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.1;
    
}


-(void)GoBack{
    
    [self.navigationController popViewControllerAnimated:YES];
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
