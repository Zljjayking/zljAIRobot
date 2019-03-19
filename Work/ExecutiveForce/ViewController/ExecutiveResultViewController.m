//
//  ExecutiveResultViewController.m
//  Financeteam
//
//  Created by 张正飞 on 16/7/28.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "ExecutiveResultViewController.h"

#import "ExeResultCell.h"
#import "ExeResultFoldCell.h"
#import "ExeOrderListCell.h"

@interface ExecutiveResultViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView * exeResultTableView;
@property(nonatomic,strong)UITableView * exeResultFoldTableView;

@property(nonatomic,strong)NSMutableArray * procountArray;
@property(nonatomic,strong)NSMutableArray * nameArray;

@property (nonatomic,assign)BOOL isFold;

@end

@implementation ExecutiveResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"查询结果";
    self.view.backgroundColor = VIEW_BASE_COLOR;
    
    self.isFold = 0;
    

    NSLog(@"dic=%@",self.dataDic);
    
    [self setData];
    
    [self creatUI];
    
}

-(void)setData{
    
    NSArray * array = [NSArray arrayWithArray:self.dataDic[@"orderList"]];
    
    for (NSDictionary * dic in array) {
        
        
        [self.procountArray addObject:dic[@"procount"]];
        [self.nameArray addObject:dic[@"name"]];
        
    }
    NSLog(@"procount==%@",self.procountArray);
    NSLog(@"name==%@",self.nameArray);
    
    
}

-(void)creatUI{
    
    _exeResultTableView = [[UITableView alloc]init];
    _exeResultTableView.separatorColor = GRAY229;
   // _exeResultTableView.backgroundColor = [UIColor greenColor];
    _exeResultTableView.delegate = self;
    _exeResultTableView.dataSource = self;
    _exeResultTableView.bounces = NO;
    [self.view addSubview:_exeResultTableView];
    [_exeResultTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.top.equalTo(self.view.mas_top).offset(NaviHeight);
        make.height.mas_equalTo(275);
    }];
    
    _exeResultTableView.tag = 100;
    
    [_exeResultTableView registerClass:[ExeResultCell class] forCellReuseIdentifier:@"ExeResultCellID"];
    [_exeResultTableView registerClass:[ExeResultFoldCell class] forCellReuseIdentifier:@"ExeResultFoldCellID"];
    
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [_exeResultTableView setTableFooterView:view];
    
    _exeResultFoldTableView = [[UITableView alloc]init];
    _exeResultFoldTableView.separatorColor = GRAY229;
 //   _exeResultFoldTableView.backgroundColor = [UIColor yellowColor];
    _exeResultFoldTableView.delegate = self;
    _exeResultFoldTableView.dataSource = self;
    [self.view addSubview:_exeResultFoldTableView];
    [_exeResultFoldTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view.mas_left).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.top.equalTo(self.exeResultTableView.mas_bottom).offset(0);
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
        
    }];
    [_exeResultFoldTableView registerClass:[ExeOrderListCell class] forCellReuseIdentifier:@"ExeOrderListCellID"];
    
    _exeResultFoldTableView.tag = 200;
    
    _exeResultFoldTableView.hidden = YES;


    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView.tag == 100) {
        return 4;
    }else{
        return self.nameArray.count;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView.tag == 100) {
        
        return 13;
        
    }else{
        
        return 25;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.01;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (tableView.tag == 200) {
        
        UIView * headView = [[UIView alloc]init];
        headView.backgroundColor = VIEW_BASE_COLOR;
        
        UILabel * leftLabel = [[UILabel alloc]init];
        leftLabel.backgroundColor = [UIColor clearColor];
        leftLabel.text = @"产品名称";
        leftLabel.font = [UIFont systemFontOfSize:13];
        leftLabel.textAlignment = NSTextAlignmentCenter;
        leftLabel.textColor = [UIColor grayColor];
        [headView addSubview:leftLabel];
        
        [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(headView.mas_left).offset(10);
            make.top.equalTo(headView.mas_top).offset(0);
            make.bottom.equalTo(headView.mas_bottom).offset(0);
            make.width.mas_equalTo(80);
            
        }];
        
        UILabel * rightLabel = [[UILabel alloc]init];
        rightLabel.backgroundColor = [UIColor clearColor];
        rightLabel.text = @"产品所占比例";
        rightLabel.font = [UIFont systemFontOfSize:13];
        rightLabel.textAlignment = NSTextAlignmentCenter;
        rightLabel.textColor = [UIColor grayColor];
        [headView addSubview:rightLabel];
        [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(headView.mas_right).offset(0);
            make.top.equalTo(headView.mas_top).offset(0);
            make.bottom.equalTo(headView.mas_bottom).offset(0);
            make.width.mas_equalTo(80);
            
        }];

        return headView;
        
    }else{
        
        return nil;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
   
        
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    if (tableView.tag == 100) {

        if (indexPath.row == 0) {
            ExeResultCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ExeResultCellID" forIndexPath:indexPath];
            if (!cell) {
                cell = [[ExeResultCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ExeResultCellID"];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.leftLabel.text = @"放款金额";
            cell.rightLabel.text = [NSString stringWithFormat:@"%@万元",self.dataDic[@"FKmoney"]];
            
            return cell;
        }else if (indexPath.row == 1){
            ExeResultCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ExeResultCellID" forIndexPath:indexPath];
            if (!cell) {
                cell = [[ExeResultCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ExeResultCellID"];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.leftLabel.text = @"待放款金额";
            cell.rightLabel.text = [NSString stringWithFormat:@"%@万元",self.dataDic[@"DFKmoney"]];
            
            return cell;
        }else if (indexPath.row == 2){
            ExeResultCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ExeResultCellID" forIndexPath:indexPath];
            if (!cell) {
                cell = [[ExeResultCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ExeResultCellID"];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.leftLabel.text = @"机构服务费";
            cell.rightLabel.text = [NSString stringWithFormat:@"%@万元",self.dataDic[@"mechSerMoney"]];
            
            return cell;
            
        }else if (indexPath.row == 3){
            ExeResultFoldCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ExeResultFoldCellID" forIndexPath:indexPath];
            if (!cell) {
                cell = [[ExeResultFoldCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ExeResultFoldCellID"];
            }
            //        cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.leftLabel.text = @"总订单量";
            cell.rightLabel.text = [NSString stringWithFormat:@"%@",self.dataDic[@"totalOrder"]];
            
            if (self.isFold == 0) {
                
                cell.foldImage.image = [UIImage imageNamed:@"箭头（上）"];
                
                _exeResultFoldTableView.hidden = YES;
                
            }else{
                cell.foldImage.image = [UIImage imageNamed:@"箭头（下）"];
                
                _exeResultFoldTableView.hidden = NO;
                
            }
            
            return cell;
        }
        
    }else{
        
        ExeOrderListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ExeOrderListCellID" forIndexPath:indexPath];
        if (!cell) {
            cell = [[ExeOrderListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ExeOrderListCellID"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = VIEW_BASE_COLOR;
        
        cell.leftLabel.text = [NSString stringWithFormat:@"%@",self.nameArray[indexPath.row]];
        
        CGFloat procount = [self.procountArray[indexPath.row] floatValue];
        cell.rightLabel.text = [NSString stringWithFormat:@"%.2f%%",procount];
        
        return cell;

        
    }
    

    return cell;
        
        
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 3) {
      

        
        if (self.isFold == 1) {
            
            self.isFold = 0;
            
        }else{
            
            self.isFold = 1;
        }
        
    }
    
    [_exeResultTableView reloadData];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView.tag == 100) {
        return 50;
    }else{
        return 35;
    }
    
}


-(NSMutableArray *)procountArray{
    
    if (_procountArray == nil) {
        _procountArray = [[NSMutableArray alloc]init];
    }
    return _procountArray;
}

-(NSMutableArray *)nameArray{
    
    if (_nameArray == nil) {
        _nameArray = [[NSMutableArray alloc]init];
    }
    return _nameArray;
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

