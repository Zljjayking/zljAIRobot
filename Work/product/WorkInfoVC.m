//
//  WorkInfoVC.m
//  Financeteam
//
//  Created by 张正飞 on 16/6/12.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "WorkInfoVC.h"

#import "AddressChoicePickerView.h"
#import "FDAlertView.h"
#import "RBCustomDatePickerView.h"

#import "PersonInfoTextViewCell.h"
#import "OneButtonCell.h"
#import "PersonServiceCell.h"

#import "ButtonsCell.h"
#import "ButtonsModel.h"

@interface WorkInfoVC ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray * workInfo;
    
    UITableView* _workInfoTableView;
    
    NSMutableArray * buttonsArray;
}

@end

@implementation WorkInfoVC

static NSString *returnAddressString;
static NSString *returnTimeString;
- (void)viewWillAppear:(BOOL)animated {
    returnAddressString = @" ";
    returnTimeString = @" ";
    if (![returnAddressString  isEqualToString:@" "]) {
        [_workInfoTableView reloadData];
    }else if (![returnTimeString isEqualToString:@" "]){
        [_workInfoTableView reloadData];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadData];
    [self creatUI];
    

}

-(void)loadData{
    
    workInfo = [@[@"单位名称",@"单位地址",@"单位详细地址",@"单位性质",@"所属行业",@"单位电话",@"所属部门",@"担任职位",@"入职时间",@"月总收入(含其他收入)",@"发薪日",@"发薪形式"] mutableCopy];
    
    ButtonsModel * model = [[ButtonsModel alloc]init];
    model.name = @"单位性质";
    model.BtnArr = [NSMutableArray arrayWithObjects:@"行政事业单位",@"社会团体",@"国企",@"民营",@"外资",@"合资",@"私营",@"个体", nil];
    model.index = 0;
    
    ButtonsModel * model1 = [[ButtonsModel alloc]init];
    model1.name = @"发薪形式";
    model1.BtnArr = [NSMutableArray arrayWithObjects:@"银行代发",@"现金",@"网银", nil];
    model1.index = 0;
    
    buttonsArray = [NSMutableArray arrayWithObjects:model, model1,nil];
}

-(void)creatUI{
    
    _workInfoTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64-40) style:UITableViewStylePlain];
    _workInfoTableView.delegate=self;
    _workInfoTableView.dataSource = self;
    //  _psTableView.userInteractionEnabled = NO;
    _workInfoTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    [self.view addSubview:_workInfoTableView];
    
    [_workInfoTableView registerNib:[UINib nibWithNibName:@"PersonInfoTextViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"PersonInfoTextView"];
    
    [_workInfoTableView registerNib:[UINib nibWithNibName:@"OneButtonCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"OneButtonCellId"];
    
     [_workInfoTableView registerNib:[UINib nibWithNibName:@"PersonServiceCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"PersonServiceCellId"];
    
    [_workInfoTableView registerClass:[ButtonsCell class] forCellReuseIdentifier:@"ButtonsModelID"];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 12;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WorkInfoID"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WorkInfoID"];
    }
    if (indexPath.row == 0) {
        PersonInfoTextViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PersonInfoTextView"];
        
        cell.personInfoLabel.text = workInfo[indexPath.row];
        
        return cell;

    }else if (indexPath.row == 1){
        OneButtonCell * cell = [tableView dequeueReusableCellWithIdentifier:@"OneButtonCellId"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.nameLabel.text = workInfo[indexPath.row];
        
        cell.oneButton.tag = indexPath.row;
        [cell.oneButton setTitle:returnAddressString forState:UIControlStateNormal];
        [cell.oneButton addTarget:self action:@selector(addressChoiceBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }else if (indexPath.row == 2){
        PersonInfoTextViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PersonInfoTextView"];
        
        cell.personInfoLabel.text = workInfo[indexPath.row];
        
        return cell;
    }else if (indexPath.row == 3){
        ButtonsCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ButtonsModelID"];
        if (cell == nil) {
            cell = [[ButtonsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ButtonsModelID"];
        }
        ButtonsModel * nodeData = buttonsArray[0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (nodeData.BtnArr.count != 0) {
            for (UIButton *btn in [cell subviews]) {
                [btn removeFromSuperview];
            }
        }
        UILabel *titleLB = [[UILabel alloc] init];
        titleLB.textColor = [UIColor blackColor];
        titleLB.font = [UIFont systemFontOfSize:14];
        [cell addSubview:titleLB];
        [titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.mas_left).offset(15*KAdaptiveRateWidth);
            make.centerY.mas_equalTo(cell.mas_centerY);
            make.height.mas_equalTo(17);
        }];
        titleLB.text = nodeData.name;
        if ([nodeData.name isEqualToString:@"单位性质"]) {
            for (int i=0; i<nodeData.BtnArr.count; i++) {
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.tag = i+80;
                if (nodeData.index == i+80) {
                    btn.selected = YES;
                }
                [btn setImage:[UIImage imageNamed:@"单选框"] forState:UIControlStateNormal];
                [btn setImage:[UIImage imageNamed:@"单选框（亮）"] forState:UIControlStateSelected];
                [btn setTitle:nodeData.BtnArr[i] forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                btn.titleLabel.font = [UIFont systemFontOfSize:13];
                [btn addTarget:self action:@selector(BtnsOnClick:) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:btn];
                if (i == 0) {
                    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(titleLB.mas_right).offset((90*KAdaptiveRateWidth+5*KAdaptiveRateWidth)*(i%1)+10*KAdaptiveRateWidth);
                        make.top.equalTo(cell.mas_top).offset(6);
                        make.height.mas_equalTo(16);
                        
                    }];
                } else {
                    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(titleLB.mas_right).offset((60*KAdaptiveRateWidth+5*KAdaptiveRateWidth)*((i-1)%4)+10*KAdaptiveRateWidth);
                        make.top.equalTo(cell.mas_top).offset((21)*(((i-1)/4)+1)+6);
                        make.height.mas_equalTo(16);
                        
                    }];
                }
            }
        }
        return cell;

    }
    else if (indexPath.row == 4){
        PersonInfoTextViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PersonInfoTextView"];
        
        cell.personInfoLabel.text = workInfo[indexPath.row];
        
        return cell;
    }
    else if (indexPath.row == 5){
        PersonInfoTextViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PersonInfoTextView"];
        
        cell.personInfoLabel.text = workInfo[indexPath.row];
        
        return cell;
    }
    else if (indexPath.row == 6){
        PersonInfoTextViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PersonInfoTextView"];
        
        cell.personInfoLabel.text = workInfo[indexPath.row];
        
        return cell;
    }else if (indexPath.row == 7){
        PersonInfoTextViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PersonInfoTextView"];
        
        cell.personInfoLabel.text = workInfo[indexPath.row];
        
        return cell;
    }else if (indexPath.row == 8){
        OneButtonCell * cell = [tableView dequeueReusableCellWithIdentifier:@"OneButtonCellId"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.nameLabel.text = workInfo[indexPath.row];
        
        cell.oneButton.tag = indexPath.row;
        
        [cell.oneButton addTarget:self action:@selector(timeChoiceBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell.oneButton setTitle:returnTimeString forState:UIControlStateNormal];
        
        return cell;

    }else if (indexPath.row == 9){
        
        PersonServiceCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PersonServiceCellId"];
        
        cell.leftLabel.text = workInfo[indexPath.row];
        cell.rightLabel.text = @"元";
        
        return cell;
    }else if (indexPath.row == 10){
        
        PersonServiceCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PersonServiceCellId"];
        
        cell.leftLabel.text = workInfo[indexPath.row];
        cell.rightLabel.text = @"日";
        
        return cell;
    }else if (indexPath.row == 11){
        
        
        ButtonsCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ButtonsID"];
        if (cell == nil) {
            cell = [[ButtonsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ButtonsID"];
        }
        ButtonsModel * nodeData = buttonsArray[1];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (nodeData.BtnArr.count != 0) {
            for (UIButton *btn in [cell subviews]) {
                [btn removeFromSuperview];
            }
        }
        UILabel *titleLB = [[UILabel alloc] init];
        titleLB.textColor = [UIColor blackColor];
        titleLB.font = [UIFont systemFontOfSize:13];
        [cell addSubview:titleLB];
        [titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.mas_left).offset(15*KAdaptiveRateWidth);
            make.centerY.mas_equalTo(cell.mas_centerY);
            make.height.mas_equalTo(17);
        }];
        titleLB.text = nodeData.name;
        if ([nodeData.name isEqualToString:@"发薪形式"]) {
            for (int i=0; i<nodeData.BtnArr.count; i++) {
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.tag = i+90;
                if (nodeData.index == i+90) {
                    btn.selected = YES;
                }
                [btn setImage:[UIImage imageNamed:@"单选框"] forState:UIControlStateNormal];
                [btn setImage:[UIImage imageNamed:@"单选框（亮）"] forState:UIControlStateSelected];
                [btn setTitle:nodeData.BtnArr[i] forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                btn.titleLabel.font = [UIFont systemFontOfSize:13];
                [btn addTarget:self action:@selector(BtnsOnClick:) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:btn];
                [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(titleLB.mas_right).offset((60*KAdaptiveRateWidth+10*KAdaptiveRateWidth)*i+10*KAdaptiveRateWidth);
                    make.centerY.mas_equalTo(cell.mas_centerY);
                    make.height.mas_equalTo(14);
                    
                }];
            }
        }
        return cell;

    }




    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 3) {
        return 70;
    }else{
    _workInfoTableView.estimatedRowHeight = 20;
    _workInfoTableView.rowHeight = UITableViewAutomaticDimension;
    return _workInfoTableView.rowHeight;
    }
}

-(void)BtnsOnClick:(UIButton *)sender{
    
    if (sender.tag == 80 || sender.tag == 81 || sender.tag == 82 || sender.tag == 83 || sender.tag == 84 || sender.tag == 85 || sender.tag == 86 || sender.tag == 87) {
        ButtonsModel * model = buttonsArray[0];
        
        model.index = sender.tag;
        [_workInfoTableView reloadData];
    }else if (sender.tag == 90 || sender.tag == 91 || sender.tag == 92){
        
        ButtonsModel * model1 =buttonsArray[1];
        model1.index = sender.tag;
        [_workInfoTableView reloadData];
    }
}


-(void)addressChoiceBtn:(UIButton *)sender{
    if (sender.tag == 1) {
        AddressChoicePickerView *addressPickerView = [[AddressChoicePickerView alloc]init];
        addressPickerView.block = ^(AddressChoicePickerView *view,UIButton *btn,AreaObject *locate){
            // self.addressLabel.text = [NSString stringWithFormat:@"%@",locate];
            // self.addressLabel.textColor = [UIColor blackColor];
            
            
            returnAddressString  = [NSString stringWithFormat:@"%@",locate];
            
            [sender setTitle:returnAddressString forState:UIControlStateNormal];
            
        };
        [addressPickerView show];
        
    }
    
}

-(void)timeChoiceBtn:(UIButton *)btn{
    
    if (btn.tag == 8) {
        FDAlertView *alert = [[FDAlertView alloc] init];
        
        RBCustomDatePickerView * contentView=[[RBCustomDatePickerView alloc]init];
        contentView.delegate=self;
        contentView.frame = CGRectMake(0, 0, 320, 300);
        
        alert.contentView = contentView;
        [alert show];

    }
 
}

-(void)getTimeToValue:(NSString *)theTimeStr
{
    returnTimeString = theTimeStr;
    [_workInfoTableView reloadData];
    NSLog(@"我获取到时间了，时间是===%@",theTimeStr);
    
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
