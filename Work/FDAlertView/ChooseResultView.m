//
//  ChooseResultView.m
//  Financeteam
//
//  Created by 张正飞 on 16/6/24.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "ChooseResultView.h"
#import "FDAlertView.h"
#import "ChooseButton.h"

@interface ChooseResultView ()

@property (nonatomic, copy) OngoingBlock ongoingBlock;
@property (nonatomic, copy) SuccessBlock successBlock;
@property (nonatomic, copy) FailureBlock failureBlock;

@property (nonatomic, copy) SendBlock sendBlock;

@property (nonatomic,strong) ChooseButton * chooseBtn;

@end


@implementation ChooseResultView

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

-(void)ChooseResultViewWithOngoingBlock:(OngoingBlock)ongoingBlock SuccessBlock:(SuccessBlock)successBlock FailureBlock:(FailureBlock)failureBlock andSendBlock:(SendBlock)sendBlock{
    
    self.ongoingBlock = ongoingBlock;
    self.successBlock = successBlock;
    self.failureBlock = failureBlock;
    
    self.sendBlock = sendBlock;
    
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, self.bounds.size.width, 20)];
    titleLabel.text = @"请选择审批结果";
    titleLabel.font = [UIFont systemFontOfSize:13];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:titleLabel];
    
    NSArray *imageArr = [NSArray arrayWithObjects:@"审批中",@"审批成功",@"审批失败", nil];
    NSArray *titleArr = [NSArray arrayWithObjects:@"审批中",@"审批成功",@"审批失败", nil];
    
    CGFloat btnX = self.bounds.size.width/2-15;
    CGFloat btnW = 30;
    CGFloat btnH = 50;
    
    for (int i = 0; i< imageArr.count; i++) {
        
        CGFloat btnY = 40+(btnH+20)*i;
        
        _chooseBtn = [[ChooseButton alloc]init];
        _chooseBtn.frame = CGRectMake(btnX, btnY, btnW, btnH);
        _chooseBtn.enabled = YES;
        _chooseBtn.showsTouchWhenHighlighted = YES;
        [_chooseBtn setHighlighted:YES];
        [self addSubview:_chooseBtn];
        
        _chooseBtn.btnImage.image = [UIImage imageNamed:imageArr[i]];
        _chooseBtn.label.text = titleArr[i];
        
        _chooseBtn.tag = i;
        [_chooseBtn addTarget:self action:@selector(ClickedOnBtn:) forControlEvents:UIControlEventTouchUpInside];
       
    }
    
    UILabel * lineOne = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, self.bounds.size.width, 1)];
    lineOne.backgroundColor = VIEW_BASE_COLOR;
    [self addSubview:lineOne];
    
    UILabel * lineTwo = [[UILabel alloc]initWithFrame:CGRectMake(0, 170, self.bounds.size.width, 1)];
    lineTwo.backgroundColor = VIEW_BASE_COLOR;
    [self addSubview:lineTwo];

    UIButton * cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    cancel.frame=CGRectMake(0, 240, self.bounds.size.width/2, 40);
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    [cancel setTitleColor:TABBAR_BASE_COLOR forState:UIControlStateNormal];
    cancel.titleLabel.font = [UIFont systemFontOfSize:15];
    [cancel addTarget:self action:@selector(ClickedOnBtn:) forControlEvents:UIControlEventTouchUpInside];
    cancel.tag = 3;
    [self  addSubview:cancel];
    
    UIButton * send = [UIButton buttonWithType:UIButtonTypeCustom];
    send.frame=CGRectMake(self.bounds.size.width/2 , 240, self.bounds.size.width/2, 40);
    [send setTitle:@"提交" forState:UIControlStateNormal];
    [send setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    send.titleLabel.font = [UIFont systemFontOfSize:15];
    [send setBackgroundColor:TABBAR_BASE_COLOR];
    [send addTarget:self action:@selector(ClickedOnBtn:) forControlEvents:UIControlEventTouchUpInside];
    send.tag = 4;
    [self addSubview:send];
    

}

-(void)ClickedOnBtn:(UIButton *)sender{
    
    if (sender.tag == 0) {
        self.ongoingBlock();
        FDAlertView *alert = (FDAlertView *)self.superview;
        [alert hide];
    }else if (sender.tag == 1){
        self.successBlock();
        FDAlertView *alert = (FDAlertView *)self.superview;
        [alert hide];
    }else if (sender.tag == 2){
        self.failureBlock();
        FDAlertView *alert = (FDAlertView *)self.superview;
        [alert hide];
    }else if (sender.tag == 4){
        self.sendBlock();
    }else{
        FDAlertView *alert = (FDAlertView *)self.superview;
        [alert hide];
    }
  

}

@end
