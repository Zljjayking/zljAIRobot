//
//  ConnectPeopleInfoVC.m
//  Financeteam
//
//  Created by 张正飞 on 16/6/12.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "ConnectPeopleInfoVC.h"
#import "LevelOneCell.h"
#import "LevelTwoCell.h"
#import "LevelOneModel.h"
#import "LevelTwoModel.h"
#import "CPITreeViewNode.h"

#import "longLabelModel.h"
#import "LongLabelCell.h"

#import "PersonInfoTextViewCell.h"
#import "CommonMoneyModel.h"

#import "ButtonsCell.h"
#import "ButtonsModel.h"

#import "RedLabelCell.h"
#import "RedLabelModel.h"

@interface ConnectPeopleInfoVC ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView * cpiTableView;
@property(strong,nonatomic) NSMutableArray* dataArray; //保存全部数据的数组
@property(strong,nonatomic) NSArray *displayArray;   //保存要显示在界面上的数据的数组


@end

@implementation ConnectPeopleInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _cpiTableView = [[UITableView alloc]init];
    _cpiTableView.delegate = self;
    _cpiTableView.dataSource = self;
    _cpiTableView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    [self.view addSubview:_cpiTableView];
    
    [_cpiTableView registerNib:[UINib nibWithNibName:@"LevelOneCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"LevelOneCellID"];
    
    [_cpiTableView registerNib:[UINib nibWithNibName:@"LevelTwoCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"LevelTwoCellID"];

    [_cpiTableView registerNib:[UINib nibWithNibName:@"LongLabelCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"LongLabelCellID"];
    
     [_cpiTableView registerNib:[UINib nibWithNibName:@"PersonInfoTextViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"PersonInfoTextViewCellID"];
    
    [_cpiTableView registerClass:[ButtonsCell class] forCellReuseIdentifier:@"ButtonsCellID"];
    
    [_cpiTableView registerNib:[UINib nibWithNibName:@"RedLabelCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"RedLabelCellID"];
    
    [self addData];
    
    [self reloadDataForDisplayArray];//初始化将要显示的数据
    
}

-(void)addData{
    CPITreeViewNode * node3 = [[CPITreeViewNode alloc]init];
    node3.nodeLevel = 0;//根层cell
    node3.type = 1;//type 1的cell
    node3.sonNodes = nil;
    node3.isExpanded = FALSE;//关闭状态
    LevelOneModel *tmp3 =[[LevelOneModel alloc]init];
    tmp3.name = @"配偶(直系)";
    tmp3.sonCount = @"7";
    node3.nodeData = tmp3;
    
    CPITreeViewNode * node4 = [[CPITreeViewNode alloc]init];
    node4.nodeLevel = 0;
    node4.type = 1;
    node4.sonNodes = nil;
    node4.isExpanded = FALSE;
    LevelOneModel *tmp4 =[[LevelOneModel alloc]init];
    tmp4.name = @"直系亲属";
    tmp4.sonCount = @"4";
    node4.nodeData = tmp4;
    
    CPITreeViewNode * node5 = [[CPITreeViewNode alloc]init];
    node5.nodeLevel = 0;
    node5.type = 1;
    node5.sonNodes = nil;
    node5.isExpanded = FALSE;
    LevelOneModel *tmp5=[[LevelOneModel alloc]init];
    tmp5.name = @"单位同事";
    tmp5.sonCount = @"4";
    node5.nodeData = tmp5;
    
    CPITreeViewNode * node6 = [[CPITreeViewNode alloc]init];
    node6.nodeLevel = 0;
    node6.type = 1;
    node6.sonNodes = nil;
    node6.isExpanded = FALSE;
    LevelOneModel *tmp6 =[[LevelOneModel alloc]init];
    tmp6.name = @"其他联系人";
    tmp6.sonCount = @"4";
    node6.nodeData = tmp6;
    
    CPITreeViewNode * node26 = [[CPITreeViewNode alloc]init];
    node26.nodeLevel = 0;
    node26.type = 3;
    node26.sonNodes = nil;
    node26.isExpanded = FALSE;
    longLabelModel *tmp26 = [[longLabelModel alloc]init];
    tmp26.longLabelString = @"以上哪些联系人可以知晓贷款";
    tmp26.longTextString = @" ";
    node26.nodeData = tmp26;
    
    CPITreeViewNode * node27 = [[CPITreeViewNode alloc]init];
    node27.nodeLevel = 0;
    node27.type = 4;
    node27.sonNodes = nil;
    node27.isExpanded = FALSE;
    CommonMoneyModel *tmp27 = [[CommonMoneyModel alloc]init];
    tmp27.commonMoneyString = @"共同贷款人";
    tmp27.commonMoneyText = @" ";
    node27.nodeData = tmp27;
    
    CPITreeViewNode * node28 = [[CPITreeViewNode alloc]init];
    node28.nodeLevel = 0;
    node28.type = 5;
    node28.sonNodes = nil;
    node28.isExpanded = FALSE;
    ButtonsModel * tmp28 = [[ButtonsModel alloc]init];
    tmp28.name = @"贷款用途";
    tmp28.BtnArr = [NSMutableArray arrayWithObjects:@"经营", @"消费",nil];
    tmp28.type = 1;
    tmp28.index = 0;
    node28.nodeData = tmp28;
    
    CPITreeViewNode * node29 = [[CPITreeViewNode alloc]init];
    node29.nodeLevel = 0;
    node29.type = 6;
    node29.sonNodes = nil;
    node29.isExpanded = FALSE;
    RedLabelModel * tmp29 = [[RedLabelModel alloc]init];
    tmp29.leftRedString = @"详细用途说明";
    tmp29.redString = @"(如不实将不能通过审核)";
    
    node29.nodeData = tmp29;


    
    //第一层节点
    CPITreeViewNode * node7 = [[CPITreeViewNode alloc]init];
    node7.nodeLevel = 1;//
    node7.type = 2;//type 2的cell
    node7.sonNodes = nil;
    node7.isExpanded = FALSE;//关闭状态
    LevelTwoModel *tmp7 =[[LevelTwoModel alloc]init];
    tmp7.nameString = @"姓名";
    tmp7.textString = @" ";
    node7.nodeData = tmp7;
    
    CPITreeViewNode * node8 = [[CPITreeViewNode alloc]init];
    node8.nodeLevel = 1;//
    node8.type = 2;//type 2的cell
    node8.sonNodes = nil;
    node8.isExpanded = FALSE;//关闭状态
    LevelTwoModel *tmp8 =[[LevelTwoModel alloc]init];
    tmp8.nameString = @"身份证号码";
    tmp8.textString = @" ";
    node8.nodeData = tmp8;
    
    CPITreeViewNode * node9 = [[CPITreeViewNode alloc]init];
    node9.nodeLevel = 1;//
    node9.type = 2;//type 2的cell
    node9.sonNodes = nil;
    node9.isExpanded = FALSE;//关闭状态
    LevelTwoModel *tmp9=[[LevelTwoModel alloc]init];
    tmp9.nameString = @"移动电话";
    tmp9.textString = @" ";
    node9.nodeData = tmp9;

    CPITreeViewNode * node10 = [[CPITreeViewNode alloc]init];
    node10.nodeLevel = 1;//
    node10.type = 2;//type 2的cell
    node10.sonNodes = nil;
    node10.isExpanded = FALSE;//关闭状态
    LevelTwoModel *tmp10 =[[LevelTwoModel alloc]init];
    tmp10.nameString = @"单位名称";
    tmp10.textString = @" ";
    node10.nodeData = tmp10;

    CPITreeViewNode * node11 = [[CPITreeViewNode alloc]init];
    node11.nodeLevel = 1;//
    node11.type = 2;//type 2的cell
    node11.sonNodes = nil;
    node11.isExpanded = FALSE;//关闭状态
    LevelTwoModel *tmp11 =[[LevelTwoModel alloc]init];
    tmp11.nameString = @"单位地址";
    tmp11.textString = @" ";
    node11.nodeData = tmp11;

    CPITreeViewNode * node12 = [[CPITreeViewNode alloc]init];
    node12.nodeLevel = 1;//
    node12.type = 2;//type 2的cell
    node12.sonNodes = nil;
    node12.isExpanded = FALSE;//关闭状态
    LevelTwoModel *tmp12 =[[LevelTwoModel alloc]init];
    tmp12.nameString = @"单位电话";
    tmp12.textString = @" ";
    node12.nodeData = tmp12;

    CPITreeViewNode * node13 = [[CPITreeViewNode alloc]init];
    node13.nodeLevel = 1;//
    node13.type = 2;//type 2的cell
    node13.sonNodes = nil;
    node13.isExpanded = FALSE;//关闭状态
    LevelTwoModel *tmp13 =[[LevelTwoModel alloc]init];
    tmp13.nameString = @"居住地址";
    tmp13.textString = @" ";
    node13.nodeData = tmp13;

    CPITreeViewNode * node14 = [[CPITreeViewNode alloc]init];
    node14.nodeLevel = 1;//
    node14.type = 2;//type 2的cell
    node14.sonNodes = nil;
    node14.isExpanded = FALSE;//关闭状态
    LevelTwoModel *tmp14 =[[LevelTwoModel alloc]init];
    tmp14.nameString = @"姓名";
    tmp14.textString = @" ";
    node14.nodeData = tmp14;

    CPITreeViewNode * node15 = [[CPITreeViewNode alloc]init];
    node15.nodeLevel = 1;//
    node15.type = 2;//type 2的cell
    node15.sonNodes = nil;
    node15.isExpanded = FALSE;//关闭状态
    LevelTwoModel *tmp15 =[[LevelTwoModel alloc]init];
    tmp15.nameString = @"关系";
    tmp15.textString = @" ";
    node15.nodeData = tmp15;

    CPITreeViewNode * node16 = [[CPITreeViewNode alloc]init];
    node16.nodeLevel = 1;//
    node16.type = 2;//type 2的cell
    node16.sonNodes = nil;
    node16.isExpanded = FALSE;//关闭状态
    LevelTwoModel *tmp16 =[[LevelTwoModel alloc]init];
    tmp16.nameString = @"亲属手机";
    tmp16.textString = @" ";
    node16.nodeData = tmp16;

    CPITreeViewNode * node17 = [[CPITreeViewNode alloc]init];
    node17.nodeLevel = 1;//
    node17.type = 2;//type 2的cell
    node17.sonNodes = nil;
    node17.isExpanded = FALSE;//关闭状态
    LevelTwoModel *tmp17 =[[LevelTwoModel alloc]init];
    tmp17.nameString = @"亲属单位";
    tmp17.textString = @" ";
    node17.nodeData = tmp17;
    
    CPITreeViewNode * node18 = [[CPITreeViewNode alloc]init];
    node18.nodeLevel = 1;//
    node18.type = 2;//type 2的cell
    node18.sonNodes = nil;
    node18.isExpanded = FALSE;//关闭状态
    LevelTwoModel *tmp18 =[[LevelTwoModel alloc]init];
    tmp18.nameString = @"姓名";
    tmp18.textString = @" ";
    node18.nodeData = tmp18;
    
    CPITreeViewNode * node19 = [[CPITreeViewNode alloc]init];
    node19.nodeLevel = 1;//
    node19.type = 2;//type 2的cell
    node19.sonNodes = nil;
    node19.isExpanded = FALSE;//关闭状态
    LevelTwoModel *tmp19=[[LevelTwoModel alloc]init];
    tmp19.nameString = @"职务";
    tmp19.textString = @" ";
    node19.nodeData = tmp19;
    
    CPITreeViewNode * node20 = [[CPITreeViewNode alloc]init];
    node20.nodeLevel = 1;//
    node20.type = 2;//type 2的cell
    node20.sonNodes = nil;
    node20.isExpanded = FALSE;//关闭状态
    LevelTwoModel *tmp20 =[[LevelTwoModel alloc]init];
    tmp20.nameString = @"同事手机";
    tmp20.textString = @" ";
    node20.nodeData = tmp20;
    
    CPITreeViewNode * node21 = [[CPITreeViewNode alloc]init];
    node21.nodeLevel = 1;//
    node21.type = 2;//type 2的cell
    node21.sonNodes = nil;
    node21.isExpanded = FALSE;//关闭状态
    LevelTwoModel *tmp21 =[[LevelTwoModel alloc]init];
    tmp21.nameString = @"同事单位";
    tmp21.textString = @" ";
    node21.nodeData = tmp21;
    
    CPITreeViewNode * node22 = [[CPITreeViewNode alloc]init];
    node22.nodeLevel = 1;//
    node22.type = 2;//type 2的cell
    node22.sonNodes = nil;
    node22.isExpanded = FALSE;//关闭状态
    LevelTwoModel *tmp22 =[[LevelTwoModel alloc]init];
    tmp22.nameString = @"姓名";
    tmp22.textString = @" ";
    node22.nodeData = tmp22;
    
    CPITreeViewNode * node23 = [[CPITreeViewNode alloc]init];
    node23.nodeLevel = 1;//
    node23.type = 2;//type 2的cell
    node23.sonNodes = nil;
    node23.isExpanded = FALSE;//关闭状态
    LevelTwoModel *tmp23 =[[LevelTwoModel alloc]init];
    tmp23.nameString = @"关系";
    tmp23.textString = @" ";
    node23.nodeData = tmp23;
    
    CPITreeViewNode * node24 = [[CPITreeViewNode alloc]init];
    node24.nodeLevel = 1;//
    node24.type = 2;//type 2的cell
    node24.sonNodes = nil;
    node24.isExpanded = FALSE;//关闭状态
    LevelTwoModel *tmp24 =[[LevelTwoModel alloc]init];
    tmp24.nameString = @"其他联系人手机";
    tmp24.textString = @" ";
    node24.nodeData = tmp24;
    
    CPITreeViewNode * node25 = [[CPITreeViewNode alloc]init];
    node25.nodeLevel = 1;//
    node25.type = 2;//type 2的cell
    node25.sonNodes = nil;
    node25.isExpanded = FALSE;//关闭状态
    LevelTwoModel *tmp25 =[[LevelTwoModel alloc]init];
    tmp25.nameString = @"其他联系人单位";
    tmp25.textString = @" ";
    node25.nodeData = tmp25;
    
    node3.sonNodes = [NSMutableArray arrayWithObjects:node7,node8,node9,node10,node11,node12,node13, nil];
    node4.sonNodes = [NSMutableArray arrayWithObjects:node14,node15,node16,node17, nil];
    node5.sonNodes = [NSMutableArray arrayWithObjects:node18,node19,node20,node21, nil];
    node6.sonNodes = [NSMutableArray arrayWithObjects:node22,node23,node24,node25, nil];
    
    _dataArray = [NSMutableArray arrayWithObjects:node3,node4,node5,node6, node26,node27,node28,node29,nil];
}

#pragma mark --TableViewDataSource&Delegate

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger) tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section{
    return _displayArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        CPITreeViewNode * node = [_displayArray objectAtIndex:indexPath.row];
        if (node.type == 1) {
            LevelOneCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LevelOneCellID"];
        
            cell.node = node;
            
            [self loadDataForTreeViewCell:cell with:node];//重新给cell装载数据
            [cell setNeedsDisplay]; //重新描绘cell
            
            return cell;
        }else if (node.type == 2){
            
            LevelTwoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LevelTwoCellID"];
    
            
            cell.node = node;
            
            [self loadDataForTreeViewCell:cell with:node];
            [cell setNeedsDisplay];
            
            return cell;
        }else if (node.type == 3){
            
            LongLabelCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LongLabelCellID"];
        
            
            cell.node = node;
            
            [self loadDataForTreeViewCell:cell with:node];
            [cell setNeedsDisplay];
            
            return cell;
            
        }else if (node.type == 4){
            PersonInfoTextViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PersonInfoTextViewCellID"];
            
            cell.node = node;
            [self loadDataForTreeViewCell:cell with:node];
            [cell setNeedsDisplay];

            return cell;
        }else if (node.type == 5){
            
            ButtonsCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ButtonsCellID"];
            if (cell == nil) {
                cell = [[ButtonsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ButtonsCellID"];
            }
            UIView *separator = [[UIView alloc]init];
            separator.backgroundColor = VIEW_BASE_COLOR;
            [cell addSubview:separator];
            [separator mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cell.mas_left).offset(10);
                make.right.equalTo(cell.mas_right).offset(0);
                make.bottom.equalTo(cell.mas_bottom).offset(-0.2);
                make.height.mas_equalTo(0.2);
            }];

            cell.node = node;
            
            ButtonsModel * nodeData = node.nodeData;
          //  cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
            if ([nodeData.name isEqualToString:@"贷款用途"]) {
                for (int i=0; i<nodeData.BtnArr.count; i++) {
                    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                    btn.tag = i+1;
                    if (nodeData.index == i+1) {
                        btn.selected = YES;
                    }
                    [btn setImage:[UIImage imageNamed:@"单选框"] forState:UIControlStateNormal];
                    [btn setImage:[UIImage imageNamed:@"单选框（亮）"] forState:UIControlStateSelected];
                    [btn setTitle:nodeData.BtnArr[i] forState:UIControlStateNormal];
                    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    btn.titleLabel.font = [UIFont systemFontOfSize:13];
                    [btn addTarget:self action:@selector(BtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
                    [cell addSubview:btn];
                    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(titleLB.mas_right).offset((60*KAdaptiveRateWidth+5*KAdaptiveRateWidth)*i+5*KAdaptiveRateWidth);
                        make.centerY.mas_equalTo(cell.mas_centerY);
                        make.height.mas_equalTo(14);
                        
                    }];
                }
            }
            return cell;

        }
        else if (node.type == 6){
            RedLabelCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RedLabelCellID"];
            
            cell.node = node;
            [self loadDataForTreeViewCell:cell with:node];
            [cell setNeedsDisplay];
            
            return cell;
        }
    }
    
    return nil;
}

/*---------------------------------------
 cell高度默认为50
 --------------------------------------- */
-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return 52;
}


#pragma mark -- 按钮点击事件
-(void)BtnOnClick:(UIButton *)sender{
    
    
    ButtonsCell *cell = (ButtonsCell*)[sender superview];
    NSIndexPath *indexpath = [self.cpiTableView indexPathForCell:cell];
    
   // NSMutableArray *tmp = [[NSMutableArray alloc]init];
    CPITreeViewNode *node = [_displayArray objectAtIndex:indexpath.row];
    ButtonsModel *nodeData = node.nodeData;
    nodeData.index = sender.tag;
    
//    for (CPITreeViewNode *node in _dataArray) {
// 
//        [tmp addObject:node];
//    }
//    _displayArray = [NSMutableArray arrayWithArray:tmp];

    [self.cpiTableView reloadData];
}


/*---------------------------------------
 初始化将要显示的cell的数据
 --------------------------------------- */
-(void) reloadDataForDisplayArray{
    NSMutableArray *tmp = [[NSMutableArray alloc]init];
    for (CPITreeViewNode *node in _dataArray) {
        [tmp addObject:node];
        if(node.isExpanded){
            for(CPITreeViewNode *node2 in node.sonNodes){
                [tmp addObject:node2];
                if(node2.isExpanded){
                    for(CPITreeViewNode *node3 in node2.sonNodes){
                        [tmp addObject:node3];
                    }
                }
            }
        }
    }
    _displayArray = [NSArray arrayWithArray:tmp];
    [self.cpiTableView reloadData];
}


/*---------------------------------------
 为不同类型cell填充数据
 --------------------------------------- */
-(void)loadDataForTreeViewCell:(UITableViewCell*)cell with:(CPITreeViewNode*)node{

    
     if(node.type == 1){
        LevelOneModel *nodeData = node.nodeData;
         ((LevelOneCell*)cell).selectionStyle = UITableViewCellSelectionStyleNone;
         
        ((LevelOneCell*)cell).name.text = nodeData.name;
         
         [((LevelOneCell*)cell).arrowView setImage:[UIImage imageNamed:@"箭头（上）"]];
    
     }else if (node.type == 3){
         longLabelModel * nodeData = node.nodeData;
         
         ((LongLabelCell*)cell).longLabel.text = nodeData.longLabelString;
         ((LongLabelCell*)cell).longTextView.text = nodeData.longTextString;
         ((LongLabelCell*)cell).selectionStyle = UITableViewCellSelectionStyleNone;
         
     }else if (node.type == 4){
         
         CommonMoneyModel * nodeData = node.nodeData;
         ((PersonInfoTextViewCell*)cell).personInfoLabel.text = nodeData.commonMoneyString;
         ((PersonInfoTextViewCell*)cell).personInfoTextView.text = nodeData.commonMoneyText;
         ((PersonInfoTextViewCell*)cell).selectionStyle = UITableViewCellSelectionStyleNone;
         
     }else if (node.type == 6){
         
         RedLabelModel * nodeData = node.nodeData;
         ((RedLabelCell *)cell).leftRedLabel.text = nodeData.leftRedString;
         ((RedLabelCell *)cell).redLabel.text = nodeData.redString;
         ((RedLabelCell *)cell).redText.text = nodeData.redTextString;
         ((RedLabelCell*)cell).selectionStyle = UITableViewCellSelectionStyleNone;
     }
    
    else{
        LevelTwoModel *nodeData = node.nodeData;
        ((LevelTwoCell*)cell).nameLabel.text = nodeData.nameString;
        ((LevelTwoCell*)cell).rightTextView.text = nodeData.textString;
        ((LevelTwoCell*)cell).backgroundColor = VIEW_BASE_COLOR;
        ((LevelTwoCell*)cell).rightTextView.backgroundColor = VIEW_BASE_COLOR;
        
        }
    
}


/*---------------------------------------
 处理cell选中事件，需要自定义的部分
 --------------------------------------- */
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CPITreeViewNode *node = [_displayArray objectAtIndex:indexPath.row];
    [self reloadDataForDisplayArrayChangeAt:indexPath.row];//修改cell的状态(关闭或打开)
    if(node.type == 2){
        //处理叶子节点选中，此处需要自定义
    }
    else if (node.type == 3){
        
    }else if (node.type == 4){
        
    }else if (node.type == 5){
        
    }else if (node.type == 6){
        
    }
    else{
        LevelOneCell *cell = (LevelOneCell*)[tableView cellForRowAtIndexPath:indexPath];
        if(cell.node.isExpanded ){
            [self rotateArrow:cell with:M_PI];
        }
        else{
            [self rotateArrow:cell with:0];
        }
    }
}

/*---------------------------------------
 旋转箭头图标
 --------------------------------------- */
-(void) rotateArrow:(LevelOneCell*) cell with:(double)degree{
    [UIView animateWithDuration:0.00 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        cell.arrowView.layer.transform = CATransform3DMakeRotation(degree, 0, 0, 1);
    } completion:NULL];
}

/*---------------------------------------
 修改cell的状态(关闭或打开)
 --------------------------------------- */
-(void) reloadDataForDisplayArrayChangeAt:(NSInteger)row{
    NSMutableArray *tmp = [[NSMutableArray alloc]init];
    NSInteger cnt=0;
    for (CPITreeViewNode *node in _dataArray) {
        [tmp addObject:node];
        if(cnt == row){
            node.isExpanded = !node.isExpanded;
        }
        ++cnt;
        if(node.isExpanded){
            for(CPITreeViewNode *node2 in node.sonNodes){
                [tmp addObject:node2];
                if(cnt == row){
                    node2.isExpanded = !node2.isExpanded;
                }
                ++cnt;
                if(node2.isExpanded){
                    for(CPITreeViewNode *node3 in node2.sonNodes){
                        [tmp addObject:node3];
                        ++cnt;
                    }
                }
            }
        }
    }
    _displayArray = [NSArray arrayWithArray:tmp];
    [self.cpiTableView reloadData];
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
