//
//  MineInfoViewController.m
//  Financeteam
//
//  Created by Zccf on 16/5/17.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "MineInfoViewController.h"
#import "MineHeadImageTableViewCell.h"
#import "MineInfoTableViewCell.h"
@interface MineInfoViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UITextFieldDelegate>{
    NSArray *_InfoStyleArr;
    NSArray *_InfoDetailArr;
    NSUserDefaults *_userDefaults;
    LoginPeopleModel *loginModel;
    UIView *hehe;
    UIImagePickerController *_imagePickerC;
}
@property (nonatomic, strong) UITableView *mineTableView;
@property (nonatomic, strong) AppDelegate *Mydelegate;
@property (nonatomic, strong) UIView *alertView;
@property (nonatomic, strong) UITextField *nameTF;
@property (nonatomic, strong) UIView *vv;
@property (nonatomic, strong) NSString *imgaePath;
@property (nonatomic, strong) NSString *nameStr;
@end

@implementation MineInfoViewController
- (UITableView *)mineTableView {
    if (!_mineTableView) {
        _mineTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NaviHeight, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
        _mineTableView.backgroundColor = VIEW_BASE_COLOR;
        
    }
    return _mineTableView;
}
- (UIView *)alertView {
    if (!_alertView) {
        _alertView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _alertView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ClickAlert:)];
        [_alertView addGestureRecognizer:tap];
        hehe = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth-50*KAdaptiveRateWidth, 100*KAdaptiveRateHeight)];
        hehe.backgroundColor = [UIColor whiteColor];
        hehe.center = self.navigationController.view.center;
        [_alertView addSubview:hehe];
//        hehe.layer.masksToBounds = YES;
        [hehe.layer setCornerRadius:10];
        self.nameTF = [[UITextField alloc] initWithFrame:CGRectMake(15*KAdaptiveRateWidth, 15*KAdaptiveRateHeight, kScreenWidth-80*KAdaptiveRateWidth, 30*KAdaptiveRateHeight)];
//        self.nameTF.center = CGPointMake(hehe.center.x, hehe.center.y-50);
        self.nameTF.borderStyle = UITextBorderStyleRoundedRect;
        self.nameTF.delegate = self;
        self.nameTF.placeholder = @"请输入姓名";
        self.nameTF.returnKeyType = UIReturnKeyDone;
        self.nameTF.clearButtonMode = UITextFieldViewModeAlways;
        self.nameTF.text = [NSString stringWithFormat:@"%@",loginModel.realName];
        [hehe addSubview:self.nameTF];
        UIButton *CancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        CancelBtn.frame = CGRectMake(0, 60*KAdaptiveRateHeight, (kScreenWidth-50*KAdaptiveRateWidth)/2.0, 40*KAdaptiveRateHeight);
        [CancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [CancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [CancelBtn addTarget:self action:@selector(ClickCancel) forControlEvents:UIControlEventTouchUpInside];
        [hehe addSubview:CancelBtn];
        UIButton *EnsureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        EnsureBtn.frame = CGRectMake((kScreenWidth-50*KAdaptiveRateWidth)/2.0, 60*KAdaptiveRateHeight, (kScreenWidth-50*KAdaptiveRateWidth)/2.0, 40*KAdaptiveRateHeight);
        [EnsureBtn setTitleColor:TABBAR_BASE_COLOR forState:UIControlStateNormal];
        [EnsureBtn setTitle:@"确定" forState:UIControlStateNormal];
        EnsureBtn.tag = 1000;
        [EnsureBtn addTarget:self action:@selector(ClickEnsure) forControlEvents:UIControlEventTouchUpInside];
        [hehe addSubview:EnsureBtn];
        
    }
    return _alertView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"个人信息";
    self.Mydelegate = [UIApplication sharedApplication].delegate;
    _userDefaults = [NSUserDefaults standardUserDefaults];
    _InfoStyleArr = @[@[@"头像"],@[@"名字",@"手机"]];
    loginModel = [LoginPeopleModel requestWithDic:[[LocalMeManager sharedPersonalInfoManager] loginPeopleInfo]];

    NSDictionary *auInfo = [_userDefaults objectForKey:@"auInfo"];
    _InfoDetailArr = @[@[[NSString stringWithFormat:@"%@",auInfo[@"icon"]]],@[[NSString stringWithFormat:@"%@",loginModel.realName],[[NSUserDefaults standardUserDefaults] objectForKey:@"name"]]];
    
    [self.view addSubview:self.mineTableView];
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [self.mineTableView setTableFooterView:view];
    self.mineTableView.delegate = self;
    self.mineTableView.dataSource = self;
    [self.mineTableView registerClass:[MineHeadImageTableViewCell class] forCellReuseIdentifier:@"head"];
    [self.mineTableView registerClass:[MineInfoTableViewCell class] forCellReuseIdentifier:@"cell"];
    self.mineTableView.bounces = NO;
    self.vv = [[UIView alloc]initWithFrame:self.view.bounds];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    // Do any additional setup after loading the view.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
        return 2;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 80;
    }
    return 55;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        MineHeadImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"head" forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[MineHeadImageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"head"];
        }
        cell.InfoLB.text = _InfoStyleArr[indexPath.section][indexPath.row];
        NSString *imagePath = [NSString stringWithFormat:@"%@%@",PHOTO_ADDRESS,loginModel.iconURL];
        NSURL *imageURL = [NSURL URLWithString:imagePath];
        [cell.InfoImage sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"聊天头像"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
        }];
        return cell;
    } else {
        MineInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[MineInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        cell.InfoName.text = _InfoStyleArr[indexPath.section][indexPath.row];
        if (indexPath.row == 0) {
            cell.InfoLB.text = [NSString stringWithFormat:@"%@",loginModel.realName];
        } else {
            cell.InfoLB.text = _InfoDetailArr[indexPath.section][indexPath.row];
        }
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        UIActionSheet *actionsheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选取", nil];
        [actionsheet showInView:self.navigationController.view];
    } else {
        if (indexPath.row == 0) {
            [self.navigationController.view addSubview:self.alertView];
        }
    }
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    _imagePickerC = [[UIImagePickerController alloc]init];
    UIFont *font = [UIFont systemFontOfSize:17];
    NSDictionary *textAttributes = @{
                                     NSFontAttributeName : font,
                                     NSForegroundColorAttributeName : [UIColor whiteColor]
                                     };
    _imagePickerC.navigationBar.titleTextAttributes = textAttributes;
    [_imagePickerC.navigationBar setBarTintColor:kMyColor(29, 46, 55)];
    [_imagePickerC.navigationBar setTranslucent:NO];

    _imagePickerC.allowsEditing = YES;
    _imagePickerC.delegate = self;
//    if (buttonIndex == 0) { //拍照
//        
//    }else if(buttonIndex == 1){ //相册
//        
//    }
    switch (buttonIndex) {
        case 0:
        {
            _imagePickerC.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:_imagePickerC animated:YES completion:nil];
        }
            break;
            
        case 1:
        {
            _imagePickerC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:_imagePickerC animated:YES completion:nil];
        }
            break;
        case 2:
            
            break;
            
        default:
            break;
    }
}
#pragma mark -- UIImagePickerView
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
//    UIImage *getImage=  [info objectForKey: @"UIImagePickerControllerEditedImage"];
    UIImage *getImage=  [info objectForKey: @"UIImagePickerControllerEditedImage"];
    [self dismissViewControllerAnimated:picker completion:^{
//        UIButton* imagebtn = [self.mineTableView viewWithTag:19];
        
//        imagebtn.tag = 1;
        
        [HttpRequestEngine uploadImageData:[self getDataWitdImgae:getImage] fileName:@"front.jpg" completion:^(id obj, NSString *errorStr) {
            if (errorStr)
            {
                [MBProgressHUD showError:errorStr toView:self.view];
            }else{
                
                NSDictionary *dic = [NSDictionary changeType:obj];
                //                NSString * str = [NSString stringWithFormat:@"%@",obj];
                //                NSString * string = [str substringFromIndex:22];
                self.imgaePath = dic[@"errorMsg"];
//                NSLog(@"%@",self.imgaePath);
                NSDictionary *data = [[LocalMeManager sharedPersonalInfoManager] loginPeopleInfo];
                NSMutableDictionary *peopleDic = [NSMutableDictionary dictionaryWithDictionary:data];
                NSMutableDictionary *str = [NSMutableDictionary dictionaryWithDictionary:peopleDic[@"auInfo"]];
                [str setObject:self.imgaePath forKey:@"icon"];
                NSLog(@"str == %@",str);
                
                [peopleDic setObject:str forKey:@"auInfo"];
                NSLog(@"dic == %@",dic);
                [[LocalMeManager sharedPersonalInfoManager] setLoginPeopleInfo:peopleDic];
                loginModel = [LoginPeopleModel requestWithDic:[[LocalMeManager sharedPersonalInfoManager] loginPeopleInfo]];
                
                [self.mineTableView reloadData];
                [HttpRequestEngine updateUserInfoWithUid:[NSString stringWithFormat:@"%ld",loginModel.userId] name:[NSString stringWithFormat:@"%@",loginModel.realName] icon:[NSString stringWithFormat:@"%@",loginModel.iconURL] completion:^(id obj, NSString *errorStr) {
                    if (errorStr.length>0) {
                        
                    } else {
                        NSDictionary *dic = [NSDictionary changeType:obj];
                        NSString *code = [NSString stringWithFormat:@"%@",[dic objectForKey:@"code"]];
                        if ([code isEqualToString:@"1"]) {
                            
                        } else {
                            if (self.returnStrBlock != nil) {
                                self.returnStrBlock(@"1");
                            }
                            [MBProgressHUD showSuccess:@"修改成功"];
                        }
                    }
                }];
//                [imagebtn setBackgroundImage:getImage forState:UIControlStateNormal];
            }
        }];
    }];
}
#pragma mark -- 图片转Data
-(NSData  *)getDataWitdImgae:(UIImage *)originalImage{
    
    NSData *baseData = UIImageJPEGRepresentation(originalImage, 0.5);
    return baseData;
    
}

- (void)ClickCancel {
    NSLog(@"ClickCancel");
    [self.alertView removeFromSuperview];
}
- (void)ClickEnsure {
    NSLog(@"ClickEnsure");
    
    
    [self.alertView endEditing:YES];
    loginModel = [LoginPeopleModel requestWithDic:[[LocalMeManager sharedPersonalInfoManager] loginPeopleInfo]];
    NSString *headerData = loginModel.realName;
    headerData = [headerData stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    headerData = [headerData stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    NSLog(@"headerData == %@",headerData);
    if (headerData.length != 0) {
        [self.mineTableView reloadData];
        [HttpRequestEngine updateUserInfoWithUid:[NSString stringWithFormat:@"%ld",loginModel.userId] name:[NSString stringWithFormat:@"%@",loginModel.realName] icon:[NSString stringWithFormat:@"%@",loginModel.iconURL] completion:^(id obj, NSString *errorStr) {
            if (errorStr.length>0) {
                
            } else {
                NSDictionary *dic = [NSDictionary changeType:obj];
                NSString *code = [NSString stringWithFormat:@"%@",[dic objectForKey:@"code"]];
                NSString *name = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"name"]];
                NSString *pwd = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"pwd"]];
                [HttpRequestEngine againLoginWithName:name pwd:pwd completion:^(id obj, NSString *errorStr) {
                    if ([Utils isBlankString:errorStr]) {
                        if ([code isEqualToString:@"1"]) {
                            
                        } else {
                            if (self.returnStrBlock != nil) {
                                self.returnStrBlock(@"1");
                            }
                            [MBProgressHUD showSuccess:@"修改成功"];
                        }
                    }
                }];
                
                
            }
        }];
    } else {
        [MBProgressHUD showError:@"姓名输入有误"];
    }
    
    [self.alertView removeFromSuperview];
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSString *headerData = textField.text;
    headerData = [headerData stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    headerData = [headerData stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    NSLog(@"headerData == %@",headerData);
    if (headerData.length != 0) {
        NSDictionary *data = [[LocalMeManager sharedPersonalInfoManager] loginPeopleInfo];
        NSMutableDictionary *peopleDic = [NSMutableDictionary dictionaryWithDictionary:data];
        NSMutableDictionary *str = [NSMutableDictionary dictionaryWithDictionary:peopleDic[@"auInfo"]];
        [str setObject:textField.text forKey:@"real_name"];
        NSLog(@"str == %@",str);
        [peopleDic setObject:str forKey:@"auInfo"];
        [[LocalMeManager sharedPersonalInfoManager] setLoginPeopleInfo:peopleDic];
        [self.mineTableView reloadData];
        UIButton *btn = [self.navigationController.view viewWithTag:1000];
        btn.userInteractionEnabled = YES;
    } else {
        [MBProgressHUD showError:@"姓名不能为空"];
        UIButton *btn = [self.navigationController.view viewWithTag:1000];
        btn.userInteractionEnabled = NO;
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
#pragma mark -- 键盘弹出和消失的通知方法
-(void) keyboardWillShow:(NSNotification *)note{
    [self.navigationController.view addSubview:self.vv];
    self.vv.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyboard)];
    [self.vv addGestureRecognizer:tap];
    [UIView animateWithDuration:0.2 animations:^{
        hehe.center = CGPointMake(self.navigationController.view.center.x, self.navigationController.view.center.y - 100);
    }];
}
- (void)hideKeyboard {
    [UIView animateWithDuration:0.2 animations:^{
        hehe.center = self.navigationController.view.center;
    }];
    [self.alertView endEditing:YES];
    [self.vv removeFromSuperview];
}
- (void)keyboardDidHide:(NSNotification *)note{
    [self.vv removeFromSuperview];
    [UIView animateWithDuration:0.2 animations:^{
        hehe.center = self.navigationController.view.center;
    }];
}
- (void)ClickAlert:(UITapGestureRecognizer *)gr {
    CGPoint p = [gr locationInView:gr.view];
    if (p.y<kScreenHeight/2.0 - 50*KAdaptiveRateHeight ||p.y>kScreenHeight/2.0 + 50*KAdaptiveRateHeight) {
        [self.alertView removeFromSuperview];
    }
}
- (void)returnStr:(ReturnStrBlock)block {
    self.returnStrBlock = block;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
