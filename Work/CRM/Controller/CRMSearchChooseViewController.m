//
//  CRMSearchChooseViewController.m
//  Financeteam
//
//  Created by 张正飞 on 16/8/10.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "CRMSearchChooseViewController.h"

@interface CRMSearchChooseViewController ()

@property (nonatomic,strong)UIView * backgroundView;

@property (nonatomic,strong)NSArray * dataArray;

@property (nonatomic,strong)NSMutableArray * mArray;

@end

@implementation CRMSearchChooseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"查询选择";
    self.view.backgroundColor = VIEW_BASE_COLOR;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"完成对勾"] style:UIBarButtonItemStylePlain target:self action:@selector(sureClick)];
    self.navigationItem.rightBarButtonItem = rightItem;
    self.mArray = [NSMutableArray array];
    if (self.alreadyChooseItems.count != 0) {
        [self.mArray addObjectsFromArray:self.alreadyChooseItems];
    }
    [self creatUI];
}

-(void)creatUI{
    
    self.backgroundView = [[UIView alloc]init];
    self.backgroundView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.backgroundView];
    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(NaviHeight+10);
        make.left.equalTo(self.view.mas_left).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.height.mas_equalTo(250*KAdaptiveRateWidth);
    }];
    
    self.dataArray = [NSArray arrayWithObjects:@"姓名",@"手机",@"身份证号码",@"状态",@"单位名称",@"单位性质",@"房产类型",@"公积金",@"社保",@"保险",@"发薪形式",@"购车金额",@"车贷月供",@"购车日期",@"起始时间", nil];
    
    for (int i = 0; i < self.dataArray.count; i++) {
        
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
       // btn.backgroundColor = [UIColor yellowColor];
        btn.tag = i;
        if ([self.alreadyChooseItems containsObject:@(i)]) {
            btn.selected = YES;
        }
        [btn setTitle:self.dataArray[i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [btn setTitleColor:TABBAR_BASE_COLOR forState:UIControlStateSelected];
        [self.backgroundView addSubview:btn];
        [btn addTarget:self action:@selector(searchChooseClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.backgroundView.mas_left).offset(((kScreenWidth-20 - 240*KAdaptiveRateWidth)/4.0 + 80*KAdaptiveRateWidth) *((i%3)+1) - 80 *KAdaptiveRateWidth);
            make.top.equalTo(self.backgroundView.mas_top).offset((41*KAdaptiveRateWidth)*(i/3)+19*KAdaptiveRateWidth);
            
            make.height.mas_equalTo(30*KAdaptiveRateWidth);
            make.width.mas_equalTo(80*KAdaptiveRateWidth);
            
        }];
    }
    
//    UIButton * cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
//    [cancleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    cancleBtn.titleLabel.font = [UIFont systemFontOfSize:15];
//    [cancleBtn setBackgroundColor:[UIColor lightGrayColor]];
//    cancleBtn.layer.cornerRadius = 5.0;
//    cancleBtn.layer.masksToBounds = YES;
//    [self.backgroundView addSubview:cancleBtn];
//    [cancleBtn addTarget:self action:@selector(cancelOnClick) forControlEvents:UIControlEventTouchUpInside];
//    [cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//       
//        make.right.equalTo(self.backgroundView.mas_centerX).offset(-30);
//        make.bottom.equalTo(self.backgroundView.mas_bottom).offset(-20);
//        make.width.mas_equalTo(90);
//        make.height.mas_equalTo(30);
//        
//    }];
//    
//    UIButton * sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [sureBtn setTitle:@"确认" forState:UIControlStateNormal];
//    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    sureBtn.titleLabel.font = [UIFont systemFontOfSize:15];
//    [sureBtn setBackgroundColor:[UIColor redColor]];
//    sureBtn.layer.cornerRadius = 5.0;
//    sureBtn.layer.masksToBounds = YES;
//    [self.backgroundView addSubview:sureBtn];
//    [sureBtn addTarget:self action:@selector(sureClick) forControlEvents:UIControlEventTouchUpInside];
//    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.left.equalTo(self.backgroundView.mas_centerX).offset(30);
//        make.bottom.equalTo(self.backgroundView.mas_bottom).offset(-20);
//        make.width.mas_equalTo(90);
//        make.height.mas_equalTo(30);
//        
//    }];

}

-(void)searchChooseClick:(UIButton *)sender{
    NSLog(@"tag==%ld",sender.tag);
    
    sender.selected = !sender.selected;
    switch (sender.tag) {
        case 0:
        {
            if (sender.selected) {
            [self.mArray addObject:@(0)];
            }else{
                [self.mArray removeObject:@(0)];
            }
        }
            break;
        case 1:
        {
            if (sender.selected) {
                [self.mArray addObject:@(1)];
            }else{
                [self.mArray removeObject:@(1)];
            }        }
            break;
        case 2:
        {
            if (sender.selected) {
                [self.mArray addObject:@(2)];
            }else{
                [self.mArray removeObject:@(2)];
            }
        }
            break;
        case 3:
        {
            if (sender.selected) {
                [self.mArray addObject:@(3)];
            }else{
                [self.mArray removeObject:@(3)];
            }
        }
            break;
        case 4:
        {
            if (sender.selected) {
                [self.mArray addObject:@(4)];
            }else{
                [self.mArray removeObject:@(4)];
            }
        }
            break;
        case 5:
        {
            if (sender.selected) {
                [self.mArray addObject:@(5)];
            }else{
                [self.mArray removeObject:@(5)];
            }
        }
            break;
        case 6:
        {
            if (sender.selected) {
                [self.mArray addObject:@(6)];
            }else{
                [self.mArray removeObject:@(6)];
            }
        }
            break;
        case 7:
        {
            if (sender.selected) {
                [self.mArray addObject:@(7)];
            }else{
                [self.mArray removeObject:@(7)];
            }
        }
            break;
        case 8:
        {
            if (sender.selected) {
                [self.mArray addObject:@(8)];
            }else{
                [self.mArray removeObject:@(8)];
            }
        }
            break;
        case 9:
        {
            if (sender.selected) {
                [self.mArray addObject:@(9)];
            }else{
                [self.mArray removeObject:@(9)];
            }
        }
            break;
        case 10:
        {
            if (sender.selected) {
                [self.mArray addObject:@(10)];
            }else{
                [self.mArray removeObject:@(10)];
            }
        }
            break;
        case 11:
        {
            if (sender.selected) {
                [self.mArray addObject:@(11)];
            }else{
                [self.mArray removeObject:@(11)];
            }
        }
            break;
        case 12:
        {
            if (sender.selected) {
                [self.mArray addObject:@(12)];
            }else{
                [self.mArray removeObject:@(12)];
            }
        }
            break;
        case 13:
        {
            if (sender.selected) {
                [self.mArray addObject:@(13)];
            }else{
                [self.mArray removeObject:@(13)];
            }        }
            break;
        case 14:
        {
            if (sender.selected) {
                [self.mArray addObject:@(14)];
            }else{
                [self.mArray removeObject:@(14)];
            }        }
            break;
            
        default:
            break;
    }
    
    
}

-(void)cancelOnClick{
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)sureClick{
    
   
    NSLog(@"m==%@",self.mArray);
    
    [self.mArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        
        NSString *a = (NSString *)obj1;
        NSString *b = (NSString *)obj2;
        
        int aNum = [a  intValue];
        int bNum = [b intValue];
        
        if (aNum > bNum) {
            return NSOrderedDescending;
        }
        else if (aNum < bNum){
            return NSOrderedAscending;
        }
        else {
            return NSOrderedSame;
        }
        
    }];
    NSLog(@"mm==%@",self.mArray);
    
    if (self.returnNSMutableArrayBlock != nil) {
        
        self.returnNSMutableArrayBlock(self.mArray);
    }

    
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)returnMutableArray:(ReturnNSMutableArrayBlock)block{
    
    self.returnNSMutableArrayBlock = block;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*;
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
