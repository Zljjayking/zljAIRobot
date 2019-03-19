//
//  PersonalInfoVC.m
//  Financeteam
//
//  Created by 张正飞 on 16/6/12.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "PersonalInfoVC.h"

#import "AddressChoicePickerView.h"
#import "FDAlertView.h"
#import "RBCustomDatePickerView.h"

#import "PersonInfoTextViewCell.h"
#import "TwoButtonCell.h"
#import "ThreeButtonCell.h"
#import "FourButtonCell.h"
#import "MaxStudyCell.h"
#import "OneButtonCell.h"
#import "EightButtonCell.h"

#import "ButtonsCell.h"
#import "ButtonsModel.h"

@interface PersonalInfoVC ()<UITableViewDelegate,UITableViewDataSource>

{
    NSMutableArray * personalInfo;
    
    UITableView* _personalInfoTableView;
}
@property(nonatomic,strong)NSMutableArray * buttonArray;

@end

@implementation PersonalInfoVC
static NSString *returnString;
static NSString *returnTimeString;
- (void)viewWillAppear:(BOOL)animated {
    returnString = @" ";
    returnTimeString = @" ";
    if (![returnString  isEqualToString:@" "]) {
        [_personalInfoTableView reloadData];
    }else if (![returnTimeString isEqualToString:@" "]){
        [_personalInfoTableView reloadData];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    [self creatUI];
}

-(void)loadData{
    
    personalInfo = [@[@"姓        名",@"性        别",@"移动电话",@"证件类型",@"证件号码",@"婚姻状况",@"子       女",@"最高学历",@"Q        Q",@"邮       箱",@"户口所在地",@"户口详细地址",@"户口邮政编码",@"现住宅地址",@"住宅详细地址",@"住宅邮政编码",@"现住宅类型",@"住宅电话",@"来本地时间",@"起始居住时间"] mutableCopy];

    ButtonsModel * model1 = [[ButtonsModel alloc]init];
    model1.name = @"性        别";
    model1.BtnArr = [NSMutableArray arrayWithObjects:@"男", @"女",nil];
    model1.index = 0;
    
    ButtonsModel * model2 = [[ButtonsModel alloc]init];
    model2.name = @"证件类型";
    model2.BtnArr = [NSMutableArray arrayWithObjects:@"身份证",@"护照",@"军官证", nil];
    model2.index = 0;
    
    ButtonsModel * model3 = [[ButtonsModel alloc]init];
    model3.name = @"婚姻状况";
    model3.BtnArr = [NSMutableArray arrayWithObjects:@"已婚",@"未婚",@"离异",@"丧偶", nil];
    model3.index = 0;
    
    ButtonsModel * model4 = [[ButtonsModel alloc]init];
    model4.name = @"子       女";
    model4.BtnArr = [NSMutableArray arrayWithObjects:@"有",@"无", nil];
    model4.index = 0;
    
    ButtonsModel * model5 = [[ButtonsModel alloc]init];
    model5.name = @"最高学历";
    model5.BtnArr = [NSMutableArray arrayWithObjects:@"本科及以上",@"大专",@"高中",@"高中以下", nil];
    model5.index = 0;
    
    ButtonsModel * model6 = [[ButtonsModel alloc]init];
    model6.name = @"现住宅类型";
    model6.BtnArr = [NSMutableArray arrayWithObjects:@"租用",@"商业按揭购房",@"公积金按揭购房",@"全款商品房",@"自建房",@"家族房",@"单位宿舍",@"其他", nil];
    model6.index = 0;
    
    
    _buttonArray = [NSMutableArray arrayWithObjects:model1,model2,model3,model4,model5,model6, nil];
    
}

-(void)creatUI{
    
    _personalInfoTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64-40) style:UITableViewStylePlain];
    _personalInfoTableView.delegate=self;
    _personalInfoTableView.dataSource = self;
    //  _psTableView.userInteractionEnabled = NO;
    _personalInfoTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    [self.view addSubview:_personalInfoTableView];
    
    
    [_personalInfoTableView registerNib:[UINib nibWithNibName:@"PersonInfoTextViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"PersonInfoTextViewCellID"];
    
     [_personalInfoTableView registerNib:[UINib nibWithNibName:@"OneButtonCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"OneButtonCellID"];
    
    [_personalInfoTableView registerClass:[ButtonsCell class] forCellReuseIdentifier:@"ButtonsID"];

}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellID"];
    }
    
    if (indexPath.row == 0 ) {
        PersonInfoTextViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PersonInfoTextViewCellID"];
        
        cell.personInfoLabel.text = personalInfo[indexPath.row];
        return cell;
    }else if (indexPath.row == 1){
        ButtonsCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ButtonsID"];
        if (cell == nil) {
            cell = [[ButtonsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ButtonsID"];
        }
        ButtonsModel * nodeData = _buttonArray[0];
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
        if ([nodeData.name isEqualToString:@"性        别"]) {
            for (int i=0; i<nodeData.BtnArr.count; i++) {
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.tag = i+10;
                if (nodeData.index == i+10) {
                    btn.selected = YES;
                }
                [btn setImage:[UIImage imageNamed:@"单选框"] forState:UIControlStateNormal];
                [btn setImage:[UIImage imageNamed:@"单选框（亮）"] forState:UIControlStateSelected];
                [btn setTitle:nodeData.BtnArr[i] forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                btn.titleLabel.font = [UIFont systemFontOfSize:13];
                [btn addTarget:self action:@selector(ButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:btn];
                [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(titleLB.mas_right).offset((50*KAdaptiveRateWidth+2*KAdaptiveRateWidth)*i+10*KAdaptiveRateWidth);
                    make.centerY.mas_equalTo(cell.mas_centerY);
                    make.height.mas_equalTo(14);
                    
                }];
            }
        }
        return cell;

    }
    else if (indexPath.row == 2){
        PersonInfoTextViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PersonInfoTextViewCellID"];
        
        cell.personInfoLabel.text = personalInfo[indexPath.row];
        return cell;
    }else if (indexPath.row == 3){
        
        ButtonsCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ButtonsID"];
        if (cell == nil) {
            cell = [[ButtonsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ButtonsID"];
        }
        ButtonsModel * nodeData = _buttonArray[1];
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
        if ([nodeData.name isEqualToString:@"证件类型"]) {
            for (int i=0; i<nodeData.BtnArr.count; i++) {
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.tag = i+20;
                if (nodeData.index == i+20) {
                    btn.selected = YES;
                }
                [btn setImage:[UIImage imageNamed:@"单选框"] forState:UIControlStateNormal];
                [btn setImage:[UIImage imageNamed:@"单选框（亮）"] forState:UIControlStateSelected];
                [btn setTitle:nodeData.BtnArr[i] forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                btn.titleLabel.font = [UIFont systemFontOfSize:13];
                [btn addTarget:self action:@selector(ButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:btn];
                [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(titleLB.mas_right).offset((60*KAdaptiveRateWidth+5*KAdaptiveRateWidth)*i+10*KAdaptiveRateWidth);
                    make.centerY.mas_equalTo(cell.mas_centerY);
                    make.height.mas_equalTo(14);
                    
                }];
            }
        }
        return cell;
        
    }
    else if (indexPath.row == 4){
        PersonInfoTextViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PersonInfoTextViewCellID"];
        
        cell.personInfoLabel.text = personalInfo[indexPath.row];
        return cell;
    }else if (indexPath.row == 5){
        ButtonsCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ButtonsID"];
        if (cell == nil) {
            cell = [[ButtonsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ButtonsID"];
        }
        ButtonsModel * nodeData = _buttonArray[2];
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
        if ([nodeData.name isEqualToString:@"婚姻状况"]) {
            for (int i=0; i<nodeData.BtnArr.count; i++) {
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.tag = i+30;
                if (nodeData.index == i+30) {
                    btn.selected = YES;
                }
                [btn setImage:[UIImage imageNamed:@"单选框"] forState:UIControlStateNormal];
                [btn setImage:[UIImage imageNamed:@"单选框（亮）"] forState:UIControlStateSelected];
                [btn setTitle:nodeData.BtnArr[i] forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                btn.titleLabel.font = [UIFont systemFontOfSize:13];
                [btn addTarget:self action:@selector(ButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:btn];
                [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(titleLB.mas_right).offset((50*KAdaptiveRateWidth+5*KAdaptiveRateWidth)*i+10*KAdaptiveRateWidth);
                    make.centerY.mas_equalTo(cell.mas_centerY);
                    make.height.mas_equalTo(14);
                    
                }];
            }
        }
        return cell;

    }
    else if (indexPath.row == 6){
        
        ButtonsCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ButtonsID"];
        if (cell == nil) {
            cell = [[ButtonsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ButtonsID"];
        }
        ButtonsModel * nodeData = _buttonArray[3];
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
        if ([nodeData.name isEqualToString:@"子       女"]) {
            for (int i=0; i<nodeData.BtnArr.count; i++) {
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.tag = i+40;
                if (nodeData.index == i+40) {
                    btn.selected = YES;
                }
                [btn setImage:[UIImage imageNamed:@"单选框"] forState:UIControlStateNormal];
                [btn setImage:[UIImage imageNamed:@"单选框（亮）"] forState:UIControlStateSelected];
                [btn setTitle:nodeData.BtnArr[i] forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                btn.titleLabel.font = [UIFont systemFontOfSize:13];
                [btn addTarget:self action:@selector(ButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:btn];
                [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(titleLB.mas_right).offset((50*KAdaptiveRateWidth+2*KAdaptiveRateWidth)*i+10*KAdaptiveRateWidth);
                    make.centerY.mas_equalTo(cell.mas_centerY);
                    make.height.mas_equalTo(14);
                    
                }];
            }
        }
        return cell;
        

        
    }else if (indexPath.row == 7){
        
        ButtonsCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ButtonsID"];
        if (cell == nil) {
            cell = [[ButtonsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ButtonsID"];
        }
        ButtonsModel * nodeData = _buttonArray[4];
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
        if ([nodeData.name isEqualToString:@"最高学历"]) {
            for (int i=0; i<nodeData.BtnArr.count; i++) {
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.tag = i+50;
                if (nodeData.index == i+50) {
                    btn.selected = YES;
                }
                [btn setImage:[UIImage imageNamed:@"单选框"] forState:UIControlStateNormal];
                [btn setImage:[UIImage imageNamed:@"单选框（亮）"] forState:UIControlStateSelected];
                [btn setTitle:nodeData.BtnArr[i] forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                btn.titleLabel.font = [UIFont systemFontOfSize:13];
                [btn addTarget:self action:@selector(ButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:btn];
                [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(titleLB.mas_right).offset((90*KAdaptiveRateWidth+5*KAdaptiveRateWidth)*(i%2)+10*KAdaptiveRateWidth);
                    make.top.equalTo(cell.mas_top).offset((25)*(i/2)+10);
                    
                    make.height.mas_equalTo(16);
                    
                }];
            }
        }
        return cell;
    }
    
    else if (indexPath.row == 8){
        PersonInfoTextViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PersonInfoTextViewCellID"];
        
        cell.personInfoLabel.text = personalInfo[indexPath.row];
        return cell;
    }else if (indexPath.row == 9){
        PersonInfoTextViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PersonInfoTextViewCellID"];
        
        cell.personInfoLabel.text = personalInfo[indexPath.row];
        return cell;
    }else if (indexPath.row == 10){
        OneButtonCell * cell = [tableView dequeueReusableCellWithIdentifier:@"OneButtonCellID"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.nameLabel.text = personalInfo[indexPath.row];
        
        cell.oneButton.tag = indexPath.row;
        [cell.oneButton setTitle:returnString forState:UIControlStateNormal];
        [cell.oneButton addTarget:self action:@selector(addressChoiceBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }
    else if (indexPath.row == 11){
        PersonInfoTextViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PersonInfoTextViewCellID"];
        
        cell.personInfoLabel.text = personalInfo[indexPath.row];
        return cell;
    }else if (indexPath.row == 12){
        PersonInfoTextViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PersonInfoTextViewCellID"];
        
        cell.personInfoLabel.text = personalInfo[indexPath.row];
        return cell;
    }else if (indexPath.row == 13){
        OneButtonCell * cell = [tableView dequeueReusableCellWithIdentifier:@"OneButtonCellID"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.nameLabel.text = personalInfo[indexPath.row];
        
        cell.oneButton.tag = indexPath.row;
        [cell.oneButton setTitle:returnString forState:UIControlStateNormal];
        [cell.oneButton addTarget:self action:@selector(addressChoiceBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }else if (indexPath.row == 14){
        PersonInfoTextViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PersonInfoTextViewCellID"];
        
        cell.personInfoLabel.text = personalInfo[indexPath.row];
        return cell;
    }else if (indexPath.row == 15){
        PersonInfoTextViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PersonInfoTextViewCellID"];
        
        cell.personInfoLabel.text = personalInfo[indexPath.row];
        return cell;
    }else if (indexPath.row == 16){
        
        
        ButtonsCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ButtonsID"];
        if (cell == nil) {
            cell = [[ButtonsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ButtonsID"];
        }
        ButtonsModel * nodeData = _buttonArray[5];
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
        if ([nodeData.name isEqualToString:@"现住宅类型"]) {
            for (int i=0; i<nodeData.BtnArr.count; i++) {
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.tag = i+60;
                if (nodeData.index == i+60) {
                    btn.selected = YES;
                }
                [btn setImage:[UIImage imageNamed:@"单选框"] forState:UIControlStateNormal];
                [btn setImage:[UIImage imageNamed:@"单选框（亮）"] forState:UIControlStateSelected];
                [btn setTitle:nodeData.BtnArr[i] forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                btn.titleLabel.font = [UIFont systemFontOfSize:13];
                [btn addTarget:self action:@selector(ButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:btn];
                [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(titleLB.mas_right).offset((100*KAdaptiveRateWidth+5*KAdaptiveRateWidth)*(i%2)+10*KAdaptiveRateWidth);
                    make.top.equalTo(cell.mas_top).offset((21)*(i/2)+9);
                    
                    
                    make.height.mas_equalTo(16);
                    
                }];
            }
        }
        return cell;
    }
    else if (indexPath.row == 17){
        PersonInfoTextViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PersonInfoTextViewCellID"];
        
        cell.personInfoLabel.text = personalInfo[indexPath.row];
        return cell;
    }else if (indexPath.row == 18){
        OneButtonCell * cell = [tableView dequeueReusableCellWithIdentifier:@"OneButtonCellID"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.nameLabel.text = personalInfo[indexPath.row];
        
        cell.oneButton.tag = indexPath.row;
        [cell.oneButton setTitle:returnTimeString forState:UIControlStateNormal];
        [cell.oneButton addTarget:self action:@selector(timeChoiceBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;

    }else if (indexPath.row == 19){
        OneButtonCell * cell = [tableView dequeueReusableCellWithIdentifier:@"OneButtonCellID"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.nameLabel.text = personalInfo[indexPath.row];
        
        cell.oneButton.tag = indexPath.row;
        [cell.oneButton setTitle:returnTimeString forState:UIControlStateNormal];
        [cell.oneButton addTarget:self action:@selector(timeChoiceBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
        
    }

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1 || indexPath.row == 6 || indexPath.row == 3 || indexPath.row == 5 || indexPath.row == 10 || indexPath.row == 13) {
        return [UIAdaption getAdaptiveHeightWith6Height:55];
    }else if (indexPath.row == 7){
        return [UIAdaption getAdaptiveHeightWith6Height:75];
    }else if (indexPath.row == 16){
        return [UIAdaption getAdaptiveHeightWith6Height:115];
    }
    else{
    _personalInfoTableView.estimatedRowHeight = 20;
    _personalInfoTableView.rowHeight = UITableViewAutomaticDimension;
    return _personalInfoTableView.rowHeight;
    }
}

-(void)ButtonOnClick:(UIButton *)sender{
    if (sender.tag == 10 || sender.tag == 11) {
        ButtonsModel * model1 = _buttonArray[0];
        
        model1.index = sender.tag;
        [_personalInfoTableView reloadData];
    }else if (sender.tag == 20 || sender.tag == 21 || sender.tag == 22){
        ButtonsModel * model2 = _buttonArray[1];
        
        model2.index = sender.tag;
        [_personalInfoTableView reloadData];
    }else if (sender.tag == 30 || sender.tag == 31 || sender.tag == 32 || sender.tag == 33){
        
        ButtonsModel * model3 = _buttonArray[2];
        
        model3.index = sender.tag;
        
        [_personalInfoTableView reloadData];
    }else if (sender.tag == 40 || sender.tag == 41 || sender.tag == 42 || sender.tag == 43){
        
        ButtonsModel * model4 = _buttonArray[3];
        
        model4.index = sender.tag;
        
        [_personalInfoTableView reloadData];
    }else if (sender.tag == 50 || sender.tag == 51 || sender.tag == 52 || sender.tag == 53){
        
        ButtonsModel * model5 = _buttonArray[4];
        
        model5.index = sender.tag;
        
        [_personalInfoTableView reloadData];
    }else if (sender.tag == 60 || sender.tag == 61 || sender.tag == 62 || sender.tag == 63 || sender.tag == 64 || sender.tag == 65 || sender.tag == 66 || sender.tag == 67){
        
        ButtonsModel * model6 = _buttonArray[5];
        
        model6.index = sender.tag;
        
        [_personalInfoTableView reloadData];
    }



    
    
}

-(void)addressChoiceBtn:(UIButton *)sender{
    if (sender.tag == 10 || sender.tag == 13) {
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
    if (btn.tag == 18) {
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
    [_personalInfoTableView reloadData];
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
