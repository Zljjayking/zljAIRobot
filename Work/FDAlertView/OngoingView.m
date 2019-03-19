//
//  OngoingView.m
//  Financeteam
//
//  Created by 张正飞 on 16/6/24.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "OngoingView.h"
#import "FDAlertView.h"

@interface OngoingView ()<UITextViewDelegate>

@property (nonatomic, copy) ClickBlock clickBlock;
@property (nonatomic, copy) SendBlock sendBlock;

@end

@implementation OngoingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setMainView];
    }
    return self;
}

-(void)setMainView{
    
    self.backgroundColor=[UIColor whiteColor];
    
}

-(void)OngoingViewWithClickBlock:(ClickBlock)clickBlock andSendBlock:(SendBlock)sendBlock{
    
    self.clickBlock = clickBlock;
    self.sendBlock = sendBlock;
    
    UIButton * topBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    topBtn.frame=CGRectMake(5, 5, 150, 30);
    [topBtn setTitle:@"点击左侧重新选择" forState:UIControlStateNormal];
    [topBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    topBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [topBtn setImage:[UIImage imageNamed:@"审批中"] forState:UIControlStateNormal];
    [topBtn addTarget:self action:@selector(ClickedBtn:) forControlEvents:UIControlEventTouchUpInside];
    topBtn.tag = 66;
    [self addSubview:topBtn];
    
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10, 45, 150, 20)];
    label.text = @"审批备注:";
    label.font = [UIFont systemFontOfSize:14];
    [self addSubview:label];
    
    self.textView = [[UITextView alloc]init];
    self.textView.frame = CGRectMake(10, 70, self.bounds.size.width-20, 70);
    self.textView.backgroundColor = [UIColor whiteColor];
    self.textView.returnKeyType = UIReturnKeyDone;
    [self.textView setTintColor:TABBAR_BASE_COLOR];
    self.textView.font = [UIFont systemFontOfSize:14];
    self.textView.delegate = self;
    [self addSubview:self.textView];
    
    UILabel * underlineLabel = [[UILabel alloc]init];
    underlineLabel.frame = CGRectMake(10, 150, self.bounds.size.width-20, 2);
    underlineLabel.backgroundColor = [UIColor blackColor];
    underlineLabel.tag = 77;
    [self addSubview:underlineLabel];
    
    UIButton * cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    cancel.frame=CGRectMake(0, 160, self.bounds.size.width/2, 40);
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    [cancel setTitleColor:TABBAR_BASE_COLOR forState:UIControlStateNormal];
    cancel.titleLabel.font = [UIFont systemFontOfSize:15];
    [cancel addTarget:self action:@selector(ClickedBtn:) forControlEvents:UIControlEventTouchUpInside];
    cancel.tag = 88;
    [self  addSubview:cancel];
    
    UIButton * send = [UIButton buttonWithType:UIButtonTypeCustom];
    send.frame=CGRectMake(self.bounds.size.width/2 , 160, self.bounds.size.width/2, 40);
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

-(void)textViewDidBeginEditing:(UITextView *)textView{
    
    UILabel * lineLabel = [self viewWithTag:77];
    
    lineLabel.backgroundColor = [UIColor redColor];
}


-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

@end
