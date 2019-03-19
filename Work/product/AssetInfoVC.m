//
//  AssetInfoVC.m
//  Financeteam
//
//  Created by 张正飞 on 16/6/12.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "AssetInfoVC.h"
#import "FDAlertView.h"
#import "RBCustomDatePickerView.h"

#import "TwoLabelCell.h"
#import "PersonInfoTextViewCell.h"
#import "OneButtonCell.h"
#import "AddressChoicePickerView.h"

#import "ButtonsModel.h"
#import "ButtonsCell.h"

@interface AssetInfoVC ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray * assetInfo;
    
    UITableView* _assetInfoTableView;
    
    NSMutableArray * buttonData;
}

@end

@implementation AssetInfoVC
static NSString *returnString;
static NSString *returnTimeOneString;
static NSString *returnTimeTwoString;
- (void)viewWillAppear:(BOOL)animated {
    returnString = @" ";
    returnTimeOneString = @" ";
    returnTimeTwoString = @" ";
    if (![returnString  isEqualToString:@" "]) {
        [_assetInfoTableView reloadData];
    }else if (![returnTimeOneString isEqualToString:@" "]){
        [_assetInfoTableView reloadData];
    }else if (![returnTimeTwoString isEqualToString:@" "]){
        [_assetInfoTableView reloadData];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadData];
    [self creatUI];

    
}

-(void)loadData{
    assetInfo = [@[@"房产类型",@"购买单价",@"房产地址",@"房产详细地址",@"购买日期",@"建筑面积",@"产权比例",@"贷款年限",@"月供",@"贷款余额",@"车辆品牌",@"购买价格",@"月供贷款",@"购买时间"] mutableCopy];
    
    ButtonsModel * model = [[ButtonsModel alloc]init];
    
    model.name = @"房产类型";;
    model.BtnArr = [NSMutableArray arrayWithObjects:@"按揭房",@"自建房",@"全款房",@"其他", nil];
    model.index = 0;
    
    buttonData = [NSMutableArray arrayWithObjects:model, nil];
}

-(void)creatUI{
    
    _assetInfoTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64-40) style:UITableViewStylePlain];
    _assetInfoTableView.delegate=self;
    _assetInfoTableView.dataSource = self;
    //  _psTableView.userInteractionEnabled = NO;
    _assetInfoTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    [self.view addSubview:_assetInfoTableView];
    
    [_assetInfoTableView registerNib:[UINib nibWithNibName:@"TwoLabelCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"TwoLabelCellID"];

    [_assetInfoTableView registerNib:[UINib nibWithNibName:@"PersonInfoTextViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"PersonInfoTextCellID"];
    
    [_assetInfoTableView registerNib:[UINib nibWithNibName:@"OneButtonCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"OneButtonID"];

    [_assetInfoTableView registerClass:[ButtonsCell class] forCellReuseIdentifier:@"ButtonsModelID"];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 14;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellID"];
    }
    if (indexPath.row == 0) {
        ButtonsCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ButtonsModelID"];
        if (cell == nil) {
            cell = [[ButtonsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ButtonsModelID"];
        }
        ButtonsModel * nodeData = buttonData[0];
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
        if ([nodeData.name isEqualToString:@"房产类型"]) {
            for (int i=0; i<nodeData.BtnArr.count; i++) {
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.tag = i+70;
                if (nodeData.index == i+70) {
                    btn.selected = YES;
                }
                [btn setImage:[UIImage imageNamed:@"单选框"] forState:UIControlStateNormal];
                [btn setImage:[UIImage imageNamed:@"单选框（亮）"] forState:UIControlStateSelected];
                [btn setTitle:nodeData.BtnArr[i] forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                btn.titleLabel.font = [UIFont systemFontOfSize:13];
                [btn addTarget:self action:@selector(ButtonsOnClick:) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:btn];
                [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(titleLB.mas_right).offset((60*KAdaptiveRateWidth+1*KAdaptiveRateWidth)*(i%3)+10*KAdaptiveRateWidth);
                    make.top.equalTo(cell.mas_top).offset((25)*(i/3)+2);
                    
                    make.height.mas_equalTo(16);
                    
                }];
            }
        }
        return cell;

    }
    
    
     else if  (indexPath.row == 1) {
        TwoLabelCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TwoLabelCellID"];
        cell.nameLabel.text = assetInfo[indexPath.row];
        cell.rightLabel.text = @"元/㎡";
        return cell;
    }else if (indexPath.row == 2){
        OneButtonCell * cell = [tableView dequeueReusableCellWithIdentifier:@"OneButtonID"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.nameLabel.text = assetInfo[indexPath.row];
        
        cell.oneButton.tag = indexPath.row;
        [cell.oneButton setTitle:returnString forState:UIControlStateNormal];
        [cell.oneButton addTarget:self action:@selector(addressChoiceBtn:) forControlEvents:UIControlEventTouchUpInside];

        return cell;
    }else if (indexPath.row == 4){
        OneButtonCell * cell = [tableView dequeueReusableCellWithIdentifier:@"OneButtonID"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.nameLabel.text = assetInfo[indexPath.row];
        
        cell.oneButton.tag = indexPath.row;
        [cell.oneButton addTarget:self action:@selector(timeChoiceBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell.oneButton setTitle:returnTimeOneString forState:UIControlStateNormal];
        
        return cell;
    }
    else if (indexPath.row == 5){
        TwoLabelCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TwoLabelCellID"];
        cell.nameLabel.text = assetInfo[indexPath.row];
        cell.rightLabel.text = @"元/㎡";
        return cell;
        
    }else if (indexPath.row == 6){
        TwoLabelCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TwoLabelCellID"];
        cell.nameLabel.text = assetInfo[indexPath.row];
        cell.rightLabel.text = @"%";
        return cell;
        
    }
    else if (indexPath.row == 7){
        TwoLabelCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TwoLabelCellID"];
        cell.nameLabel.text = assetInfo[indexPath.row];
        cell.rightLabel.text = @"年";
        return cell;
        
    }
    else if (indexPath.row == 8){
        TwoLabelCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TwoLabelCellID"];
        cell.nameLabel.text = assetInfo[indexPath.row];
        cell.rightLabel.text = @"元";
        return cell;
        
    }
    else if (indexPath.row == 9){
        TwoLabelCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TwoLabelCellID"];
        cell.nameLabel.text = assetInfo[indexPath.row];
        cell.rightLabel.text = @"万元";
        return cell;
        
    }else if (indexPath.row == 11){
        TwoLabelCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TwoLabelCellID"];
        cell.nameLabel.text = assetInfo[indexPath.row];
        cell.rightLabel.text = @"万元";
        return cell;
        
    }else if (indexPath.row == 12){
        TwoLabelCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TwoLabelCellID"];
        cell.nameLabel.text = assetInfo[indexPath.row];
        cell.rightLabel.text = @"元";
        return cell;
        
    }else if (indexPath.row == 3){
        PersonInfoTextViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PersonInfoTextCellID"];
        
        cell.personInfoLabel.text = assetInfo[indexPath.row];
        
        return cell;
    }else if (indexPath.row == 10){
        PersonInfoTextViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PersonInfoTextCellID"];
        
        cell.personInfoLabel.text = assetInfo[indexPath.row];
        
        return cell;
    }else if (indexPath.row == 13){
        OneButtonCell * cell = [tableView dequeueReusableCellWithIdentifier:@"OneButtonID"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.nameLabel.text = assetInfo[indexPath.row];
        
        cell.oneButton.tag = indexPath.row;
        
        [cell.oneButton addTarget:self action:@selector(timeChoiceBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell.oneButton setTitle:returnTimeTwoString forState:UIControlStateNormal];

        return cell;
    }


    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    _assetInfoTableView.estimatedRowHeight = 20;
    _assetInfoTableView.rowHeight = UITableViewAutomaticDimension;
    return _assetInfoTableView.rowHeight;
    
}

-(void)ButtonsOnClick:(UIButton *)sender{
    
    if (sender.tag == 70 || sender.tag == 71 || sender.tag == 72 || sender.tag == 73) {
        ButtonsModel * model1 = buttonData[0];
        
        model1.index = sender.tag;
        [_assetInfoTableView reloadData];
    }
}

-(void)addressChoiceBtn:(UIButton *)sender{
    if (sender.tag == 2) {
        AddressChoicePickerView *addressPickerView = [[AddressChoicePickerView alloc]init];
        addressPickerView.block = ^(AddressChoicePickerView *view,UIButton *btn,AreaObject *locate){
            // self.addressLabel.text = [NSString stringWithFormat:@"%@",locate];
            // self.addressLabel.textColor = [UIColor blackColor];
            
            
            returnString  = [NSString stringWithFormat:@"%@",locate];
            
            [sender setTitle:returnString forState:UIControlStateNormal];
            
        };
        [addressPickerView show];

    }
    
}

-(void)timeChoiceBtn:(UIButton *)btn{
    if (btn.tag == 4) {
        FDAlertView *alert = [[FDAlertView alloc] init];
        
        RBCustomDatePickerView * contentView=[[RBCustomDatePickerView alloc]init];
        contentView.delegate=self;
        contentView.frame = CGRectMake(0, 0, 320, 300);
        
        alert.contentView = contentView;
        [alert show];

    }else if (btn.tag ==13){
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
    returnTimeOneString = theTimeStr;
    [_assetInfoTableView reloadData];
    NSLog(@"我获取到时间了，时间是===%@",theTimeStr);
    
    returnTimeTwoString = theTimeStr;
    [_assetInfoTableView reloadData];
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
