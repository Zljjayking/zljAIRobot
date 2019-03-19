//
//  ProductChooseTableViewController.m
//  Financeteam
//
//  Created by 徐兆阳 on 16/5/30.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "ProductChooseTableViewController.h"
#import "AddProductViewController.h"

#import "BankModel.h"

@interface ProductChooseTableViewController ()<UITableViewDelegate,UITableViewDataSource>{
    
    NSString *chooseString;
}
/** 导航条View */

@property (nonatomic, strong) UITableView *choosetableView;
@end

@implementation ProductChooseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = VIEW_BASE_COLOR;
    
    self.choosetableView = [[UITableView alloc]init];
    self.choosetableView.frame = CGRectMake(0, NaviHeight, kScreenWidth, kScreenHeight-NaviHeight);
    self.choosetableView.separatorColor = VIEW_BASE_COLOR;
    [self.view addSubview:self.choosetableView];
    self.choosetableView.delegate = self;
    self.choosetableView.dataSource = self;
    self.choosetableView.tableFooterView = [UIView new];
    self.choosetableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;

    [self.choosetableView reloadData];
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.textColor = GRAY70;
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    if (self.type == 1) {
        BankModel *model = self.dataArr[indexPath.row];
        cell.textLabel.text = model.bankName;
    } else {
        cell.textLabel.text = self.dataArr[indexPath.row];
    }
    
    
//    UIView *lineView    = [[UIView alloc]initWithFrame:[UIAdaption getAdaptiveRectWith6Rect:CGRectMake(0, 60, 375, .75)]];
//    
//    lineView.backgroundColor =[UIColor lightGrayColor];
//    
//    [cell.contentView addSubview:lineView];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.returnBlock != nil) {
        if (self.type == 1) {
            BankModel *model = self.dataArr[indexPath.row];
            chooseString = model.bankName;
            self.returnBlock(chooseString);
        } else{
            chooseString = _dataArr[indexPath.row];
            self.returnBlock(chooseString);
        }
        
    }else{
        chooseString = @"点击选择";
        self.returnBlock(chooseString);
    }
   

    [self.navigationController popViewControllerAnimated:YES];
}

-(void)makeTableviewFrame{
    
    self.choosetableView.frame = CGRectMake(self.view.frame.origin.x, NaviHeight, self.view.frame.size.width, _dataArr.count*60);
    
}

-(void)returnText:(myBlock)block{
    
    self.returnBlock = block;
    
}

//-(void)viewDidDisappear:(BOOL)animated{
//    
//    if (self.returnBlock != nil) {
//        self.returnBlock(chooseString);
//    }
//
//}


/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
