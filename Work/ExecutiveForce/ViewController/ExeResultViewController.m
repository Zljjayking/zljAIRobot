//
//  ExeResultViewController.m
//  Financeteam
//
//  Created by 张正飞 on 16/9/21.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "ExeResultViewController.h"
#import "ExeOrderListCell.h"
#import "ExeTopCell.h"

@interface ExeResultViewController ()<UITableViewDelegate,UITableViewDataSource>

{
    UITableView       *_exeResultTableView;
    
    NSArray           *_mainArray;
    NSArray           *_subArray;
    
    BOOL              _sectionSelect[2];
}

@property(nonatomic,strong)NSMutableArray * procountArray;
@property(nonatomic,strong)NSMutableArray * promoneyArray;
@property(nonatomic,strong)NSMutableArray * nameArray;
@property(nonatomic,strong)NSMutableArray * nameArray1;

@property (nonatomic,assign)BOOL isFold1;
@property (nonatomic,assign)BOOL isFold2;

@end

@implementation ExeResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"查询结果";
    self.view.backgroundColor = VIEW_BASE_COLOR;
    
    self.isFold1 = 0;
    self.isFold2 = 0;
    
    [self createData];
    [self createUI];
}

-(void)createData{
    
    _mainArray = @[@"总订单量", @"放款金额", @"待放款金额", @"机构服务费"];
    
    NSArray * array = [NSArray arrayWithArray:self.dataDic[@"orderList"]];
    NSArray * dataArr = [NSArray arrayWithArray:self.dataDic[@"orderListAll"]];
    
    for (NSDictionary * dic in array) {
        
        [self.promoneyArray addObject:dic[@"promoney"]];
        [self.nameArray1 addObject:dic[@"name"]];
        
    }
    
    for (NSDictionary * dic in dataArr) {
        [self.procountArray addObject:dic[@"procount"]];
        [self.nameArray addObject:dic[@"name"]];
    }
    
//    NSLog(@"procount==%@",self.procountArray);
//    NSLog(@"name==%@",self.nameArray);
//    NSLog(@"promoney==%@",self.promoneyArray);
    
    
    
    for (int i=0; i<4; i++)
    {
        _sectionSelect[i] = YES;
    }
    
    
}

-(void)createUI{
    
    _exeResultTableView = [[UITableView alloc]init];
    _exeResultTableView.separatorColor = GRAY229;
    _exeResultTableView.delegate = self;
    _exeResultTableView.dataSource = self;
    // _exeResultTableView.bounces = NO;
    [self.view addSubview:_exeResultTableView];
    [_exeResultTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.top.equalTo(self.view.mas_top).offset(NaviHeight);
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
    }];
    
    [_exeResultTableView registerClass:[ExeOrderListCell class] forCellReuseIdentifier:@"ExeOrderListCellID"];
    [_exeResultTableView registerClass:[ExeTopCell class] forCellReuseIdentifier:@"ExeTopCellID"];
    
    
    UIView * clearView = [[ UIView alloc]init];
    clearView.backgroundColor = [UIColor clearColor];
    [_exeResultTableView setTableFooterView:clearView];
    
}

#pragma mark - tableviewDelegate & tableviewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 25;
        }else{
            return 40;
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            return 25;
        }else{
            return 40;
        }
    }else{
        
        return 40;
        
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _mainArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_sectionSelect[section]) {
        return 0;
    }
    
    if (section == 0) {
        return self.nameArray.count + 1 ;
    }else if (section == 1){
        return self.nameArray1.count + 1;
    }else{
        return 0;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    if (indexPath.section == 0 ) {
        
        if (indexPath.row == 0) {
            
            ExeTopCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ExeTopCellID" forIndexPath:indexPath];
            if (!cell) {
                cell = [[ExeTopCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ExeTopCellID"];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.backgroundColor = VIEW_BASE_COLOR;
            
            cell.leftLabel.text = @"产品名称";
            cell.rightLabel.text = @"产品所占比例";
            
            return cell;
            
        }else{
            
            ExeOrderListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ExeOrderListCellID" forIndexPath:indexPath];
            if (!cell) {
                cell = [[ExeOrderListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ExeOrderListCellID"];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = VIEW_BASE_COLOR;
            
            cell.leftLabel.text = [NSString stringWithFormat:@"%@",self.nameArray[indexPath.row - 1]];
            
            
            CGFloat procount = [self.procountArray[indexPath.row -1] floatValue];
            cell.rightLabel.text = [NSString stringWithFormat:@"%.2f%%",procount];
            
            return cell;
            
        }
        
    }else if (indexPath.section == 1){
        
        if (indexPath.row == 0) {
            
            ExeTopCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ExeTopCellID" forIndexPath:indexPath];
            if (!cell) {
                cell = [[ExeTopCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ExeTopCellID"];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.backgroundColor = VIEW_BASE_COLOR;
            
            cell.leftLabel.text = @"产品名称";
            cell.rightLabel.text = @"放款金额比例";
            
            return cell;
            
        }else{
            
            ExeOrderListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ExeOrderListCellID" forIndexPath:indexPath];
            if (!cell) {
                cell = [[ExeOrderListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ExeOrderListCellID"];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = VIEW_BASE_COLOR;
            
            cell.leftLabel.text = [NSString stringWithFormat:@"%@",self.nameArray1[indexPath.row - 1]];
            
            
            NSString *string = [NSString stringWithFormat:@"%@",self.promoneyArray[indexPath.row-1]];
            if (string.length == 0 || [string isEqualToString:@""] || string == nil || string == NULL || [string isEqual:[NSNull null]] || [string isEqualToString:@"(null)"] || [string isEqualToString:@"<null>"] || [string isEqualToString:@"null"]) {
                string = @"0.00";
                
            }
            CGFloat procount = [string floatValue];
            cell.rightLabel.text = [NSString stringWithFormat:@"%.2f%%",procount];
            
            return cell;
            
        }
        
    }
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, self.view.frame.size.width, 50);
    button.backgroundColor = [UIColor whiteColor];
    [button setTitle:_mainArray[section] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    
    button.tag = section;
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetHeight(button.frame)-0.5, CGRectGetWidth(button.frame), 0.5)];
    line.backgroundColor = GRAY229;
    [button addSubview:line];
    
    
    if (section == 0) {
        
        [button addTarget:self action:@selector(buttonEvent:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel * rightLabel = [[UILabel alloc]init];
        rightLabel.textAlignment = NSTextAlignmentRight;
        rightLabel.font = [UIFont systemFontOfSize:15];
        rightLabel.textColor = TABBAR_BASE_COLOR;
        [button addSubview:rightLabel];
        [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(button.mas_right).offset(-35);
            make.centerY.mas_equalTo(button.mas_centerY);
            make.width.mas_equalTo(200);
            make.height.mas_equalTo(30);
            
            
        }];
        rightLabel.text = [NSString stringWithFormat:@"%@",self.dataDic[@"totalOrder"]];
        
        UIImageView* foldImage = [[UIImageView alloc]init];
        foldImage.contentMode = UIViewContentModeScaleAspectFit;
        [button addSubview:foldImage];
        [foldImage mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(button.mas_right).offset(-8);
            make.centerY.mas_equalTo(button.mas_centerY);
            make.width.mas_equalTo(20);
            make.height.mas_equalTo(10);
            
        }];
        
        if (self.isFold1 == 1) {
            
            foldImage.image = [UIImage imageNamed:@"箭头（上）"];
            
            
        }else{
            
            foldImage.image = [UIImage imageNamed:@"箭头（下）"];
            
        }
        
        foldImage.tag = 10;
        
        
    }else if (section == 1){
        
        [button addTarget:self action:@selector(buttonEvent:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel * rightLabel = [[UILabel alloc]init];
        rightLabel.textAlignment = NSTextAlignmentRight;
        rightLabel.font = [UIFont systemFontOfSize:15];
        rightLabel.textColor = TABBAR_BASE_COLOR;
        [button addSubview:rightLabel];
        [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(button.mas_right).offset(-35);
            make.centerY.mas_equalTo(button.mas_centerY);
            make.width.mas_equalTo(200);
            make.height.mas_equalTo(30);
            
            
        }];
        rightLabel.text = [NSString stringWithFormat:@"%@万元",self.dataDic[@"FKmoney"]];
        
        UIImageView* foldImage = [[UIImageView alloc]init];
        foldImage.contentMode = UIViewContentModeScaleAspectFit;
        
        if (self.isFold2 == 1) {
            
            foldImage.image = [UIImage imageNamed:@"箭头（上）"];
            
            
        }else{
            
            foldImage.image = [UIImage imageNamed:@"箭头（下）"];
            
        }
        [button addSubview:foldImage];
        [foldImage mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(button.mas_right).offset(-8);
            make.centerY.mas_equalTo(button.mas_centerY);
            make.width.mas_equalTo(20);
            make.height.mas_equalTo(10);
            
        }];
        
        foldImage.tag = 11;
        
    }else if (section == 2){
        
        UILabel * rightLabel = [[UILabel alloc]init];
        rightLabel.textAlignment = NSTextAlignmentRight;
        rightLabel.font = [UIFont systemFontOfSize:15];
        rightLabel.textColor = TABBAR_BASE_COLOR;
        [button addSubview:rightLabel];
        [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(button.mas_right).offset(-8);
            make.centerY.mas_equalTo(button.mas_centerY);
            make.width.mas_equalTo(200);
            make.height.mas_equalTo(30);
            
            
        }];
        
        rightLabel.text = [NSString stringWithFormat:@"%@万元",self.dataDic[@"DFKmoney"]];
        
    }else if (section == 3){
        
        UILabel * rightLabel = [[UILabel alloc]init];
        rightLabel.textAlignment = NSTextAlignmentRight;
        rightLabel.font = [UIFont systemFontOfSize:15];
        rightLabel.textColor = TABBAR_BASE_COLOR;
        [button addSubview:rightLabel];
        [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(button.mas_right).offset(-8);
            make.centerY.mas_equalTo(button.mas_centerY);
            make.width.mas_equalTo(200);
            make.height.mas_equalTo(30);
            
            
        }];
        
        rightLabel.text = [NSString stringWithFormat:@"%@万元",self.dataDic[@"mechSerMoney"]];
        
    }
    
    return button;
}

- (void)buttonEvent:(UIButton *)sender
{
    if (sender.tag == 0) {
        if (self.isFold1 == 1) {
            
            self.isFold1 = 0;
            
        }else{
            
            self.isFold1 = 1;
        }
        
    }
    
    if (sender.tag == 1) {
        
        if (self.isFold2 == 1) {
            
            self.isFold2 = 0;
            
        }else{
            
            self.isFold2 = 1;
        }
        
    }
    
    
    _sectionSelect[sender.tag] = !_sectionSelect[sender.tag];
    
    [_exeResultTableView reloadData];
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

-(NSMutableArray *)nameArray1{
    
    if (_nameArray1 == nil) {
        _nameArray1 = [[NSMutableArray alloc]init];
    }
    return _nameArray1;
}

-(NSMutableArray *)promoneyArray{
    
    if (_promoneyArray == nil) {
        
        _promoneyArray = [[NSMutableArray alloc]init];
    }
    return _promoneyArray;
    
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
