//
//  ContentView.m
//  Financeteam
//
//  Created by 张正飞 on 16/6/23.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "ContentView.h"
#import "FDAlertView.h"

@interface ContentView ()

@property (nonatomic, copy) MyBlock block;

@end

@implementation ContentView

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

-(void)ContentViewWithMessage:(NSAttributedString *)message andBlock:(MyBlock)block{
    
    self.block = block;
    
    UILabel * messageLabel = [[UILabel alloc]init];
   
    messageLabel.frame = CGRectMake(0, 20, kScreenWidth-50, 50);
    messageLabel.attributedText = message;
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.font = [UIFont systemFontOfSize:17];
    [self addSubview:messageLabel];

    UIButton * cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    [cancel setTitleColor:TABBAR_BASE_COLOR forState:UIControlStateNormal];
    cancel.titleLabel.font = [UIFont systemFontOfSize:15];
    [cancel addTarget:self action:@selector(shbClickedBtn:) forControlEvents:UIControlEventTouchUpInside];
    cancel.tag = 100;
    [self  addSubview:cancel];
    [cancel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.equalTo(self.mas_centerX).offset(-20);
        make.top.equalTo(messageLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(100);
        
    }];
    
    UIButton * send = [UIButton buttonWithType:UIButtonTypeCustom];
    [send setTitle:@"确定" forState:UIControlStateNormal];
    [send setTitleColor:TABBAR_BASE_COLOR forState:UIControlStateNormal];
    send.titleLabel.font = [UIFont systemFontOfSize:15];
    [send addTarget:self action:@selector(shbClickedBtn:) forControlEvents:UIControlEventTouchUpInside];
    send.tag = 200;
    [self addSubview:send];
    [send mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.mas_centerX).offset(20);
        make.top.equalTo(messageLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(100);
        
    }];


}

- (void)shbClickedBtn:(UIButton *)btn {
    
    if (btn.tag == 100)
    {
        
    } else
    {
        
        self.block();
        
    }
    
    FDAlertView *alert = (FDAlertView *)self.superview;
    [alert hide];
}


@end
