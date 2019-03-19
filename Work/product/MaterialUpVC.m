//
//  MaterialUpVC.m
//  Financeteam
//
//  Created by 张正飞 on 16/6/12.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "MaterialUpVC.h"

#import "UpOneButtonCell.h"
#import "UpTwoButtonCell.h"

@interface MaterialUpVC ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate>

@property(nonatomic,strong)UITableView * materialUpTableView;

@property(nonatomic,strong)NSArray * sectionNameArray;

@property(nonatomic,strong)UIImagePickerController * imagePC;

@end

@implementation MaterialUpVC

-(UITableView *)materialUpTableView{
    if (!_materialUpTableView) {
        _materialUpTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64-40) style:UITableViewStyleGrouped];
    }
    return _materialUpTableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadData];
    
    [self creatUI];

}

-(void)loadData{
    
    _sectionNameArray = @[@"身份证",@"户口簿",@"房产信息",@"结婚证明",@"工作收入证明",@"工资流水证明",@"信用报告",@"其他"];
    
}

-(void)creatUI{
    
    self.materialUpTableView.delegate = self;
    self.materialUpTableView.dataSource = self;
    [self.view addSubview:self.materialUpTableView];
    
    
    [self.materialUpTableView registerNib:[UINib nibWithNibName:@"UpOneButtonCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"UpOneButtonCellID"];
    
    [self.materialUpTableView registerNib:[UINib nibWithNibName:@"UpTwoButtonCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"UpTwoButtonCellID"];
    
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.sectionNameArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 25;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 7) {
        return 0.1;
    }else{
    return 5;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MaterialUpID"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MaterialUpID"];
    }
    if (indexPath.section == 0) {
        UpTwoButtonCell * cell = [tableView dequeueReusableCellWithIdentifier:@"UpTwoButtonCellID"];
        [cell.firstButton setBackgroundColor:TABBAR_BASE_COLOR];
        [cell.firstButton setImage:[UIImage imageNamed:@"首页加"] forState:UIControlStateNormal];
        
        
        
        [cell.secondButton setBackgroundColor:TABBAR_BASE_COLOR];
        [cell.secondButton setImage:[UIImage imageNamed:@"首页加"] forState:UIControlStateNormal];
        
        return cell;
        
    }else if (indexPath.section == 1) {
        UpOneButtonCell * cell = [tableView dequeueReusableCellWithIdentifier:@"UpOneButtonCellID"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        [cell.upOneButton setBackgroundColor:TABBAR_BASE_COLOR];
        [cell.upOneButton setImage:[UIImage imageNamed:@"首页加"] forState:UIControlStateNormal];
        
        cell.upOneButton.tag = 101;
        [cell.upOneButton addTarget:self action:@selector(AddIconOnClick:) forControlEvents:UIControlEventTouchUpInside];
     
        
        return cell;
    }else if (indexPath.section == 2){
        UpOneButtonCell * cell = [tableView dequeueReusableCellWithIdentifier:@"UpOneButtonCellID"];
        
        [cell.upOneButton setBackgroundColor:TABBAR_BASE_COLOR];
        [cell.upOneButton setImage:[UIImage imageNamed:@"首页加"] forState:UIControlStateNormal];
        return cell;
    }else if (indexPath.section == 3){
        UpOneButtonCell * cell = [tableView dequeueReusableCellWithIdentifier:@"UpOneButtonCellID"];
        
        [cell.upOneButton setBackgroundColor:TABBAR_BASE_COLOR];
        [cell.upOneButton setImage:[UIImage imageNamed:@"首页加"] forState:UIControlStateNormal];
        return cell;
    }
    else if (indexPath.section == 4){
        UpOneButtonCell * cell = [tableView dequeueReusableCellWithIdentifier:@"UpOneButtonCellID"];
        
        [cell.upOneButton setBackgroundColor:TABBAR_BASE_COLOR];
        [cell.upOneButton setImage:[UIImage imageNamed:@"首页加"] forState:UIControlStateNormal];
        return cell;
    }
    else if (indexPath.section == 5){
        UpOneButtonCell * cell = [tableView dequeueReusableCellWithIdentifier:@"UpOneButtonCellID"];
        
        [cell.upOneButton setBackgroundColor:TABBAR_BASE_COLOR];
        [cell.upOneButton setImage:[UIImage imageNamed:@"首页加"] forState:UIControlStateNormal];
        return cell;
    }
    else if (indexPath.section == 6){
        UpOneButtonCell * cell = [tableView dequeueReusableCellWithIdentifier:@"UpOneButtonCellID"];
        
        [cell.upOneButton setBackgroundColor:TABBAR_BASE_COLOR];
        [cell.upOneButton setImage:[UIImage imageNamed:@"首页加"] forState:UIControlStateNormal];
        return cell;
    }
    else if (indexPath.section == 7){
        UpOneButtonCell * cell = [tableView dequeueReusableCellWithIdentifier:@"UpOneButtonCellID"];
        
        [cell.upOneButton setBackgroundColor:TABBAR_BASE_COLOR];
        [cell.upOneButton setImage:[UIImage imageNamed:@"首页加"] forState:UIControlStateNormal];
        return cell;
    }

    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    return self.sectionNameArray[section];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80;
}

//添加产品图像
-(void)AddIconOnClick:(UIButton *)sender{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"从相册选择", nil];
    actionSheet.delegate       = self;
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
    
}

#pragma mark --  UIActionSheet delegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    _imagePC = [[UIImagePickerController alloc]init];
    _imagePC.allowsEditing = YES;
    _imagePC.delegate = self;
    if (buttonIndex == 0) { //拍照
        _imagePC.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:_imagePC animated:YES completion:nil];
    }else if(buttonIndex == 1){ //相册
        _imagePC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:_imagePC animated:YES completion:nil];
    }
}

#pragma mark -- UIImagePickerView

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *getImage=  [info objectForKey: @"UIImagePickerControllerEditedImage"];
    [self dismissViewControllerAnimated:picker completion:^{
        UIButton* imagebtn = [self.materialUpTableView viewWithTag:101];
        [imagebtn setImage:getImage forState:UIControlStateNormal];
        imagebtn.tag = 1;
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
