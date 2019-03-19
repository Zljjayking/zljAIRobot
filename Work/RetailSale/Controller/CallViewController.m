//
//  ViewController.m
//  UI-Lesson-2-work
//
//  Created by archerzz on 15/4/27.
//  Copyright (c) 2015年 archerzz. All rights reserved.
//

#import "CallViewController.h"
#import "DetailViewController.h"

@interface CallViewController ()

@property (nonatomic, strong) UITextField *phoneTextField;
@property (nonatomic, strong) UIButton *addButton;
@property (nonatomic, strong) UIButton *deleteButton;

// 初始化用户界面
- (void)initializeUserInterface;
// 电话按钮点击
- (void)handleSpecailButtonWithText:(NSString *)text;
// 数字按钮点击
- (void)handleButtonEvent:(UIButton *)sender;
// 增加按钮点击
- (void)handleAddButtonEvent:(UIButton *)sender;
// 删除按钮点击
- (void)handleDeleteButtonEvent:(UIButton *)sender;

@end

@implementation CallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    [self initializeUserInterface];
    
    
}

- (void)initializeUserInterface
{
    
    UITextField *phoneTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 124, CGRectGetWidth(self.view.bounds), 40)];
    // 设置用户交互
    phoneTextField.userInteractionEnabled = NO;
    // 设置字体
    phoneTextField.font = [UIFont systemFontOfSize:22];
    // 设置对其方式
    phoneTextField.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:phoneTextField];
    self.phoneTextField = phoneTextField;
    
    
    NSArray *dataSource = @[@"1", @"2", @"3",
                            @"4", @"5", @"6",
                            @"7", @"8", @"9",
                            @"*", @"0", @"#"];
    for (int i = 0; i < 4; i ++) {
        for (int j = 0; j < 3; j ++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            // 设置坐标
            [button setFrame:CGRectMake(25 + j * 120, i * 100 + 120, 88, 88)];
            // 设置标题
            [button setTitle:dataSource[3 * i + j] forState:UIControlStateNormal];
            // 设置标题颜色
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            // 设置字体大小
            button.titleLabel.font = [UIFont systemFontOfSize:20];
            // 添加事件
            [button addTarget:self
                       action:@selector(handleButtonEvent:)
             forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:button];
        }
    }
    
    
    UIButton *callButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [callButton setBackgroundImage:
     [UIImage imageNamed:@"icon_voip_free_call"]
                forState:UIControlStateNormal];
    [callButton setBounds:CGRectMake(0, 0, 67, 67)];
    [callButton setCenter:CGPointMake(CGRectGetMidX(self.view.bounds), 570)];
    [callButton addTarget:self
                   action:@selector(handleCallButtonEvent:)
         forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:callButton];
    
    
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addButton.hidden = YES;
    [addButton setBackgroundImage:[UIImage imageNamed:@"icon_call_add"] forState:UIControlStateNormal];
    [addButton setFrame:CGRectMake(60, 560, 23, 23)];
    [addButton addTarget:self
                  action:@selector(handleAddButtonEvent:)
        forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addButton];
    
    UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteButton.hidden = YES;
    [deleteButton setBackgroundImage:[UIImage imageNamed:@"icon_call_delete"] forState:UIControlStateNormal];
    [deleteButton setFrame:CGRectMake(288, 563, 27, 19)];
    [deleteButton addTarget:self action:@selector(handleDeleteButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:deleteButton];
    
    self.addButton = addButton;
    self.deleteButton = deleteButton;
    
}


- (void)handleSpecailButtonWithText:(NSString *)text
{
    if (text.length > 0) {
        self.addButton.hidden = NO;
        self.deleteButton.hidden = NO;
    } else {
        self.addButton.hidden = YES;
        self.deleteButton.hidden = YES;
    }
}

#pragma mark - UIButtonEvent methods

- (void)handleButtonEvent:(UIButton *)sender
{
    NSString *text = sender.titleLabel.text;
    self.phoneTextField.text = [self.phoneTextField.text stringByAppendingString:text];
    
    [self handleSpecailButtonWithText:self.phoneTextField.text];
}

- (void)handleCallButtonEvent:(UIButton *)sender
{
    if (self.phoneTextField.text.length > 0) {
        // 初始化
        DetailViewController *detailVC = [[DetailViewController alloc] init];
        // 传值
        detailVC.phoneNumber = self.phoneTextField.text;
        // 推送
        [self presentViewController:detailVC animated:YES completion:nil];
        
    }

}

- (void)handleAddButtonEvent:(UIButton *)sender
{
   
}

- (void)handleDeleteButtonEvent:(UIButton *)sender
{
    NSString *text = self.phoneTextField.text;
    if (text.length > 0) {
        text = [text substringToIndex:text.length - 1];
        self.phoneTextField.text = text;
        [self handleSpecailButtonWithText:text];
    }
}

@end







