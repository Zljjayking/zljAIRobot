//
//  SuccessView.m
//  Financeteam
//
//  Created by 张正飞 on 16/6/24.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "SuccessView.h"
#import "FDAlertView.h"

@interface SuccessView ()<UITextFieldDelegate>

@property (nonatomic, copy) ClickBlock clickBlock;
@property (nonatomic, copy) SendBlock sendBlock;

@end

@implementation SuccessView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
    }
    return self;
}



-(void)SuccessViewWithClickBlock:(ClickBlock)clickBlock andSendBlock:(SendBlock)sendBlock{
    
    self.clickBlock = clickBlock;
    self.sendBlock = sendBlock;
    
    UIButton * topBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    topBtn.frame=CGRectMake(5, 5, 150, 30);
    [topBtn setTitle:@"点击左侧重新选择" forState:UIControlStateNormal];
    [topBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    topBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [topBtn setImage:[UIImage imageNamed:@"审批成功"] forState:UIControlStateNormal];
    [topBtn addTarget:self action:@selector(ClickedBtn:) forControlEvents:UIControlEventTouchUpInside];
    topBtn.tag = 66;
    [self addSubview:topBtn];
    
    UILabel * leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 50, 70, 30)];
    leftLabel.text = @"贷款额度：";
    leftLabel.font = [UIFont systemFontOfSize:13];
    [self addSubview:leftLabel];
    
    self.quotaTextField = [[UITextField alloc]init];
    self.quotaTextField.frame = CGRectMake(80, 50, self.bounds.size.width-130, 30);
    self.quotaTextField.font = [UIFont systemFontOfSize:13];
    self.quotaTextField.borderStyle = UITextBorderStyleNone;
    self.quotaTextField.returnKeyType = UIReturnKeyDone;
    [self.quotaTextField setTintColor:TABBAR_BASE_COLOR];
    
    self.quotaTextField.delegate = self;
    [self addSubview:self.quotaTextField];

    
    UILabel * rightLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.bounds.size.width-40, 50, 40, 30)];
    rightLabel.text = @"万元";
    rightLabel.font = [UIFont systemFontOfSize:13];
    [self addSubview:rightLabel];
    

    UIButton * cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    cancel.frame=CGRectMake(0, 100, self.bounds.size.width/2, 40);
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    [cancel setTitleColor:TABBAR_BASE_COLOR forState:UIControlStateNormal];
    cancel.titleLabel.font = [UIFont systemFontOfSize:15];
    [cancel addTarget:self action:@selector(ClickedBtn:) forControlEvents:UIControlEventTouchUpInside];
    cancel.tag = 88;
    [self  addSubview:cancel];
    
    UIButton * send = [UIButton buttonWithType:UIButtonTypeCustom];
    send.frame=CGRectMake(self.bounds.size.width/2 , 100, self.bounds.size.width/2, 40);
    [send setTitle:@"提交" forState:UIControlStateNormal];
    [send setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    send.titleLabel.font = [UIFont systemFontOfSize:15];
    [send setBackgroundColor:TABBAR_BASE_COLOR];
    [send addTarget:self action:@selector(ClickedBtn:) forControlEvents:UIControlEventTouchUpInside];
    send.tag = 99;
    [self addSubview:send];


}

-(void)ClickedBtn:(UIButton *)sender{
    
    if (sender.tag == 66) {
        
        self.clickBlock();
    }else if (sender.tag == 99){
        
        self.sendBlock();
    }else{
        
    }
    
    
    FDAlertView *alert = (FDAlertView *)self.superview;
    [alert hide];

}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    
    [textField resignFirstResponder];
    
    return YES;
}

@end
