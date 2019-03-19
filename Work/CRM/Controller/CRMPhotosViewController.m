//
//  CRMPhotosViewController.m
//  Financeteam
//
//  Created by Zccf on 16/9/12.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "CRMPhotosViewController.h"
#import "UIImageView+WebCache.h"
#import "LGPhoto.h"
#import "STPhotoBrowserController.h"
#import "STConfig.h"
#import "UIButton+WebCache.h"
#import "WorkBtn.h"
#import "HXPhotoViewController.h"
#define HEADER_HEIGHT 100
@interface CRMPhotosViewController ()<STPhotoBrowserDelegate,UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIActionSheetDelegate,HXPhotoViewControllerDelegate>
//LGPhotoPickerViewControllerDelegate,LGPhotoPickerBrowserViewControllerDataSource,LGPhotoPickerBrowserViewControllerDelegate
@property (strong, nonatomic) NSMutableArray *dataList;
@property (strong, nonatomic) NSMutableArray *photos;
@property (strong, nonatomic) NSMutableArray *videos;
@property (assign, nonatomic) BOOL original;

@property (nonatomic, strong) UITableView *photosTableView;
@property (nonatomic, strong) NSArray *titleArr;
@property (nonatomic, assign) NSInteger whitchBtn;//判断点击的是哪个按钮
@property (nonatomic, strong, nullable)UIView *currentView; //
@property (nonatomic, strong, nullable)NSArray *currentArray; //
@property (nonatomic, strong) UIView *whicthCell;
@property (nonatomic, strong) NSMutableArray *itemsArray;
@property (nonatomic, strong) NSMutableArray *actionSheetArray;
@property (nonatomic, assign) LGShowImageType showType;

@property (nonatomic, strong) NSString *photoIdFront;
@property (nonatomic, strong) NSString *photoIdBack;

@property (nonatomic, strong) NSString *photoRegist;
@property (nonatomic, strong) NSString *photoRegist2;
@property (nonatomic, strong) NSString *photoRegist3;

@property (nonatomic, strong) NSString *photoHouse;
@property (nonatomic, strong) NSString *photoHouse2;
@property (nonatomic, strong) NSString *photoHouse3;

@property (nonatomic, strong) NSString *photoMarry;
@property (nonatomic, strong) NSString *photoMarry2;
@property (nonatomic, strong) NSString *photoMarry3;

@property (nonatomic, strong) NSString *photoWork;
@property (nonatomic, strong) NSString *photoWork2;
@property (nonatomic, strong) NSString *photoWork3;

@property (nonatomic, strong) NSString *photoWages;
@property (nonatomic, strong) NSString *photoWages2;
@property (nonatomic, strong) NSString *photoWages3;

@property (nonatomic, strong) NSString *photoOther;
@property (nonatomic, strong) NSString *photoOther2;
@property (nonatomic, strong) NSString *photoOther3;

@property (nonatomic,strong) NSString *photoCredit;
@property (nonatomic,strong) NSString *photoCredit2;
@property (nonatomic,strong) NSString *photoCredit3;
@property (nonatomic,strong) NSString *photoCredit4;
@property (nonatomic,strong) NSString *photoCredit5;
@property (nonatomic,strong) NSString *photoCredit6;
@property (nonatomic,strong) NSString *photoCredit7;
@property (nonatomic,strong) NSString *photoCredit8;
@property (nonatomic,strong) NSString *photoCredit9;
@property (nonatomic,strong) NSString *photoCredit10;

@property (nonatomic, strong) NSMutableArray *photoIdArr;
@property (nonatomic, strong) NSMutableArray *photoRegistArr;
@property (nonatomic, strong) NSMutableArray *photoHouseArr;
@property (nonatomic, strong) NSMutableArray *photoMarryArr;
@property (nonatomic, strong) NSMutableArray *photoWorkArr;
@property (nonatomic, strong) NSMutableArray *photoWagesArr;
@property (nonatomic, strong) NSMutableArray *photoOtherArr;
@property (nonatomic, strong) NSMutableArray *photoCreditArr;

@property (nonatomic, strong) HXPhotoManager *manager;
@end

@implementation CRMPhotosViewController
- (NSMutableArray *)itemsArray{
    if (!_itemsArray) {
        _itemsArray = [NSMutableArray array];
    }
    return _itemsArray;
}

- (NSMutableArray *)actionSheetArray{
    if (!_actionSheetArray) {
        _actionSheetArray = [NSMutableArray array];
    }
    return _actionSheetArray;
}
- (UITableView *)photosTableView {
    if (!_photosTableView) {
        _photosTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NaviHeight, kScreenWidth, kScreenHeight-NaviHeight) style:UITableViewStyleGrouped];
        if (self.ishideNaviView) {
            _photosTableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-NaviHeight);
        }
    }
    return _photosTableView;
}
- (HXPhotoManager *)manager
{
    if (!_manager) {
        _manager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhoto];
        _manager.outerCamera = YES;
        _manager.goCamera = NO;
        _manager.lookGifPhoto = NO;
        _manager.lookLivePhoto = NO;
        _manager.openCamera = NO;
    }
    return _manager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"图片材料";
    self.whicthCell = [[UIView alloc]init];
    self.view.backgroundColor = [UIColor whiteColor];
    [self datasource];
    self.photosTableView.delegate = self;
    self.photosTableView.dataSource = self;
    [self.view addSubview:self.photosTableView];
    self.titleArr = [NSArray arrayWithObjects:@"身份证",@"户口簿",@"房产信息",@"结婚证明",@"工作收入证明",@"工资流水证明",@"信用报告",@"其他", nil];
    if (self.isUpdateCRM) {
        UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"完成对勾"] style:UIBarButtonItemStylePlain target:self action:@selector(ClickEndEdit)];
        self.navigationItem.rightBarButtonItem = right;
        [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
    }
    
    // Do any additional setup after loading the view.
}
- (void)datasource {
    self.photoIdFront = self.PhotoModel.photoIdFront;
    self.photoIdBack = self.PhotoModel.photoIdBack;
//    NSLog(@"self.PhotoModel == %@",self.PhotoModel);
    NSLog(@"self.photoIdFront == %@ \n self.photoIdBack == %@",self.photoIdFront,self.photoIdBack);
    self.photoIdArr = [NSMutableArray array];
    if (self.photoIdFront.length == 0 || [self.photoIdFront isEqualToString:@""] || self.photoIdFront == nil || self.photoIdFront == NULL || [self.photoIdFront isEqual:[NSNull null]] || [self.photoIdFront isEqualToString:@"(null)"] || [self.photoIdFront isEqualToString:@"null"]) {
        
    } else {
        [self.photoIdArr addObject:self.photoIdFront];
    }
    if (self.photoIdBack.length == 0 || [self.photoIdBack isEqualToString:@""] || self.photoIdBack == nil || self.photoIdBack == NULL || [self.photoIdBack isEqual:[NSNull null]] || [self.photoIdBack isEqualToString:@"(null)"] || [self.photoIdBack isEqualToString:@"null"]) {
        
    } else {
        [self.photoIdArr addObject:self.photoIdBack];
    }
    self.photoRegist = self.PhotoModel.photoRegist;
    self.photoRegist2 = self.PhotoModel.photoRegist2;
    self.photoRegist3 = self.PhotoModel.photoRegist3;
    self.photoRegistArr = [NSMutableArray array];
    if (self.photoRegist.length == 0 || [self.photoRegist isEqualToString:@""] || self.photoRegist == nil || self.photoRegist == NULL || [self.photoRegist isEqual:[NSNull null]] || [self.photoRegist isEqualToString:@"(null)"] || [self.photoRegist isEqualToString:@"null"]) {
        
    } else {
        [self.photoRegistArr addObject:self.photoRegist];
    }
    if (self.photoRegist2.length == 0 || [self.photoRegist2 isEqualToString:@""] || self.photoRegist2 == nil || self.photoRegist2 == NULL || [self.photoRegist2 isEqual:[NSNull null]] || [self.photoRegist2 isEqualToString:@"(null)"] || [self.photoRegist2 isEqualToString:@"null"]) {
        
    } else {
        [self.photoRegistArr addObject:self.photoRegist2];
    }
    if (self.photoRegist3.length == 0 || [self.photoRegist3 isEqualToString:@""] || self.photoRegist3 == nil || self.photoRegist3 == NULL || [self.photoRegist3 isEqual:[NSNull null]] || [self.photoRegist3 isEqualToString:@"(null)"] || [self.photoRegist3 isEqualToString:@"null"]) {
        
    } else {
        [self.photoRegistArr addObject:self.photoRegist3];
    }
    
    
    self.photoHouse = self.PhotoModel.photoHouse;
    self.photoHouse2 = self.PhotoModel.photoHouse2;
    self.photoHouse3 = self.PhotoModel.photoHouse3;
    self.photoHouseArr = [NSMutableArray array];
    if (self.photoHouse.length == 0 || [self.photoHouse isEqualToString:@""] || self.photoHouse == nil || self.photoHouse == NULL || [self.photoHouse isEqual:[NSNull null]] || [self.photoHouse isEqualToString:@"(null)"] || [self.photoHouse isEqualToString:@"null"]) {
        
    } else {
        [self.photoHouseArr addObject:self.photoHouse];
    }
    if (self.photoHouse2.length == 0 || [self.photoHouse2 isEqualToString:@""] || self.photoHouse2 == nil || self.photoHouse2 == NULL || [self.photoHouse2 isEqual:[NSNull null]] || [self.photoHouse2 isEqualToString:@"(null)"] || [self.photoHouse2 isEqualToString:@"null"]) {
        
    } else {
        [self.photoHouseArr addObject:self.photoHouse2];
    }
    if (self.photoHouse3.length == 0 || [self.photoHouse3 isEqualToString:@""] || self.photoHouse3 == nil || self.photoHouse3 == NULL || [self.photoHouse3 isEqual:[NSNull null]] || [self.photoHouse3 isEqualToString:@"(null)"] || [self.photoHouse3 isEqualToString:@"null"]) {
        
    } else {
        [self.photoHouseArr addObject:self.photoHouse3];
    }
    
    self.photoMarry = self.PhotoModel.photoMarry;
    self.photoMarry2 = self.PhotoModel.photoMarry2;
    self.photoMarry3 = self.PhotoModel.photoMarry3;
    self.photoMarryArr = [NSMutableArray array];
    if (self.photoMarry.length == 0 || [self.photoMarry isEqualToString:@""] || self.photoMarry == nil || self.photoMarry == NULL || [self.photoMarry isEqual:[NSNull null]] || [self.photoMarry isEqualToString:@"(null)"] || [self.photoMarry isEqualToString:@"null"]) {
        
    } else {
        [self.photoMarryArr addObject:self.photoMarry];
    }
    if (self.photoMarry2.length == 0 || [self.photoMarry2 isEqualToString:@""] || self.photoMarry2 == nil || self.photoMarry2 == NULL || [self.photoMarry2 isEqual:[NSNull null]] || [self.photoMarry2 isEqualToString:@"(null)"] || [self.photoMarry2 isEqualToString:@"null"]) {
        
    } else {
        [self.photoMarryArr addObject:self.photoMarry2];
    }
    if (self.photoMarry3.length == 0 || [self.photoMarry3 isEqualToString:@""] || self.photoMarry3 == nil || self.photoMarry3 == NULL || [self.photoMarry3 isEqual:[NSNull null]] || [self.photoMarry3 isEqualToString:@"(null)"] || [self.photoMarry3 isEqualToString:@"null"]) {
        
    } else {
        [self.photoMarryArr addObject:self.photoMarry3];
    }
    
    self.photoWork = self.PhotoModel.photoWork;
    self.photoWork2 = self.PhotoModel.photoWork2;
    self.photoWork3 = self.PhotoModel.photoWork3;
    self.photoWorkArr = [NSMutableArray array];
    if (self.photoWork.length == 0 || [self.photoWork isEqualToString:@""] || self.photoWork == nil || self.photoWork == NULL || [self.photoWork isEqual:[NSNull null]] || [self.photoWork isEqualToString:@"(null)"] || [self.photoWork isEqualToString:@"null"]) {
        
    } else {
        [self.photoWorkArr addObject:self.photoWork];
    }
    if (self.photoWork2.length == 0 || [self.photoWork2 isEqualToString:@""] || self.photoWork2 == nil || self.photoWork2 == NULL || [self.photoWork2 isEqual:[NSNull null]] || [self.photoWork2 isEqualToString:@"(null)"] || [self.photoWork2 isEqualToString:@"null"]) {
        
    } else {
        [self.photoWorkArr addObject:self.photoWork2];
    }
    if (self.photoWork3.length == 0 || [self.photoWork3 isEqualToString:@""] || self.photoWork3 == nil || self.photoWork3 == NULL || [self.photoWork3 isEqual:[NSNull null]] || [self.photoWork3 isEqualToString:@"(null)"] || [self.photoWork3 isEqualToString:@"null"]) {
        
    } else {
        [self.photoWorkArr addObject:self.photoWork3];
    }
    
    self.photoWages = self.PhotoModel.photoWages;
    self.photoWages2 = self.PhotoModel.photoWages2;
    self.photoWages3 = self.PhotoModel.photoWages3;
    self.photoWagesArr = [NSMutableArray array];
    if (self.photoWages.length == 0 || [self.photoWages isEqualToString:@""] || self.photoWages == nil || self.photoWages == NULL || [self.photoWages isEqual:[NSNull null]] || [self.photoWages isEqualToString:@"(null)"] || [self.photoWages isEqualToString:@"null"]) {
        
    } else {
        [self.photoWagesArr addObject:self.photoWages];
    }
    if (self.photoWages2.length == 0 || [self.photoWages2 isEqualToString:@""] || self.photoWages2 == nil || self.photoWages2 == NULL || [self.photoWages2 isEqual:[NSNull null]] || [self.photoWages2 isEqualToString:@"(null)"] || [self.photoWages2 isEqualToString:@"null"]) {
        
    } else {
        [self.photoWagesArr addObject:self.photoWages2];
    }
    if (self.photoWages3.length == 0 || [self.photoWages3 isEqualToString:@""] || self.photoWages3 == nil || self.photoWages3 == NULL || [self.photoWages3 isEqual:[NSNull null]] || [self.photoWages3 isEqualToString:@"(null)"] || [self.photoWages3 isEqualToString:@"null"]) {
        
    } else {
        [self.photoWagesArr addObject:self.photoWages3];
    }
    
    
    self.photoOther = self.PhotoModel.photoOther;
    self.photoOther2 = self.PhotoModel.photoOther2;
    self.photoOther3 = self.PhotoModel.photoOther3;
    self.photoOtherArr = [NSMutableArray array];
    if (self.photoOther.length == 0 || [self.photoOther isEqualToString:@""] || self.photoOther == nil || self.photoOther == NULL || [self.photoOther isEqual:[NSNull null]] || [self.photoOther isEqualToString:@"(null)"] || [self.photoOther isEqualToString:@"null"]) {
        
    } else {
        [self.photoOtherArr addObject:self.photoOther];
    }
    if (self.photoOther2.length == 0 || [self.photoOther2 isEqualToString:@""] || self.photoOther2 == nil || self.photoOther2 == NULL || [self.photoOther2 isEqual:[NSNull null]] || [self.photoOther2 isEqualToString:@"(null)"] || [self.photoOther2 isEqualToString:@"null"]) {
        
    } else {
        [self.photoOtherArr addObject:self.photoOther2];
    }
    if (self.photoOther3.length == 0 || [self.photoOther3 isEqualToString:@""] || self.photoOther3 == nil || self.photoOther3 == NULL || [self.photoOther3 isEqual:[NSNull null]] || [self.photoOther3 isEqualToString:@"(null)"] || [self.photoOther3 isEqualToString:@"null"]) {
        
    } else {
        [self.photoOtherArr addObject:self.photoOther3];
    }
    
    self.photoCredit = self.PhotoModel.photoCredit;
    self.photoCredit2 = self.PhotoModel.photoCredit2;
    self.photoCredit3 = self.PhotoModel.photoCredit3;
    self.photoCredit4 = self.PhotoModel.photoCredit4;
    self.photoCredit5 = self.PhotoModel.photoCredit5;
    self.photoCredit6 = self.PhotoModel.photoCredit6;
    self.photoCredit7 = self.PhotoModel.photoCredit7;
    self.photoCredit8 = self.PhotoModel.photoCredit8;
    self.photoCredit9 = self.PhotoModel.photoCredit9;
    self.photoCredit10 = self.PhotoModel.photoCredit10;
    self.photoCreditArr = [NSMutableArray array];
    if (self.photoCredit.length == 0 || [self.photoCredit isEqualToString:@""] || self.photoCredit == nil || self.photoCredit == NULL || [self.photoCredit isEqual:[NSNull null]] || [self.photoCredit isEqualToString:@"(null)"] || [self.photoCredit isEqualToString:@"null"]) {
        
    } else {
        [self.photoCreditArr addObject:self.photoCredit];
    }
    if (self.photoCredit2.length == 0 || [self.photoCredit2 isEqualToString:@""] || self.photoCredit2 == nil || self.photoCredit2 == NULL || [self.photoCredit2 isEqual:[NSNull null]] || [self.photoCredit2 isEqualToString:@"(null)"] || [self.photoCredit2 isEqualToString:@"null"]) {
        
    } else {
        [self.photoCreditArr addObject:self.photoCredit2];
    }
    if (self.photoCredit3.length == 0 || [self.photoCredit3 isEqualToString:@""] || self.photoCredit3 == nil || self.photoCredit3 == NULL || [self.photoCredit3 isEqual:[NSNull null]] || [self.photoCredit3 isEqualToString:@"(null)"] || [self.photoCredit3 isEqualToString:@"null"]) {
        
    } else {
        [self.photoCreditArr addObject:self.photoCredit3];
    }
    if (self.photoCredit4.length == 0 || [self.photoCredit4 isEqualToString:@""] || self.photoCredit4 == nil || self.photoCredit4 == NULL || [self.photoCredit4 isEqual:[NSNull null]] || [self.photoCredit4 isEqualToString:@"(null)"] || [self.photoCredit4 isEqualToString:@"null"]) {
        
    } else {
        [self.photoCreditArr addObject:self.photoCredit4];
    }
    if (self.photoCredit5.length == 0 || [self.photoCredit5 isEqualToString:@""] || self.photoCredit5 == nil || self.photoCredit5 == NULL || [self.photoCredit5 isEqual:[NSNull null]] || [self.photoCredit5 isEqualToString:@"(null)"] || [self.photoCredit5 isEqualToString:@"null"]) {
        
    } else {
        [self.photoCreditArr addObject:self.photoCredit5];
    }
    if (![Utils isBlankString:self.photoCredit6]) {
        [self.photoCreditArr addObject:self.photoCredit6];
    }
    if (![Utils isBlankString:self.photoCredit7]) {
        [self.photoCreditArr addObject:self.photoCredit7];
    }
    if (![Utils isBlankString:self.photoCredit8]) {
        [self.photoCreditArr addObject:self.photoCredit8];
    }
    if (![Utils isBlankString:self.photoCredit9]) {
        [self.photoCreditArr addObject:self.photoCredit9];
    }
    if (![Utils isBlankString:self.photoCredit10]) {
        [self.photoCreditArr addObject:self.photoCredit10];
    }
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 8;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 6) {
        if (self.photoCreditArr.count/5) {
            return 140;
        } else {
            return 80;
        }
    }
    return 80;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.titleArr[section];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    for (UIButton *btn in [cell subviews]) {
        [btn removeFromSuperview];
    }
    for (UILabel *title in [cell subviews]) {
        [title removeFromSuperview];
    }
    if (indexPath.section == 0) {
        for (int i=0; i<2; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.tag = 1000+i;
            
            [btn setImage:[UIImage imageNamed:@"IconHome@2x.png"] forState:UIControlStateNormal];//给button添加image
            btn.imageEdgeInsets = UIEdgeInsetsMake(5,13,21,btn.titleLabel.bounds.size.width);//设置image在button上的位置（上top，左left，下bottom，右right）这里可以写负值，对上写－5，那么image就象上移动5个像素
            
            [btn setTitle:@"首页" forState:UIControlStateNormal];//设置button的title
            btn.titleLabel.font = [UIFont systemFontOfSize:16];//title字体大小
            btn.titleLabel.textAlignment = NSTextAlignmentCenter;//设置title的字体居中
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];//设置title在一般情况下为白色字体
            [btn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];//设置title在button被选中情况下为灰色字体
            btn.titleEdgeInsets = UIEdgeInsetsMake(71, -btn.titleLabel.bounds.size.width-50, 0, 0);//设置title在button上的位置（上top，左left，下bottom，右right）
            
            //    [button setContentEdgeInsets:UIEdgeInsetsMake(70, 0, 0, 0)];//
            
            
            //   button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;//设置button的内容横向居中。。设置content是title和image一起变化
            
            
            [btn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:btn];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(cell.mas_top).offset(10);
                make.left.equalTo(cell.mas_left).offset(12+i*(50+12));
                make.width.mas_equalTo(50);
                make.height.mas_equalTo(50);
            }];
            btn.layer.masksToBounds = YES;
            btn.layer.cornerRadius = 5;
            UILabel *title = [[UILabel alloc] init];
            [cell addSubview:title];
            title.textAlignment = NSTextAlignmentCenter;
            title.font = [UIFont systemFontOfSize:12];
            [title mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(btn.mas_bottom).offset(5);
                make.left.equalTo(cell.mas_left).offset(6+i*(62));
                make.width.mas_equalTo(62);
                make.height.mas_equalTo(15);
            }];
            
            if (i == 0) {
                if (self.photoIdFront.length == 0 || [self.photoIdFront isEqualToString:@""] || self.photoIdFront == nil || self.photoIdFront == NULL || [self.photoIdFront isEqual:[NSNull null]] || [self.photoIdFront isEqualToString:@"(null)"] || [self.photoIdFront isEqualToString:@"null"]) {
                    [btn setBackgroundImage:[UIImage imageNamed:@"增加群聊（大加）"] forState:UIControlStateNormal];
                    
                } else {
                    [btn sd_setBackgroundImageWithURL:[self.photoIdFront convertHostUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"选择人员（小头像）"]];
                    if (self.isUpdateCRM) {
                        UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                        deleteBtn.tag = i+10000;
                        [deleteBtn setBackgroundImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
                        [btn addSubview:deleteBtn];
                        
                        [deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                        [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.top.equalTo(btn.mas_top).offset(0);
                            make.right.equalTo(btn.mas_right).offset(0);
                            make.height.mas_equalTo(20);
                            make.width.mas_equalTo(20);
                        }];
                    }
                }
                title.text = @"身份证正面";
            } else if (i == 1) {
                if (self.photoIdBack.length == 0 || [self.photoIdBack isEqualToString:@""] || self.photoIdBack == nil || self.photoIdBack == NULL || [self.photoIdBack isEqual:[NSNull null]] || [self.photoIdBack isEqualToString:@"(null)"] || [self.photoIdBack isEqualToString:@"null"]) {
                    [btn setBackgroundImage:[UIImage imageNamed:@"增加群聊（大加）"] forState:UIControlStateNormal];
                } else {
                    [btn sd_setBackgroundImageWithURL:[self.photoIdBack convertHostUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"选择人员（小头像）"]];
                    if (self.isUpdateCRM) {
                        UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                        deleteBtn.tag = i+10000;
                        [deleteBtn setBackgroundImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
                        [btn addSubview:deleteBtn];
                        [deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                        [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.top.equalTo(btn.mas_top).offset(0);
                            make.right.equalTo(btn.mas_right).offset(0);
                            make.height.mas_equalTo(20);
                            make.width.mas_equalTo(20);
                        }];
                    }
                }
                title.text = @"身份证反面";
            }
        }
    } else if (indexPath.section == 1) {
        
        if (self.photoRegistArr.count == 3) {
            for (int i=0; i<self.photoRegistArr.count; i++) {
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.tag = 2000+i;
                [btn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:btn];
                [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(cell.mas_centerY);
                    make.left.equalTo(cell.mas_left).offset(12+i*(50+12));
                    make.width.mas_equalTo(50);
                    make.height.mas_equalTo(50);
                }];
                btn.layer.masksToBounds = YES;
                btn.layer.cornerRadius = 5;
                [btn sd_setBackgroundImageWithURL:[self.photoRegistArr[i] convertHostUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"选择人员（小头像）"]];
                if (self.isUpdateCRM) {
                    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    deleteBtn.tag = i+20000;
                    [deleteBtn setBackgroundImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
                    [btn addSubview:deleteBtn];
                    [deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                    [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(btn.mas_top).offset(0);
                        make.right.equalTo(btn.mas_right).offset(0);
                        make.height.mas_equalTo(20);
                        make.width.mas_equalTo(20);
                    }];
                }
            }
        } else {
            for (int i=0; i<self.photoRegistArr.count; i++) {
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.tag = 2000+i;
                [btn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:btn];
                [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(cell.mas_centerY);
                    make.left.equalTo(cell.mas_left).offset(12+i*(50+12));
                    make.width.mas_equalTo(50);
                    make.height.mas_equalTo(50);
                }];
                btn.layer.masksToBounds = YES;
                btn.layer.cornerRadius = 5;
                [btn sd_setBackgroundImageWithURL:[self.photoRegistArr[i] convertHostUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"选择人员（小头像）"]];
                if (self.isUpdateCRM) {
                    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    deleteBtn.tag = i+20000;
                    [deleteBtn setBackgroundImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
                    [btn addSubview:deleteBtn];
                    [deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                    [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(btn.mas_top).offset(0);
                        make.right.equalTo(btn.mas_right).offset(0);
                        make.height.mas_equalTo(20);
                        make.width.mas_equalTo(20);
                    }];
                }
            }
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.tag = 2000+self.photoRegistArr.count;
            [btn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:btn];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(cell.mas_centerY);
                make.left.equalTo(cell.mas_left).offset(12+self.photoRegistArr.count*(50+12));
                make.width.mas_equalTo(50);
                make.height.mas_equalTo(50);
            }];
            btn.layer.masksToBounds = YES;
            btn.layer.cornerRadius = 5;
            [btn setBackgroundImage:[UIImage imageNamed:@"增加群聊（大加）"] forState:UIControlStateNormal];
        }
        
    }else if (indexPath.section == 2) {
        
        if (self.photoHouseArr.count == 3) {
            for (int i=0; i<self.photoHouseArr.count; i++) {
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.tag = 3000+i;
                [btn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:btn];
                [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(cell.mas_centerY);
                    make.left.equalTo(cell.mas_left).offset(12+i*(50+12));
                    make.width.mas_equalTo(50);
                    make.height.mas_equalTo(50);
                }];
                btn.layer.masksToBounds = YES;
                btn.layer.cornerRadius = 5;
                [btn sd_setBackgroundImageWithURL:[self.photoHouseArr[i] convertHostUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"选择人员（小头像）"]];
                if (self.isUpdateCRM) {
                    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    deleteBtn.tag = i+30000;
                    [deleteBtn setBackgroundImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
                    [btn addSubview:deleteBtn];
                    [deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                    [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(btn.mas_top).offset(0);
                        make.right.equalTo(btn.mas_right).offset(0);
                        make.height.mas_equalTo(20);
                        make.width.mas_equalTo(20);
                    }];
                }
            }
        } else {
            for (int i=0; i<self.photoHouseArr.count; i++) {
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.tag = 3000+i;
                [btn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:btn];
                [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(cell.mas_centerY);
                    make.left.equalTo(cell.mas_left).offset(12+i*(50+12));
                    make.width.mas_equalTo(50);
                    make.height.mas_equalTo(50);
                }];
                btn.layer.masksToBounds = YES;
                btn.layer.cornerRadius = 5;
                [btn sd_setBackgroundImageWithURL:[self.photoHouseArr[i] convertHostUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"选择人员（小头像）"]];
                if (self.isUpdateCRM) {
                    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    deleteBtn.tag = i+30000;
                    [deleteBtn setBackgroundImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
                    [btn addSubview:deleteBtn];
                    [deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                    [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(btn.mas_top).offset(0);
                        make.right.equalTo(btn.mas_right).offset(0);
                        make.height.mas_equalTo(20);
                        make.width.mas_equalTo(20);
                    }];
                }
            }
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.tag = 3000+self.photoHouseArr.count;
            [btn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:btn];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(cell.mas_centerY);
                make.left.equalTo(cell.mas_left).offset(12+self.photoHouseArr.count*(50+12));
                make.width.mas_equalTo(50);
                make.height.mas_equalTo(50);
            }];
            btn.layer.masksToBounds = YES;
            btn.layer.cornerRadius = 5;
            [btn setBackgroundImage:[UIImage imageNamed:@"增加群聊（大加）"] forState:UIControlStateNormal];
        }
        
    }else if (indexPath.section == 3) {
        
        if (self.photoMarryArr.count == 3) {
            for (int i=0; i<self.photoMarryArr.count; i++) {
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.tag = 4000+i;
                [btn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:btn];
                [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(cell.mas_centerY);
                    make.left.equalTo(cell.mas_left).offset(12+i*(50+12));
                    make.width.mas_equalTo(50);
                    make.height.mas_equalTo(50);
                }];
                btn.layer.masksToBounds = YES;
                btn.layer.cornerRadius = 5;
                [btn sd_setBackgroundImageWithURL:[self.photoMarryArr[i] convertHostUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"选择人员（小头像）"]];
                if (self.isUpdateCRM) {
                    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    deleteBtn.tag = i+40000;
                    [deleteBtn setBackgroundImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
                    [btn addSubview:deleteBtn];
                    [deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                    [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(btn.mas_top).offset(0);
                        make.right.equalTo(btn.mas_right).offset(0);
                        make.height.mas_equalTo(20);
                        make.width.mas_equalTo(20);
                    }];
                }
            }
        } else {
            for (int i=0; i<self.photoMarryArr.count; i++) {
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.tag = 4000+i;
                [btn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:btn];
                [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(cell.mas_centerY);
                    make.left.equalTo(cell.mas_left).offset(12+i*(50+12));
                    make.width.mas_equalTo(50);
                    make.height.mas_equalTo(50);
                }];
                btn.layer.masksToBounds = YES;
                btn.layer.cornerRadius = 5;
                [btn sd_setBackgroundImageWithURL:[self.photoMarryArr[i] convertHostUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"选择人员（小头像）"]];
                if (self.isUpdateCRM) {
                    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    deleteBtn.tag = i+40000;
                    [deleteBtn setBackgroundImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
                    [btn addSubview:deleteBtn];
                    [deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                    [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(btn.mas_top).offset(0);
                        make.right.equalTo(btn.mas_right).offset(0);
                        make.height.mas_equalTo(20);
                        make.width.mas_equalTo(20);
                    }];
                }
            }
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.tag = 4000+self.photoMarryArr.count;
            [btn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:btn];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(cell.mas_centerY);
                make.left.equalTo(cell.mas_left).offset(12+self.photoMarryArr.count*(50+12));
                make.width.mas_equalTo(50);
                make.height.mas_equalTo(50);
            }];
            btn.layer.masksToBounds = YES;
            btn.layer.cornerRadius = 5;
            [btn setBackgroundImage:[UIImage imageNamed:@"增加群聊（大加）"] forState:UIControlStateNormal];
        }
        
    }else if (indexPath.section == 4) {
        
        if (self.photoWorkArr.count == 3) {
            for (int i=0; i<self.photoWorkArr.count; i++) {
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.tag = 5000+i;
                [btn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:btn];
                [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(cell.mas_centerY);
                    make.left.equalTo(cell.mas_left).offset(12+i*(50+12));
                    make.width.mas_equalTo(50);
                    make.height.mas_equalTo(50);
                }];
                btn.layer.masksToBounds = YES;
                btn.layer.cornerRadius = 5;
                [btn sd_setBackgroundImageWithURL:[self.photoWorkArr[i] convertHostUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"选择人员（小头像）"]];
                if (self.isUpdateCRM) {
                    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    deleteBtn.tag = i+50000;
                    [deleteBtn setBackgroundImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
                    [btn addSubview:deleteBtn];
                    [deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                    [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(btn.mas_top).offset(0);
                        make.right.equalTo(btn.mas_right).offset(0);
                        make.height.mas_equalTo(20);
                        make.width.mas_equalTo(20);
                    }];
                }
            }
        } else {
            for (int i=0; i<self.photoWorkArr.count; i++) {
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.tag = 5000+i;
                [btn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:btn];
                [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(cell.mas_centerY);
                    make.left.equalTo(cell.mas_left).offset(12+i*(50+12));
                    make.width.mas_equalTo(50);
                    make.height.mas_equalTo(50);
                }];
                btn.layer.masksToBounds = YES;
                btn.layer.cornerRadius = 5;
                [btn sd_setBackgroundImageWithURL:[self.photoWorkArr[i] convertHostUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"选择人员（小头像）"]];
                if (self.isUpdateCRM) {
                    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    deleteBtn.tag = i+50000;
                    [deleteBtn setBackgroundImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
                    [btn addSubview:deleteBtn];
                    [deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                    [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(btn.mas_top).offset(0);
                        make.right.equalTo(btn.mas_right).offset(0);
                        make.height.mas_equalTo(20);
                        make.width.mas_equalTo(20);
                    }];
                }
            }
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.tag = 5000+self.photoWorkArr.count;
            [btn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:btn];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(cell.mas_centerY);
                make.left.equalTo(cell.mas_left).offset(12+self.photoWorkArr.count*(50+12));
                make.width.mas_equalTo(50);
                make.height.mas_equalTo(50);
            }];
            btn.layer.masksToBounds = YES;
            btn.layer.cornerRadius = 5;
            [btn setBackgroundImage:[UIImage imageNamed:@"增加群聊（大加）"] forState:UIControlStateNormal];
        }
        
    }else if (indexPath.section == 5) {
        
        if (self.photoWagesArr.count == 3) {
            for (int i=0; i<self.photoWagesArr.count; i++) {
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.tag = 6000+i;
                [btn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:btn];
                [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(cell.mas_centerY);
                    make.left.equalTo(cell.mas_left).offset(12+i*(50+12));
                    make.width.mas_equalTo(50);
                    make.height.mas_equalTo(50);
                }];
                btn.layer.masksToBounds = YES;
                btn.layer.cornerRadius = 5;
                [btn sd_setBackgroundImageWithURL:[self.photoWagesArr[i] convertHostUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"选择人员（小头像）"]];
                if (self.isUpdateCRM) {
                    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    deleteBtn.tag = i+60000;
                    [deleteBtn setBackgroundImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
                    [btn addSubview:deleteBtn];
                    [deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                    [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(btn.mas_top).offset(0);
                        make.right.equalTo(btn.mas_right).offset(0);
                        make.height.mas_equalTo(20);
                        make.width.mas_equalTo(20);
                    }];
                }
            }
        } else {
            for (int i=0; i<self.photoWagesArr.count; i++) {
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.tag = 6000+i;
                [btn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:btn];
                [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(cell.mas_centerY);
                    make.left.equalTo(cell.mas_left).offset(12+i*(50+12));
                    make.width.mas_equalTo(50);
                    make.height.mas_equalTo(50);
                }];
                btn.layer.masksToBounds = YES;
                btn.layer.cornerRadius = 5;
                [btn sd_setBackgroundImageWithURL:[self.photoWagesArr[i] convertHostUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"选择人员（小头像）"]];
                if (self.isUpdateCRM) {
                    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    deleteBtn.tag = i+60000;
                    [deleteBtn setBackgroundImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
                    [btn addSubview:deleteBtn];
                    [deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                    [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(btn.mas_top).offset(0);
                        make.right.equalTo(btn.mas_right).offset(0);
                        make.height.mas_equalTo(20);
                        make.width.mas_equalTo(20);
                    }];
                }
            }
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.tag = 6000+self.photoWagesArr.count;
            [btn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:btn];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(cell.mas_centerY);
                make.left.equalTo(cell.mas_left).offset(12+self.photoWagesArr.count*(50+12));
                make.width.mas_equalTo(50);
                make.height.mas_equalTo(50);
            }];
            btn.layer.masksToBounds = YES;
            btn.layer.cornerRadius = 5;
            [btn setBackgroundImage:[UIImage imageNamed:@"增加群聊（大加）"] forState:UIControlStateNormal];
        }
        
    }else if (indexPath.section == 6) {
        
        if (self.photoCreditArr.count == 10) {
            for (int i=0; i<self.photoCreditArr.count; i++) {
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.tag = 7000+i;
                [btn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:btn];
                [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(cell.mas_top).offset(i/5 * (60)+15);
                    make.left.equalTo(cell.mas_left).offset(12+i%5*(50+12));
                    make.width.mas_equalTo(50);
                    make.height.mas_equalTo(50);
                }];
                btn.layer.masksToBounds = YES;
                btn.layer.cornerRadius = 5;
                [btn sd_setBackgroundImageWithURL:[self.photoCreditArr[i] convertHostUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"选择人员（小头像）"]];
                if (self.isUpdateCRM) {
                    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    deleteBtn.tag = i+70000;
                    [deleteBtn setBackgroundImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
                    [btn addSubview:deleteBtn];
                    [deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                    [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(btn.mas_top).offset(0);
                        make.right.equalTo(btn.mas_right).offset(0);
                        make.height.mas_equalTo(20);
                        make.width.mas_equalTo(20);
                    }];
                }
            }
        } else {
            for (int i=0; i<self.photoCreditArr.count; i++) {
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.tag = 7000+i;
                [btn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:btn];
                [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(cell.mas_top).offset(i/5 * (60)+15);
                    make.left.equalTo(cell.mas_left).offset(12+i%5*(50+12));
                    make.width.mas_equalTo(50);
                    make.height.mas_equalTo(50);
                }];
                btn.layer.masksToBounds = YES;
                btn.layer.cornerRadius = 5;
                [btn sd_setBackgroundImageWithURL:[self.photoCreditArr[i] convertHostUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"选择人员（小头像）"]];
                if (self.isUpdateCRM) {
                    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    deleteBtn.tag = i+70000;
                    [deleteBtn setBackgroundImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
                    [btn addSubview:deleteBtn];
                    [deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                    [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(btn.mas_top).offset(0);
                        make.right.equalTo(btn.mas_right).offset(0);
                        make.height.mas_equalTo(20);
                        make.width.mas_equalTo(20);
                    }];
                }
            }
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.tag = 7000+self.photoCreditArr.count;
            [btn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:btn];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(cell.mas_top).offset(self.photoCreditArr.count/5 * (60)+15);
                make.left.equalTo(cell.mas_left).offset(12+self.photoCreditArr.count%5*(50+12));
                make.width.mas_equalTo(50);
                make.height.mas_equalTo(50);
            }];
            btn.layer.masksToBounds = YES;
            btn.layer.cornerRadius = 5;
            [btn setBackgroundImage:[UIImage imageNamed:@"增加群聊（大加）"] forState:UIControlStateNormal];
        }
        
    }else if (indexPath.section == 7) {
        
        if (self.photoOtherArr.count == 3) {
            for (int i=0; i<self.photoOtherArr.count; i++) {
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.tag = 8000+i;
                [btn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:btn];
                [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(cell.mas_centerY);
                    make.left.equalTo(cell.mas_left).offset(12+i*(50+12));
                    make.width.mas_equalTo(50);
                    make.height.mas_equalTo(50);
                }];
                btn.layer.masksToBounds = YES;
                btn.layer.cornerRadius = 5;
                [btn sd_setBackgroundImageWithURL:[self.photoOtherArr[i] convertHostUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"选择人员（小头像）"]];
                if (self.isUpdateCRM) {
                    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    deleteBtn.tag = i+80000;
                    [deleteBtn setBackgroundImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
                    [btn addSubview:deleteBtn];
                    [deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                    [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(btn.mas_top).offset(0);
                        make.right.equalTo(btn.mas_right).offset(0);
                        make.height.mas_equalTo(20);
                        make.width.mas_equalTo(20);
                    }];
                }
            }
        } else {
            for (int i=0; i<self.photoOtherArr.count; i++) {
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.tag = 8000+i;
                [btn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:btn];
                [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(cell.mas_centerY);
                    make.left.equalTo(cell.mas_left).offset(12+i*(50+12));
                    make.width.mas_equalTo(50);
                    make.height.mas_equalTo(50);
                }];
                btn.layer.masksToBounds = YES;
                btn.layer.cornerRadius = 5;
                [btn sd_setBackgroundImageWithURL:[self.photoOtherArr[i] convertHostUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"选择人员（小头像）"]];
                if (self.isUpdateCRM) {
                    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    deleteBtn.tag = i+80000;
                    [deleteBtn setBackgroundImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
                    [btn addSubview:deleteBtn];
                    [deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                    [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(btn.mas_top).offset(0);
                        make.right.equalTo(btn.mas_right).offset(0);
                        make.height.mas_equalTo(20);
                        make.width.mas_equalTo(20);
                    }];
                }
            }
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.tag = 8000+self.photoOtherArr.count;
            [btn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:btn];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(cell.mas_centerY);
                make.left.equalTo(cell.mas_left).offset(12+self.photoOtherArr.count*(50+12));
                make.width.mas_equalTo(50);
                make.height.mas_equalTo(50);
            }];
            btn.layer.masksToBounds = YES;
            btn.layer.cornerRadius = 5;
            [btn setBackgroundImage:[UIImage imageNamed:@"增加群聊（大加）"] forState:UIControlStateNormal];
        }
        
    }
    return cell;
}


- (void)BtnClick:(UIButton *)sender {
    self.whicthCell = [sender superview];
    if (self.isUpdateCRM) {
        self.whitchBtn = sender.tag;
        if (sender.tag == 1000) {
            if (self.photoIdFront.length == 0 || [self.photoIdFront isEqualToString:@""] || self.photoIdFront == nil || self.photoIdFront == NULL || [self.photoIdFront isEqual:[NSNull null]] || [self.photoIdFront isEqualToString:@"(null)"] || [self.photoIdFront isEqualToString:@"null"]) {
                UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选取", nil];
                [action showInView:self.navigationController.view];
            } else {
//                UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"浏览", nil];
//                [action showInView:self.navigationController.view];
                //启动图片浏览器
                STPhotoBrowserController *browserVc = [[STPhotoBrowserController alloc] init];
                browserVc.sourceImagesContainerView = self.whicthCell; // 原图的父控件
                browserVc.countImage = 1; // 图片总数
                // /mechpro/mpro1474271889948.jpg
                self.currentView = self.whicthCell;
                self.currentArray = @[self.photoIdFront];
                
                browserVc.currentPage = 0;
                browserVc.delegate = self;
                browserVc.isIDBack = NO;
                [browserVc show];
            }
        } else if (sender.tag == 1001) {
            if (self.photoIdBack.length == 0 || [self.photoIdBack isEqualToString:@""] || self.photoIdBack == nil || self.photoIdBack == NULL || [self.photoIdBack isEqual:[NSNull null]] || [self.photoIdBack isEqualToString:@"(null)"] || [self.photoIdBack isEqualToString:@"null"]) {
                UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选取", nil];
                [action showInView:self.navigationController.view];
            } else {
//                UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"浏览", nil];
//                [action showInView:self.navigationController.view];
                //启动图片浏览器
                STPhotoBrowserController *browserVc = [[STPhotoBrowserController alloc] init];
                browserVc.sourceImagesContainerView = self.whicthCell; // 原图的父控件
                browserVc.countImage = 1; // 图片总数
                
                self.currentView = self.whicthCell;
                self.currentArray = @[self.photoIdBack];
                browserVc.isIDBack = YES;
                browserVc.currentPage = 0;
                browserVc.delegate = self;
                [browserVc show];
            }
        } else {
            switch (sender.tag/1000) {
                case 2:
                {
                    NSInteger index = sender.tag%2000;
                    [self photoActionWithNSMutableArr:self.photoRegistArr index:index];
                }
                    break;
                case 3:
                {
                    NSInteger index = sender.tag%3000;
                    [self photoActionWithNSMutableArr:self.photoHouseArr index:index];
                }
                    break;
                case 4:
                {
                    NSInteger index = sender.tag%4000;
                    [self photoActionWithNSMutableArr:self.photoMarryArr index:index];
                }
                    break;
                case 5:
                {
                    NSInteger index = sender.tag%5000;
                    [self photoActionWithNSMutableArr:self.photoWorkArr index:index];
                }
                    break;
                case 6:
                {
                    NSInteger index = sender.tag%6000;
                    [self photoActionWithNSMutableArr:self.photoWagesArr index:index];
                }
                    break;
                case 7:
                {
                    NSInteger index = sender.tag%7000;
                    [self photoActionWithNSMutableArr:self.photoCreditArr index:index];
                }
                    break;
                case 8:
                {
                    NSInteger index = sender.tag%8000;
                    [self photoActionWithNSMutableArr:self.photoOtherArr index:index];
                }
                    break;
                default:
                    break;
            }
        }
    } else {
        self.whitchBtn = sender.tag;
        if (sender.tag == 1000) {
            if (self.photoIdFront.length == 0 || [self.photoIdFront isEqualToString:@""] || self.photoIdFront == nil || self.photoIdFront == NULL || [self.photoIdFront isEqual:[NSNull null]] || [self.photoIdFront isEqualToString:@"(null)"] || [self.photoIdFront isEqualToString:@"null"]) {
            } else {
//                UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"浏览", nil];
//                [action showInView:self.navigationController.view];
                //启动图片浏览器
                STPhotoBrowserController *browserVc = [[STPhotoBrowserController alloc] init];
                browserVc.sourceImagesContainerView = self.whicthCell; // 原图的父控件
                browserVc.countImage = 1; // 图片总数
                
                self.currentView = self.whicthCell;
                self.currentArray = @[self.photoIdFront];
                browserVc.isIDBack = NO;
                browserVc.currentPage = 0;
                browserVc.delegate = self;
                [browserVc show];
            }
        } else  if (sender.tag == 1001) {
            if (self.photoIdBack.length == 0 || [self.photoIdBack isEqualToString:@""] || self.photoIdBack == nil || self.photoIdBack == NULL || [self.photoIdBack isEqual:[NSNull null]] || [self.photoIdBack isEqualToString:@"(null)"] || [self.photoIdBack isEqualToString:@"null"]) {
            } else {
//                UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"浏览", nil];
//                [action showInView:self.navigationController.view];
                //启动图片浏览器
                STPhotoBrowserController *browserVc = [[STPhotoBrowserController alloc] init];
                browserVc.sourceImagesContainerView = self.whicthCell; // 原图的父控件
                browserVc.countImage = 1; // 图片总数
                
                self.currentView = self.whicthCell;
                self.currentArray = @[self.photoIdBack];
                browserVc.isIDBack = YES;
                browserVc.currentPage = 0;
                browserVc.delegate = self;
                [browserVc show];
            }
        } else {
            switch (sender.tag/1000) {
                case 2:
                {
                    NSInteger index = sender.tag%2000;
                    [self photoActionWithNSMutableArr:self.photoRegistArr index:index];
                }
                    break;
                case 3:
                {
                    NSInteger index = sender.tag%3000;
                    [self photoActionWithNSMutableArr:self.photoHouseArr index:index];
                }
                    break;
                case 4:
                {
                    NSInteger index = sender.tag%4000;
                    [self photoActionWithNSMutableArr:self.photoMarryArr index:index];
                }
                    break;
                case 5:
                {
                    NSInteger index = sender.tag%5000;
                    [self photoActionWithNSMutableArr:self.photoWorkArr index:index];
                }
                    break;
                case 6:
                {
                    NSInteger index = sender.tag%6000;
                    [self photoActionWithNSMutableArr:self.photoWagesArr index:index];
                }
                    break;
                case 7:
                {
                    NSInteger index = sender.tag%7000;
                    [self photoActionWithNSMutableArr:self.photoCreditArr index:index];
                }
                    break;
                case 8:
                {
                    NSInteger index = sender.tag%8000;
                    [self photoActionWithNSMutableArr:self.photoOtherArr index:index];
                }
                    break;
                default:
                    break;
            }
        }
    }
    
}


- (void)photoActionWithNSMutableArr:(NSMutableArray *)array index:(NSInteger)index {
    NSLog(@"array.count == %ld",array.count);
    if (self.isUpdateCRM) {
        if (array.count != 0) {
            if (index == array.count) {
                UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选取", nil];
                [action showInView:self.navigationController.view];
            } else {
//                UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"浏览", nil];
//                [action showInView:self.navigationController.view];
                //启动图片浏览器
                STPhotoBrowserController *browserVc = [[STPhotoBrowserController alloc] init];
                browserVc.sourceImagesContainerView = self.whicthCell; // 原图的父控件
                browserVc.countImage = array.count; // 图片总数
                
                self.currentView = self.whicthCell;
                self.currentArray = array;
                browserVc.isIDBack = NO;
                browserVc.currentPage = index;
                browserVc.delegate = self;
                [browserVc show];
            }
        } else {
            UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选取", nil];
            [action showInView:self.navigationController.view];
        }
    } else {
        if (array.count != 0) {
            if (index == array.count) {
                
            } else {
//                UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"浏览", nil];
//                [action showInView:self.navigationController.view];
                //启动图片浏览器
                STPhotoBrowserController *browserVc = [[STPhotoBrowserController alloc] init];
                browserVc.sourceImagesContainerView = self.whicthCell; // 原图的父控件
                browserVc.countImage = array.count; // 图片总数
                
                self.currentView = self.whicthCell;
                self.currentArray = array;
                browserVc.isIDBack = NO;
                browserVc.currentPage = index;
                browserVc.delegate = self;
                [browserVc show];
            }
        }
    }
    
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (self.whitchBtn == 1000) {
        if (self.photoIdFront.length == 0 || [self.photoIdFront isEqualToString:@""] || self.photoIdFront == nil || self.photoIdFront == NULL || [self.photoIdFront isEqual:[NSNull null]] || [self.photoIdFront isEqualToString:@"(null)"] || [self.photoIdFront isEqualToString:@"null"]) {
            if (buttonIndex == 0) {
                //拍照
                [self takePhone];
            } else if (buttonIndex == 1) {
                //从相册选取
                [self takeLocalPhoto];
                
            }
        } else {
            if (buttonIndex == 0) {
                
                //启动图片浏览器
                
//                NSMutableArray *browseItemArray = [[NSMutableArray alloc]init];
//                int i = 0;
//                for(i = 0;i < [self.photoIdArr count];i++)
//                {
//                 
//                    MSSBrowseModel *browseItem = [[MSSBrowseModel alloc]init];
//                    browseItem.bigImageUrl = self.photoIdArr[i];// 加载网络图片大图地址
//                    [browseItemArray addObject:browseItem];
//                }
//
//                MSSBrowseNetworkViewController *bvc = [[MSSBrowseNetworkViewController alloc]initWithBrowseItemArray:browseItemArray currentIndex:0];
//                //    bvc.isEqualRatio = NO;// 大图小图不等比时需要设置这个属性（建议等比）
//                [bvc showBrowseViewController];

                
                // 如果设置了 photoBrower中的 actionSheetArr 属性. 那么 isNeedRightTopBtn 就应该是默认 YES, 如果设置成NO, 这个actionSheetArr 属性就没有意义了
                //    photoBrower.actionSheetArr = [self.actionSheetArray mutableCopy]
                
            }
        }
    } else if (self.whitchBtn == 1001) {
        if (self.photoIdBack.length == 0 || [self.photoIdBack isEqualToString:@""] || self.photoIdBack == nil || self.photoIdBack == NULL || [self.photoIdBack isEqual:[NSNull null]] || [self.photoIdBack isEqualToString:@"(null)"] || [self.photoIdBack isEqualToString:@"null"]) {
            if (buttonIndex == 0) {
                //拍照
                [self takePhone];
            } else if (buttonIndex == 1) {
                //从相册选取
                [self takeLocalPhoto];
            }
        } else {
            if (buttonIndex == 0) {
                //浏览照片
            }
        }
    } else {
        switch (self.whitchBtn/1000) {
            case 2:
            {
                NSInteger index = self.whitchBtn%2000;
                [self clickedButtonAtIndexWithArr:self.photoRegistArr index:index buttonIndex:buttonIndex whitchBtn:2];
            }
                break;
            case 3:
            {
                NSInteger index = self.whitchBtn%3000;
                [self clickedButtonAtIndexWithArr:self.photoHouseArr index:index buttonIndex:buttonIndex whitchBtn:3];
            }
                break;
            case 4:
            {
                NSInteger index = self.whitchBtn%4000;
                [self clickedButtonAtIndexWithArr:self.photoMarryArr index:index buttonIndex:buttonIndex whitchBtn:4];
            }
                break;
            case 5:
            {
                NSInteger index = self.whitchBtn%5000;
                [self clickedButtonAtIndexWithArr:self.photoWorkArr index:index buttonIndex:buttonIndex whitchBtn:5];
            }
                break;
            case 6:
            {
                NSInteger index = self.whitchBtn%6000;
                [self clickedButtonAtIndexWithArr:self.photoWagesArr index:index buttonIndex:buttonIndex whitchBtn:6];
            }
                break;
            case 7:
            {
                NSInteger index = self.whitchBtn%7000;
                [self clickedButtonAtIndexWithArr:self.photoCreditArr index:index buttonIndex:buttonIndex whitchBtn:7];
            }
                break;
            case 8:
            {
                NSInteger index = self.whitchBtn%8000;
                [self clickedButtonAtIndexWithArr:self.photoOtherArr index:index buttonIndex:buttonIndex whitchBtn:8];
            }
                break;
            default:
                break;
        }
    }
    
}
- (void)clickedButtonAtIndexWithArr:(NSMutableArray *)arr index:(NSInteger)index buttonIndex:(NSInteger)buttonIndex whitchBtn:(NSInteger)whitchBtn{
    if (arr.count != 0) {
        if (index == arr.count) {
            if (buttonIndex == 0) {
                //拍照
                [self takePhone];
            } else if (buttonIndex == 1) {
                //从相册选取
                [self takeLocalPhoto];
                
            }
        } else {
            if (buttonIndex == 0) {
                //启动图片浏览器
                
            }
        }
    } else {
        if (buttonIndex == 0) {
            //拍照
            [self takePhone];
        } else if (buttonIndex == 1) {
            //从相册选取
            [self takeLocalPhoto];
        }
    }
}

- (void)deleteBtnClick:(UIButton *)Btn {
    
    if (Btn.tag == 10000) {
        self.photoIdFront = @"";
    } else if (Btn.tag == 10001) {
        self.photoIdBack = @"";
    } else {
        
        switch (Btn.tag/10000) {
            case 2:
            {
                NSInteger index = Btn.tag%20000;
//                HXPhotoModel *model = self.photoRegistArr[index];
//                [self.manager deleteSpecifiedModel:model];
//                if ((model.type == HXPhotoModelMediaTypePhoto || model.type == HXPhotoModelMediaTypePhotoGif) || (model.type == HXPhotoModelMediaTypeCameraPhoto || model.type == HXPhotoModelMediaTypeLivePhoto)) {
//                    [self.photos removeObject:model];
//                }else if (model.type == HXPhotoModelMediaTypeVideo || model.type == HXPhotoModelMediaTypeCameraVideo) {
//                    [self.videos removeObject:model];
//                }
//                model.thumbPhoto = nil;
//                model.previewPhoto = nil;
//                model.imageData = nil;
//                model.livePhoto = nil;
//                model = nil;
//                [self changeSelectedListModelIndex];
                [self.photoRegistArr removeObjectAtIndex:index];
            }
                break;
            case 3:
            {
                NSInteger index = Btn.tag%30000;
                
                [self.photoHouseArr removeObjectAtIndex:index];
            }
                break;
            case 4:
            {
                NSInteger index = Btn.tag%40000;
                
                [self.photoMarryArr removeObjectAtIndex:index];
            }
                break;
            case 5:
            {
                NSInteger index = Btn.tag%50000;
                
                [self.photoWorkArr removeObjectAtIndex:index];
            }
                break;
            case 6:
            {
                NSInteger index = Btn.tag%60000;
                
                [self.photoWagesArr removeObjectAtIndex:index];
            }
                break;
            case 7:
            {
                NSInteger index = Btn.tag%70000;
                
                [self.photoCreditArr removeObjectAtIndex:index];
            }
                break;
            case 8:
            {
                NSInteger index = Btn.tag%80000;
                
                [self.photoOtherArr removeObjectAtIndex:index];
            }
                break;
            default:
                break;
        }
    }
    [self.photosTableView reloadData];
    
}


//打开照相机拍照
-(void)takePhone{
    
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    [picker.navigationBar setBarTintColor:kMyColor(29, 46, 55)];
    
    [picker.navigationBar setTranslucent:NO];
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.delegate = self;
//    picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:^{
        NSLog(@"打开了照相机");
    }];
}
//打开本地相册
-(void)takeLocalPhoto{
    
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    UIFont *font = [UIFont systemFontOfSize:17];
    NSDictionary *textAttributes = @{
                                     NSFontAttributeName : font,
                                     NSForegroundColorAttributeName : [UIColor whiteColor]
                                     };
    picker.navigationBar.titleTextAttributes = textAttributes;
    [picker.navigationBar setBarTintColor:kMyColor(29, 46, 55)];
    [picker.navigationBar setTranslucent:NO];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    //设置图片可被编辑
    picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:^{
        NSLog(@"打开了相册");
    }];
    
//    HXPhotoViewController *vc = [[HXPhotoViewController alloc] init];
//    vc.manager = self.manager;
//    vc.delegate = self;
//    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:vc] animated:YES completion:nil];
}

//-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
//
//    if (navigationController.viewControllers.count == 3) {
//
//        Method method = class_getInstanceMethod([self class], @selector(drawRect:));
//        class_replaceMethod([[[[navigationController viewControllers][2].view subviews][1] subviews][0] class],@selector(drawRect:),method_getImplementation(method),method_getTypeEncoding(method));
//    }
//}

//-(void)drawRect:(CGRect)rect
//{
//    CGContextRef ref = UIGraphicsGetCurrentContext();
//    CGContextAddRect(ref, rect);
//    CGContextAddArc(ref, [UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2, arcWitch, 0, 0, NO);
//    [[UIColor colorWithRed:0 green:0 blue:0 alpha:0]setFill];
//    CGContextDrawPath(ref, kCGPathEOFill);
//    
//    CGContextAddArc(ref, [UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2, arcWitch, 0, 0, NO);
//    [[UIColor whiteColor]setStroke];
//    CGContextStrokePath(ref);
//}

#pragma mark -- UIImagePickerView

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage * image = [info objectForKey: @"UIImagePickerControllerOriginalImage"];
    
    [HttpRequestEngine uploadImageData:[self getDataWitdImgae:image] fileName:@"front.jpg" completion:^(id obj, NSString *errorStr) {
        if (errorStr)
        {
            [MBProgressHUD showError:errorStr toView:self.view];
        }else{
            
            NSDictionary *dic = [NSDictionary changeType:obj];
            
            switch (self.whitchBtn) {
                case 1000:
                {
                    self.photoIdFront = dic[@"errorMsg"];
                    [self.photoIdArr addObject:self.photoIdFront];
                }
                    break;
                case 1001:
                {
                    self.photoIdBack = dic[@"errorMsg"];
                    [self.photoIdArr addObject:self.photoIdBack];
                }
                    break;
                default:
                    break;
            }
            switch (self.whitchBtn/1000) {
                case 2:
                {
                    [self.photoRegistArr addObject:dic[@"errorMsg"]];
                }
                    break;
                case 3:
                {
                    [self.photoHouseArr addObject:dic[@"errorMsg"]];
                }
                    break;
                case 4:
                {
                    [self.photoMarryArr addObject:dic[@"errorMsg"]];
                }
                    break;
                case 5:
                {
                    [self.photoWorkArr addObject:dic[@"errorMsg"]];
                }
                    break;
                case 6:
                {
                    [self.photoWagesArr addObject:dic[@"errorMsg"]];
                }
                    break;
                case 7:
                {
                    [self.photoCreditArr addObject:dic[@"errorMsg"]];
                }
                    break;
                case 8:
                {
                    [self.photoOtherArr addObject:dic[@"errorMsg"]];
                }
                    break;
                default:
                    break;
            }
            [MBProgressHUD showSuccess:@"上传成功"];
            [self.photosTableView reloadData];
        }
        
    }];
    [picker dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark -- 图片转Data
-(NSData  *)getDataWitdImgae:(UIImage *)originalImage{
    
    NSData *baseData = UIImageJPEGRepresentation(originalImage, 0.5);
    return baseData;
    
}
#pragma mark -- 编辑完成
- (void)ClickEndEdit {
    if (self.photoIdFront.length == 0 || [self.photoIdFront isEqualToString:@""] || self.photoIdFront == nil || self.photoIdFront == NULL || [self.photoIdFront isEqual:[NSNull null]] || [self.photoIdFront isEqualToString:@"(null)"] || [self.photoIdFront isEqualToString:@"null"]) {
        self.PhotoModel.photoIdFront = @"";
    } else {
        self.photoIdFront = [self.photoIdFront stringByReplacingOccurrencesOfString:@"_min" withString:@""];
        self.PhotoModel.photoIdFront = self.photoIdFront;
    }
    if (self.photoIdBack.length == 0 || [self.photoIdBack isEqualToString:@""] || self.photoIdBack == nil || self.photoIdBack == NULL || [self.photoIdBack isEqual:[NSNull null]] || [self.photoIdBack isEqualToString:@"(null)"] || [self.photoIdBack isEqualToString:@"null"]) {
        self.PhotoModel.photoIdBack = @"";
    } else {
        self.photoIdBack = [self.photoIdBack stringByReplacingOccurrencesOfString:@"_min" withString:@""];
        self.PhotoModel.photoIdBack = self.photoIdBack;
    }
    
//    if (self.photoRegistArr.count) {
//        for (int i = 0; i < self.photoRegistArr.count; i++) {
//            NSString *keyStr = @"";
//            NSString *photoRegist = [self.photoRegistArr[i] stringByReplacingOccurrencesOfString:@"_min" withString:@""];
//            if (i == 0) {
//                keyStr = [NSString stringWithFormat:@"photoRegist"];
//            } else {
//                keyStr = [NSString stringWithFormat:@"photoRegist%d",i+1];
//            }
//            [dic setObject:photoRegist forKey:keyStr];
//        }
//    }
    
    switch (self.photoRegistArr.count) {
        case 1:
        {
            self.photoRegist = self.photoRegistArr[0];
            self.photoRegist = [self.photoRegist stringByReplacingOccurrencesOfString:@"_min" withString:@""];
            self.PhotoModel.photoRegist = self.photoRegist;
        }
            break;
        case 2:
        {
            self.photoRegist = self.photoRegistArr[0];
            self.photoRegist = [self.photoRegist stringByReplacingOccurrencesOfString:@"_min" withString:@""];
            self.PhotoModel.photoRegist = self.photoRegist;
            self.photoRegist2 = self.photoRegistArr[1];
            self.photoRegist2 = [self.photoRegist2 stringByReplacingOccurrencesOfString:@"_min" withString:@""];
            self.PhotoModel.photoRegist2 = self.photoRegist2;
        }
            break;
        case 3:
        {
            self.photoRegist = self.photoRegistArr[0];
            self.photoRegist = [self.photoRegist stringByReplacingOccurrencesOfString:@"_min" withString:@""];
            self.PhotoModel.photoRegist = self.photoRegist;
            self.photoRegist2 = self.photoRegistArr[1];
            self.photoRegist2 = [self.photoRegist2 stringByReplacingOccurrencesOfString:@"_min" withString:@""];
            self.PhotoModel.photoRegist2 = self.photoRegist2;
            self.photoRegist3 = self.photoRegistArr[2];
            self.photoRegist3 = [self.photoRegist3 stringByReplacingOccurrencesOfString:@"_min" withString:@""];
            self.PhotoModel.photoRegist3 = self.photoRegist3;
        }
            break;
        default:
            break;
    }
    switch (self.photoHouseArr.count) {
        case 1:
        {
            self.photoHouse = self.photoHouseArr[0];
            self.photoHouse = [self.photoHouse stringByReplacingOccurrencesOfString:@"_min" withString:@""];
            self.PhotoModel.photoHouse = self.photoHouse;
        }
            break;
        case 2:
        {
            self.photoHouse = self.photoHouseArr[0];
            self.photoHouse = [self.photoHouse stringByReplacingOccurrencesOfString:@"_min" withString:@""];
            self.PhotoModel.photoHouse = self.photoHouse;
            self.photoHouse2 = self.photoHouseArr[1];
            self.photoHouse2 = [self.photoHouse2 stringByReplacingOccurrencesOfString:@"_min" withString:@""];
            self.PhotoModel.photoHouse2 = self.photoHouse2;
        }
            break;
        case 3:
        {
            self.photoHouse = self.photoHouseArr[0];
            self.photoHouse = [self.photoHouse stringByReplacingOccurrencesOfString:@"_min" withString:@""];
            self.PhotoModel.photoHouse = self.photoHouse;
            self.photoHouse2 = self.photoHouseArr[1];
            self.photoHouse2 = [self.photoHouse2 stringByReplacingOccurrencesOfString:@"_min" withString:@""];
            self.PhotoModel.photoHouse2 = self.photoHouse2;
            self.photoHouse3 = self.photoHouseArr[2];
            self.photoHouse3 = [self.photoHouse3 stringByReplacingOccurrencesOfString:@"_min" withString:@""];
            self.PhotoModel.photoHouse3 = self.photoHouse3;
        }
            break;
        default:
            break;
    }
    switch (self.photoMarryArr.count) {
        case 1:
        {
            self.photoMarry = self.photoMarryArr[0];
            self.photoMarry = [self.photoMarry stringByReplacingOccurrencesOfString:@"_min" withString:@""];
            self.PhotoModel.photoMarry = self.photoMarry;
        }
            break;
        case 2:
        {
            self.photoMarry = self.photoMarryArr[0];
            self.photoMarry = [self.photoMarry stringByReplacingOccurrencesOfString:@"_min" withString:@""];
            self.PhotoModel.photoMarry = self.photoMarry;
            self.photoMarry2 = self.photoMarryArr[1];
            self.photoMarry2 = [self.photoMarry2 stringByReplacingOccurrencesOfString:@"_min" withString:@""];
            self.PhotoModel.photoMarry2 = self.photoMarry2;
        }
            break;
        case 3:
        {
            self.photoMarry = self.photoMarryArr[0];
            self.photoMarry = [self.photoMarry stringByReplacingOccurrencesOfString:@"_min" withString:@""];
            self.PhotoModel.photoMarry = self.photoMarry;
            self.photoMarry2 = self.photoMarryArr[1];
            self.photoMarry2 = [self.photoMarry2 stringByReplacingOccurrencesOfString:@"_min" withString:@""];
            self.PhotoModel.photoMarry2 = self.photoMarry2;
            self.photoMarry3 = self.photoMarryArr[2];
            self.photoMarry3 = [self.photoMarry3 stringByReplacingOccurrencesOfString:@"_min" withString:@""];
            self.PhotoModel.photoMarry3 = self.photoMarry3;
        }
            break;
        default:
            break;
    }
    
    switch (self.photoWorkArr.count) {
        case 1:
        {
            self.photoWork = self.photoWorkArr[0];
            self.photoWork = [self.photoWork stringByReplacingOccurrencesOfString:@"_min" withString:@""];
            self.PhotoModel.photoWork = self.photoWork;
        }
            break;
        case 2:
        {
            self.photoWork = self.photoWorkArr[0];
            self.photoWork = [self.photoWork stringByReplacingOccurrencesOfString:@"_min" withString:@""];
            self.PhotoModel.photoWork = self.photoWork;
            self.photoWork2 = self.photoWorkArr[1];
            self.photoWork2 = [self.photoWork2 stringByReplacingOccurrencesOfString:@"_min" withString:@""];
            self.PhotoModel.photoWork2 = self.photoWork2;
        }
            break;
        case 3:
        {
            self.photoWork = self.photoWorkArr[0];
            self.photoWork = [self.photoWork stringByReplacingOccurrencesOfString:@"_min" withString:@""];
            self.PhotoModel.photoWork = self.photoWork;
            self.photoWork2 = self.photoWorkArr[1];
            self.photoWork2 = [self.photoWork2 stringByReplacingOccurrencesOfString:@"_min" withString:@""];
            self.PhotoModel.photoWork2 = self.photoWork2;
            self.photoWork3 = self.photoWorkArr[2];
            self.photoWork3 = [self.photoWork3 stringByReplacingOccurrencesOfString:@"_min" withString:@""];
            self.PhotoModel.photoWork3 = self.photoWork3;
        }
            break;
        default:
            break;
    }
    switch (self.photoWagesArr.count) {
        case 1:
        {
            self.photoWages = self.photoWagesArr[0];
            self.photoWages = [self.photoWages stringByReplacingOccurrencesOfString:@"_min" withString:@""];
            self.PhotoModel.photoWages = self.photoWages;
        }
            break;
        case 2:
        {
            self.photoWages = self.photoWagesArr[0];
            self.photoWages = [self.photoWages stringByReplacingOccurrencesOfString:@"_min" withString:@""];
            self.PhotoModel.photoWages = self.photoWages;
            self.photoWages2 = self.photoWagesArr[1];
            self.photoWages2 = [self.photoWages2 stringByReplacingOccurrencesOfString:@"_min" withString:@""];
            self.PhotoModel.photoWages2 = self.photoWages2;
        }
            break;
        case 3:
        {
            self.photoWages = self.photoWagesArr[0];
            self.photoWages = [self.photoWages stringByReplacingOccurrencesOfString:@"_min" withString:@""];
            self.PhotoModel.photoWages = self.photoWages;
            self.photoWages2 = self.photoWagesArr[1];
            self.photoWages2 = [self.photoWages2 stringByReplacingOccurrencesOfString:@"_min" withString:@""];
            self.PhotoModel.photoWages2 = self.photoWages2;
            self.photoWages3 = self.photoWagesArr[2];
            self.photoWages3 = [self.photoWages3 stringByReplacingOccurrencesOfString:@"_min" withString:@""];
            self.PhotoModel.photoWages3 = self.photoWages3;
        }
            break;
        default:
            break;
    }
    switch (self.photoCreditArr.count) {
        case 1:
        {
            self.photoCredit = self.photoCreditArr[0];
            self.photoCredit = [self.photoCredit stringByReplacingOccurrencesOfString:@"_min" withString:@""];
            self.PhotoModel.photoCredit = self.photoCredit;
        }
            break;
        case 2:
        {
            self.photoCredit = self.photoCreditArr[0];
            self.photoCredit = [self.photoCredit stringByReplacingOccurrencesOfString:@"_min" withString:@""];
            self.PhotoModel.photoCredit = self.photoCredit;
            self.photoCredit2 = self.photoCreditArr[1];
            self.photoCredit2 = [self.photoCredit2 stringByReplacingOccurrencesOfString:@"_min" withString:@""];
            self.PhotoModel.photoCredit2 = self.photoCredit2;
        }
            break;
        case 3:
        {
            self.photoCredit = self.photoCreditArr[0];
            self.photoCredit = [self.photoCredit stringByReplacingOccurrencesOfString:@"_min" withString:@""];
            self.PhotoModel.photoCredit = self.photoCredit;
            self.photoCredit2 = self.photoCreditArr[1];
            self.photoCredit2 = [self.photoCredit2 stringByReplacingOccurrencesOfString:@"_min" withString:@""];
            self.PhotoModel.photoCredit2 = self.photoCredit2;
            self.photoCredit3 = self.photoCreditArr[2];
            self.photoCredit3 = [self.photoCredit3 stringByReplacingOccurrencesOfString:@"_min" withString:@""];
            self.PhotoModel.photoCredit3 = self.photoCredit3;
        }
            break;
        case 4:
        {
            self.photoCredit = self.photoCreditArr[0];
            self.photoCredit = [self.photoCredit stringByReplacingOccurrencesOfString:@"_min" withString:@""];
            self.PhotoModel.photoCredit = self.photoCredit;
            self.photoCredit2 = self.photoCreditArr[1];
            self.photoCredit2 = [self.photoCredit2 stringByReplacingOccurrencesOfString:@"_min" withString:@""];
            self.PhotoModel.photoCredit2 = self.photoCredit2;
            self.photoCredit3 = self.photoCreditArr[2];
            self.photoCredit3 = [self.photoCredit3 stringByReplacingOccurrencesOfString:@"_min" withString:@""];
            self.PhotoModel.photoCredit3 = self.photoCredit3;
            self.photoCredit4 = self.photoCreditArr[3];
            self.photoCredit4 = [self.photoCredit4 stringByReplacingOccurrencesOfString:@"_min" withString:@""];
            self.PhotoModel.photoCredit4 = self.photoCredit4;
        }
            break;
        case 5:
        {
            self.photoCredit = self.photoCreditArr[0];
            self.photoCredit = [self.photoCredit stringByReplacingOccurrencesOfString:@"_min" withString:@""];
            self.PhotoModel.photoCredit = self.photoCredit;
            self.photoCredit2 = self.photoCreditArr[1];
            self.photoCredit2 = [self.photoCredit2 stringByReplacingOccurrencesOfString:@"_min" withString:@""];
            self.PhotoModel.photoCredit2 = self.photoCredit2;
            self.photoCredit3 = self.photoCreditArr[2];
            self.photoCredit3 = [self.photoCredit3 stringByReplacingOccurrencesOfString:@"_min" withString:@""];
            self.PhotoModel.photoCredit3 = self.photoCredit3;
            self.photoCredit4 = self.photoCreditArr[3];
            self.photoCredit4 = [self.photoCredit4 stringByReplacingOccurrencesOfString:@"_min" withString:@""];
            self.PhotoModel.photoCredit4 = self.photoCredit4;
            self.photoCredit5 = self.photoCreditArr[4];
            self.photoCredit5 = [self.photoCredit5 stringByReplacingOccurrencesOfString:@"_min" withString:@""];
            self.PhotoModel.photoCredit5 = self.photoCredit5;
        }
            break;
        case 6:
        {
            self.photoCredit = self.photoCreditArr[0];
            self.photoCredit = [self.photoCredit stringByReplacingOccurrencesOfString:@"_min" withString:@""];
            self.PhotoModel.photoCredit = self.photoCredit;
            self.photoCredit2 = self.photoCreditArr[1];
            self.photoCredit2 = [self.photoCredit2 stringByReplacingOccurrencesOfString:@"_min" withString:@""];
            self.PhotoModel.photoCredit2 = self.photoCredit2;
            self.photoCredit3 = self.photoCreditArr[2];
            self.photoCredit3 = [self.photoCredit3 stringByReplacingOccurrencesOfString:@"_min" withString:@""];
            self.PhotoModel.photoCredit3 = self.photoCredit3;
            self.photoCredit4 = self.photoCreditArr[3];
            self.photoCredit4 = [self.photoCredit4 stringByReplacingOccurrencesOfString:@"_min" withString:@""];
            self.PhotoModel.photoCredit4 = self.photoCredit4;
            self.photoCredit5 = self.photoCreditArr[4];
            self.photoCredit5 = [self.photoCredit5 stringByReplacingOccurrencesOfString:@"_min" withString:@""];
            self.PhotoModel.photoCredit5 = self.photoCredit5;
            self.photoCredit6 = self.photoCreditArr[5];
            self.photoCredit6 = [self.photoCredit6 stringByReplacingOccurrencesOfString:@"_min" withString:@""];
            self.PhotoModel.photoCredit6 = self.photoCredit6;
        }
            break;
        case 7:
        {
            self.photoCredit = self.photoCreditArr[0];
            self.photoCredit = [self.photoCredit stringByReplacingOccurrencesOfString:@"_min" withString:@""];
            self.PhotoModel.photoCredit = self.photoCredit;
            self.photoCredit2 = self.photoCreditArr[1];
            self.photoCredit2 = [self.photoCredit2 stringByReplacingOccurrencesOfString:@"_min" withString:@""];
            self.PhotoModel.photoCredit2 = self.photoCredit2;
            self.photoCredit3 = self.photoCreditArr[2];
            self.photoCredit3 = [self.photoCredit3 stringByReplacingOccurrencesOfString:@"_min" withString:@""];
            self.PhotoModel.photoCredit3 = self.photoCredit3;
            self.photoCredit4 = self.photoCreditArr[3];
            self.photoCredit4 = [self.photoCredit4 stringByReplacingOccurrencesOfString:@"_min" withString:@""];
            self.PhotoModel.photoCredit4 = self.photoCredit4;
            self.photoCredit5 = self.photoCreditArr[4];
            self.photoCredit5 = [self.photoCredit5 stringByReplacingOccurrencesOfString:@"_min" withString:@""];
            self.PhotoModel.photoCredit5 = self.photoCredit5;
            self.photoCredit5 = [self.photoCredit5 stringByReplacingOccurrencesOfString:@"_min" withString:@""];
            self.PhotoModel.photoCredit5 = self.photoCredit5;
            self.photoCredit6 = self.photoCreditArr[5];
            self.photoCredit6 = [self.photoCredit6 stringByReplacingOccurrencesOfString:@"_min" withString:@""];
            self.PhotoModel.photoCredit6 = self.photoCredit6;
            self.photoCredit7 = self.photoCreditArr[6];
            self.photoCredit7 = [self.photoCredit7 stringByReplacingOccurrencesOfString:@"_min" withString:@""];
            self.PhotoModel.photoCredit7 = self.photoCredit7;
            
        }
            break;
        case 8:
        {
            self.photoCredit = self.photoCreditArr[0];
            self.photoCredit = [self.photoCredit stringByReplacingOccurrencesOfString:@"_min" withString:@""];
            self.PhotoModel.photoCredit = self.photoCredit;
            self.photoCredit2 = self.photoCreditArr[1];
            self.photoCredit2 = [self.photoCredit2 stringByReplacingOccurrencesOfString:@"_min" withString:@""];
            self.PhotoModel.photoCredit2 = self.photoCredit2;
            self.photoCredit3 = self.photoCreditArr[2];
            self.photoCredit3 = [self.photoCredit3 stringByReplacingOccurrencesOfString:@"_min" withString:@""];
            self.PhotoModel.photoCredit3 = self.photoCredit3;
            self.photoCredit4 = self.photoCreditArr[3];
            self.photoCredit4 = [self.photoCredit4 stringByReplacingOccurrencesOfString:@"_min" withString:@""];
            self.PhotoModel.photoCredit4 = self.photoCredit4;
            self.photoCredit5 = self.photoCreditArr[4];
            self.photoCredit5 = [self.photoCredit5 stringByReplacingOccurrencesOfString:@"_min" withString:@""];
            self.PhotoModel.photoCredit5 = self.photoCredit5;
            self.photoCredit6 = self.photoCreditArr[5];
            self.photoCredit6 = [self.photoCredit6 stringByReplacingOccurrencesOfString:@"_min" withString:@""];
            self.PhotoModel.photoCredit6 = self.photoCredit6;
            self.photoCredit7 = self.photoCreditArr[6];
            self.photoCredit7 = [self.photoCredit7 stringByReplacingOccurrencesOfString:@"_min" withString:@""];
            self.PhotoModel.photoCredit7 = self.photoCredit7;
            self.photoCredit8 = self.photoCreditArr[7];
            self.photoCredit8 = [self.photoCredit8 stringByReplacingOccurrencesOfString:@"_min" withString:@""];
            self.PhotoModel.photoCredit8 = self.photoCredit8;
        }
            break;
        case 9:
        {
            self.photoCredit = self.photoCreditArr[0];
            self.photoCredit = [self.photoCredit stringByReplacingOccurrencesOfString:@"_min" withString:@""];
            self.PhotoModel.photoCredit = self.photoCredit;
            self.photoCredit2 = self.photoCreditArr[1];
            self.photoCredit2 = [self.photoCredit2 stringByReplacingOccurrencesOfString:@"_min" withString:@""];
            self.PhotoModel.photoCredit2 = self.photoCredit2;
            self.photoCredit3 = self.photoCreditArr[2];
            self.photoCredit3 = [self.photoCredit3 stringByReplacingOccurrencesOfString:@"_min" withString:@""];
            self.PhotoModel.photoCredit3 = self.photoCredit3;
            self.photoCredit4 = self.photoCreditArr[3];
            self.photoCredit4 = [self.photoCredit4 stringByReplacingOccurrencesOfString:@"_min" withString:@""];
            self.PhotoModel.photoCredit4 = self.photoCredit4;
            self.photoCredit5 = self.photoCreditArr[4];
            self.photoCredit5 = [self.photoCredit5 stringByReplacingOccurrencesOfString:@"_min" withString:@""];
            self.PhotoModel.photoCredit5 = self.photoCredit5;
            self.photoCredit6 = self.photoCreditArr[5];
            self.photoCredit6 = [self.photoCredit6 stringByReplacingOccurrencesOfString:@"_min" withString:@""];
            self.PhotoModel.photoCredit6 = self.photoCredit6;
            self.photoCredit7 = self.photoCreditArr[6];
            self.photoCredit7 = [self.photoCredit7 stringByReplacingOccurrencesOfString:@"_min" withString:@""];
            self.PhotoModel.photoCredit7 = self.photoCredit7;
            self.photoCredit8 = self.photoCreditArr[7];
            self.photoCredit8 = [self.photoCredit8 stringByReplacingOccurrencesOfString:@"_min" withString:@""];
            self.PhotoModel.photoCredit8 = self.photoCredit8;
            self.photoCredit9 = self.photoCreditArr[8];
            self.photoCredit9 = [self.photoCredit9 stringByReplacingOccurrencesOfString:@"_min" withString:@""];
            self.PhotoModel.photoCredit9 = self.photoCredit9;
        }
            break;
        case 10:
        {
            self.photoCredit = self.photoCreditArr[0];
            self.photoCredit = [self.photoCredit stringByReplacingOccurrencesOfString:@"_min" withString:@""];
            self.PhotoModel.photoCredit = self.photoCredit;
            self.photoCredit2 = self.photoCreditArr[1];
            self.photoCredit2 = [self.photoCredit2 stringByReplacingOccurrencesOfString:@"_min" withString:@""];
            self.PhotoModel.photoCredit2 = self.photoCredit2;
            self.photoCredit3 = self.photoCreditArr[2];
            self.photoCredit3 = [self.photoCredit3 stringByReplacingOccurrencesOfString:@"_min" withString:@""];
            self.PhotoModel.photoCredit3 = self.photoCredit3;
            self.photoCredit4 = self.photoCreditArr[3];
            self.photoCredit4 = [self.photoCredit4 stringByReplacingOccurrencesOfString:@"_min" withString:@""];
            self.PhotoModel.photoCredit4 = self.photoCredit4;
            self.photoCredit5 = self.photoCreditArr[4];
            self.photoCredit5 = [self.photoCredit5 stringByReplacingOccurrencesOfString:@"_min" withString:@""];
            self.PhotoModel.photoCredit5 = self.photoCredit5;
            self.photoCredit6 = self.photoCreditArr[5];
            self.photoCredit6 = [self.photoCredit6 stringByReplacingOccurrencesOfString:@"_min" withString:@""];
            self.PhotoModel.photoCredit6 = self.photoCredit6;
            self.photoCredit7 = self.photoCreditArr[6];
            self.photoCredit7 = [self.photoCredit7 stringByReplacingOccurrencesOfString:@"_min" withString:@""];
            self.PhotoModel.photoCredit7 = self.photoCredit7;
            self.photoCredit8 = self.photoCreditArr[7];
            self.photoCredit8 = [self.photoCredit8 stringByReplacingOccurrencesOfString:@"_min" withString:@""];
            self.PhotoModel.photoCredit8 = self.photoCredit8;
            self.photoCredit9 = self.photoCreditArr[8];
            self.photoCredit9 = [self.photoCredit9 stringByReplacingOccurrencesOfString:@"_min" withString:@""];
            self.PhotoModel.photoCredit9 = self.photoCredit9;
            self.photoCredit10 = self.photoCreditArr[9];
            self.photoCredit10 = [self.photoCredit10 stringByReplacingOccurrencesOfString:@"_min" withString:@""];
            self.PhotoModel.photoCredit10 = self.photoCredit10;
        }
            break;
        default:
            break;
    }
    switch (self.photoOtherArr.count) {
        case 1:
        {
            self.photoOther = self.photoOtherArr[0];
            self.photoOther = [self.photoOther stringByReplacingOccurrencesOfString:@"_min" withString:@""];
            self.PhotoModel.photoOther = self.photoOther;
        }
            break;
        case 2:
        {
            self.photoOther = self.photoOtherArr[0];
            self.photoOther = [self.photoOther stringByReplacingOccurrencesOfString:@"_min" withString:@""];
            self.PhotoModel.photoOther = self.photoOther;
            self.photoOther2 = self.photoOtherArr[1];
            self.photoOther2 = [self.photoOther2 stringByReplacingOccurrencesOfString:@"_min" withString:@""];
            self.PhotoModel.photoOther2 = self.photoOther2;
        }
            break;
        case 3:
        {
            self.photoOther = self.photoOtherArr[0];
            self.photoOther = [self.photoOther stringByReplacingOccurrencesOfString:@"_min" withString:@""];
            self.PhotoModel.photoOther = self.photoOther;
            self.photoOther2 = self.photoOtherArr[1];
            self.photoOther2 = [self.photoOther2 stringByReplacingOccurrencesOfString:@"_min" withString:@""];
            self.PhotoModel.photoOther2 = self.photoOther2;
            self.photoOther3 = self.photoOtherArr[2];
            self.photoOther3 = [self.photoOther3 stringByReplacingOccurrencesOfString:@"_min" withString:@""];
            self.PhotoModel.photoOther3 = self.photoOther3;
        }
            break;
        default:
            break;
    }
    if (self.returnPhotoBlock != nil) {
        self.returnPhotoBlock(self.PhotoModel);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)returnPhoto:(ReturnPhotoBlock)block {
    self.returnPhotoBlock = block;
}
#pragma mark - photobrowser代理方法
- (UIImage *)photoBrowser:(STPhotoBrowserController *)browser placeholderImageForIndex:(NSInteger)index
{
    if (self.whitchBtn == 1001) {
        return [self.currentView.subviews[2] currentImage];
    } else {
        return [self.currentView.subviews[index] currentImage];
    }
//    return [self.currentView.subviews[index] currentImage];
}

- (NSURL *)photoBrowser:(STPhotoBrowserController *)browser highQualityImageURLForIndex:(NSInteger)index
{
    NSString *urlStr = [self.currentArray[index] stringByReplacingOccurrencesOfString:@"_min" withString:@""];
    
    return [urlStr convertHostUrl];
}


- (void)photoViewControllerDidNext:(NSArray<HXPhotoModel *> *)allList Photos:(NSArray<HXPhotoModel *> *)photos Videos:(NSArray<HXPhotoModel *> *)videos Original:(BOOL)original
{
    self.original = original;
    self.photos = [NSMutableArray arrayWithArray:photos];
    self.videos = [NSMutableArray arrayWithArray:videos];
    [self.dataList removeAllObjects];
    
    [self.dataList addObjectsFromArray:allList];
    
    if (self.manager.selectTogether) {
        if (self.manager.maxNum == allList.count) {
            [self.dataList removeLastObject];
            
        }
    }else {
        if (photos.count == self.manager.photoMaxNum) {
            [self.dataList removeLastObject];
            
        }else if (videos.count == self.manager.videoMaxNum) {
            [self.dataList removeLastObject];
            
        }
    }
    [self changeSelectedListModelIndex];
    
}
- (void)changeSelectedListModelIndex
{
    int i = 0, j = 0, k = 0;
    for (HXPhotoModel *model in self.manager.endSelectedList) {
        if ((model.type == HXPhotoModelMediaTypePhoto || model.type == HXPhotoModelMediaTypePhotoGif) || (model.type == HXPhotoModelMediaTypeCameraPhoto || model.type == HXPhotoModelMediaTypeLivePhoto)) {
            model.endIndex = i++;
        }else if (model.type == HXPhotoModelMediaTypeVideo || model.type == HXPhotoModelMediaTypeCameraVideo) {
            model.endIndex = j++;
        }
        model.endCollectionIndex = k++;
    }
}

//- (void)presentPhotoPickerViewControllerWithStyle:(LGShowImageType)style withCount:(int)count {
//    LGPhotoPickerViewController *pickerVc = [[LGPhotoPickerViewController alloc] initWithShowType:style];
//    pickerVc.status = PickerViewShowStatusCameraRoll;
//    pickerVc.maxCount = count;   // 最多能选9张图片
//    pickerVc.delegate = self;
//    self.showType = style;
//    [pickerVc showPickerVc:self];
//}
//
///**
// *  初始化图片浏览器
// */
//- (void)pushPhotoBroswerWithStyle:(LGShowImageType)style{
//    LGPhotoPickerBrowserViewController *BroswerVC = [[LGPhotoPickerBrowserViewController alloc] init];
//    BroswerVC.delegate = self;
//    BroswerVC.dataSource = self;
//    BroswerVC.showType = style;
//    self.showType = style;
//    [self presentViewController:BroswerVC animated:YES completion:nil];
//}
//
///**
// *  初始化自定义相机（单拍）
// */
//- (void)presentCameraSingle {
//    ZLCameraViewController *cameraVC = [[ZLCameraViewController alloc] init];
//    // 拍照最多个数
//    cameraVC.maxCount = 1;
//    // 单拍
//    cameraVC.cameraType = ZLCameraSingle;
//    cameraVC.callback = ^(NSArray *cameras){
//        //在这里得到拍照结果
//        //数组元素是ZLCamera对象
//        /*
//         @exemple
//         ZLCamera *canamerPhoto = cameras[0];
//         UIImage *image = canamerPhoto.photoImage;
//         */
//        ZLCamera *canamerPhoto = cameras[0];
//        UIImage *image = canamerPhoto.photoImage;
//        [HttpRequestEngine uploadImageData:[self getDataWitdImgae:image] fileName:@"front.jpg" completion:^(id obj, NSString *errorStr) {
//            if (errorStr)
//            {
//                [MBProgressHUD showError:errorStr toView:self.view];
//            }else{
//                
//                NSDictionary *dic = [NSDictionary changeType:obj];
//                
//                switch (self.whitchBtn) {
//                    case 1000:
//                    {
//                        self.photoIdFront = dic[@"errorMsg"];
//                        [self.photoIdArr addObject:self.photoIdFront];
//                    }
//                        break;
//                    case 1001:
//                    {
//                        self.photoIdBack = dic[@"errorMsg"];
//                        [self.photoIdArr addObject:self.photoIdBack];
//                    }
//                        break;
//                    default:
//                        break;
//                }
//                switch (self.whitchBtn/1000) {
//                    case 2:
//                    {
//                        [self.photoRegistArr addObject:dic[@"errorMsg"]];
//                    }
//                        break;
//                    case 3:
//                    {
//                        [self.photoHouseArr addObject:dic[@"errorMsg"]];
//                    }
//                        break;
//                    case 4:
//                    {
//                        [self.photoMarryArr addObject:dic[@"errorMsg"]];
//                    }
//                        break;
//                    case 5:
//                    {
//                        [self.photoWorkArr addObject:dic[@"errorMsg"]];
//                    }
//                        break;
//                    case 6:
//                    {
//                        [self.photoWagesArr addObject:dic[@"errorMsg"]];
//                    }
//                        break;
//                    case 7:
//                    {
//                        [self.photoCreditArr addObject:dic[@"errorMsg"]];
//                    }
//                        break;
//                    case 8:
//                    {
//                        [self.photoOtherArr addObject:dic[@"errorMsg"]];
//                    }
//                        break;
//                    default:
//                        break;
//                }
//                [MBProgressHUD showSuccess:@"上传成功"];
//                [self.photosTableView reloadData];
//            }
//            
//        }];
//    };
//    [cameraVC showPickerVc:self];
//}
//
//#pragma mark - LGPhotoPickerViewControllerDelegate
//
//- (void)pickerViewControllerDoneAsstes:(NSArray *)assets isOriginal:(BOOL)original{
//    
//    //assets的元素是LGPhotoAssets对象，获取image方法如下:
//    NSMutableArray *thumbImageArray = [NSMutableArray array];
//    NSMutableArray *originImage = [NSMutableArray array];
//    NSMutableArray *fullResolutionImage = [NSMutableArray array];
//    
//    for (LGPhotoAssets *photo in assets) {
//        //缩略图
//        [thumbImageArray addObject:photo.thumbImage];
//        //原图
//        [originImage addObject:photo.originImage];
//        //全屏图
//        [fullResolutionImage addObject:photo.fullResolutionImage];
//    }
//    NSLog(@"%@",fullResolutionImage);
//    for (UIImage *image in fullResolutionImage) {
//        
//        [HttpRequestEngine uploadImageData:[self getDataWitdImgae:image] fileName:@"front.jpg" completion:^(id obj, NSString *errorStr) {
//            if (errorStr)
//            {
//                [MBProgressHUD showError:errorStr toView:self.view];
//            }else{
//                
//                NSDictionary *dic = [NSDictionary changeType:obj];
//                
//                switch (self.whitchBtn) {
//                    case 1000:
//                    {
//                        self.photoIdFront = dic[@"errorMsg"];
//                        [self.photoIdArr addObject:self.photoIdFront];
//                    }
//                        break;
//                    case 1001:
//                    {
//                        self.photoIdBack = dic[@"errorMsg"];
//                        [self.photoIdArr addObject:self.photoIdBack];
//                    }
//                        break;
//                    default:
//                        break;
//                }
//                switch (self.whitchBtn/1000) {
//                    case 2:
//                    {
//                        [self.photoRegistArr addObject:dic[@"errorMsg"]];
//                    }
//                        break;
//                    case 3:
//                    {
//                        [self.photoHouseArr addObject:dic[@"errorMsg"]];
//                    }
//                        break;
//                    case 4:
//                    {
//                        [self.photoMarryArr addObject:dic[@"errorMsg"]];
//                    }
//                        break;
//                    case 5:
//                    {
//                        [self.photoWorkArr addObject:dic[@"errorMsg"]];
//                    }
//                        break;
//                    case 6:
//                    {
//                        [self.photoWagesArr addObject:dic[@"errorMsg"]];
//                    }
//                        break;
//                    case 7:
//                    {
//                        [self.photoCreditArr addObject:dic[@"errorMsg"]];
//                    }
//                        break;
//                    case 8:
//                    {
//                        [self.photoOtherArr addObject:dic[@"errorMsg"]];
//                    }
//                        break;
//                    default:
//                        break;
//                }
//                [MBProgressHUD showSuccess:@"上传成功"];
//                [self.photosTableView reloadData];
//            }
//            
//        }];
//    }
////    NSInteger num = (long)assets.count;
////    NSString *isOriginal = original? @"YES":@"NO";
////    JKAlertView *alertView = [[JKAlertView alloc] initWithTitle:@"发送图片" message:[NSString stringWithFormat:@"您选择了%ld张图片\n是否原图：%@",(long)num,isOriginal] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
////    [alertView show];
//}

#pragma mark - LGPhotoPickerBrowserViewControllerDataSource

//- (NSInteger)photoBrowser:(LGPhotoPickerBrowserViewController *)photoBrowser numberOfItemsInSection:(NSUInteger)section{
//    if (self.showType == LGShowImageTypeImageBroswer) {
//        return self.LGPhotoPickerBrowserPhotoArray.count;
//    } else if (self.showType == LGShowImageTypeImageURL) {
//        return self.LGPhotoPickerBrowserURLArray.count;
//    } else {
//        NSLog(@"非法数据源");
//        return 0;
//    }
//}
//
//- (id<LGPhotoPickerBrowserPhoto>)photoBrowser:(LGPhotoPickerBrowserViewController *)pickerBrowser photoAtIndexPath:(NSIndexPath *)indexPath{
//    if (self.showType == LGShowImageTypeImageBroswer) {
//        return [self.LGPhotoPickerBrowserPhotoArray objectAtIndex:indexPath.item];
//    } else if (self.showType == LGShowImageTypeImageURL) {
//        return [self.LGPhotoPickerBrowserURLArray objectAtIndex:indexPath.item];
//    } else {
//        NSLog(@"非法数据源");
//        return nil;
//    }
//}
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
