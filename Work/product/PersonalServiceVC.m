//
//  PersonalServiceVC.m
//  Financeteam
//pe
//  Created by 张正飞 on 16/6/12.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "PersonalServiceVC.h"
#import "PersonServiceCell.h"

@interface PersonalServiceVC ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)NSArray * leftDataArray;

@property(nonatomic,strong)NSArray * rightDataArray;

@property(nonatomic,strong)UITableView * psTableView;

//接口字段
@property(nonatomic,copy)NSString * tabQuota;
@property(nonatomic,copy)NSString * tabTerm;
@property(nonatomic,copy)NSString * tabRepayMonth;

@end

@implementation PersonalServiceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self creatUI];
    
    [self loadData];
    
   // [self returnTextString];
}

-(void)loadData{
    
    _leftDataArray = @[@"您申请的贷款额度",@"您申请的期限",@"您可接受的月还款额"];
    _rightDataArray = @[@"万元",@"年",@"元"];
}

-(void)creatUI{
    
    
    _psTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64-40) style:UITableViewStylePlain];
    _psTableView.delegate=self;
    _psTableView.dataSource = self;
  //  _psTableView.userInteractionEnabled = NO;
    _psTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    [self.view addSubview:_psTableView];
    
    
    [_psTableView registerNib:[UINib nibWithNibName:@"PersonServiceCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"PersonServiceID"];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellID"];
    }

    if (indexPath.section == 0 && indexPath.row == 0) {
        
        PersonServiceCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PersonServiceID"];
        
       // [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.leftLabel.text = _leftDataArray[indexPath.row];
        
        cell.rightLabel.text = _rightDataArray[indexPath.row];
        
        cell.centerTextView.tag = 200;
        
        return cell;
        
    }else if (indexPath.section == 0 && indexPath.row == 1){
        PersonServiceCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PersonServiceID"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.leftLabel.text = _leftDataArray[indexPath.row];
        
        cell.rightLabel.text = _rightDataArray[indexPath.row];
        
        
        return cell;
    }else if (indexPath.section == 0 && indexPath.row == 2){
        
        PersonServiceCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PersonServiceID"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.leftLabel.text = _leftDataArray[indexPath.row];
        
        cell.rightLabel.text = _rightDataArray[indexPath.row];
        
        
        return cell;
    }
    
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    _psTableView.estimatedRowHeight = 20;
    _psTableView.rowHeight = UITableViewAutomaticDimension;
    return _psTableView.rowHeight;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        UITextView * textView = [self.psTableView viewWithTag:200];
        
        NSLog(@"%@",textView.text);
        if (self.returnBlock != nil) {
            
                    self.returnBlock(textView.text);
      }

    }
}

//-(void)returnTextString{
//    
//    UITextView * textView = [self.psTableView viewWithTag:200];
//    
//    NSLog(@"%@",textView.text);
//    if (self.returnBlock != nil) {
//        
//        self.returnBlock(textView.text);
//    }
//    
//}


-(void)returnText:(myBlock)block{
    
    self.returnBlock = block;
    
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
