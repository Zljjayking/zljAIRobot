//
//  OrderBottomView.m
//  Financeteam
//
//  Created by 张正飞 on 16/6/20.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "OrderBottomView.h"

@interface OrderBottomView ()

@property(nonatomic,assign)NSInteger lastBtnTag;


@end

@implementation OrderBottomView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.userInteractionEnabled = YES;
        //1.继承
        //2.添加子控件
        [self addBackGroundView];
    
        
    }
    
    return self;
}


-(void)addBackGroundView{
    
    self.backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth/2, 50)];
    self.backgroundView.backgroundColor = TABBAR_BASE_COLOR;
    [self addSubview:self.backgroundView];
    
}

-(void)setTitleArray:(NSArray *)titleArray{
    
    CGFloat kBtnWidth = kScreenWidth/titleArray.count;
    CGFloat kBtnHeight = 50;
    
    for (int i = 0; i < titleArray.count; i++) {
        
        UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(i*kBtnWidth, 0, kBtnWidth, kBtnHeight)];
        btn.backgroundColor = [UIColor clearColor];
        
        [btn setTitle:titleArray[i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:18];
        
        [btn setTitleColor:TABBAR_BASE_COLOR forState:UIControlStateNormal];
        //设置选中状态的文字颜色
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        btn.tag = 100+i;
        // btn.titleLabel.adjustsFontSizeToFitWidth = YES;
        [btn addTarget:self action:@selector(BtnONClick:) forControlEvents:UIControlEventTouchDown];
        if (i == 0) {
            btn.selected = YES;
            _lastBtnTag = i+100;
        }
        [self addSubview:btn];
        
        
    }

}

-(void)BtnONClick:(UIButton *)btn{
    
    //1把上一次选中的按钮的状态selected = NO
    UIButton *lastBtn = [self viewWithTag:_lastBtnTag];
    lastBtn.selected = NO;
    //2把选中的按钮的状态selected = YES
    btn.selected = YES;
    //3更新lastBtnTag的值
    _lastBtnTag = btn.tag;
    
    //调用协议方法
    if (_delegate && [_delegate respondsToSelector:@selector(clickButton:)] ) {
        [_delegate clickButton:btn.tag-100];
    }else{
        NSLog(@"没有设置代理或者没有代理没有实现协议方法");
    }
    

    CGFloat newX = (btn.tag-100) * btn.frame.size.width;
    CGRect rect = btn.frame;
    rect.origin.x = newX;
    //
    [UIView animateWithDuration:0.1 animations:^{
        
        self.backgroundView.frame = rect;
        
    }];
    
}


//更新的按钮的颜色,传按钮的tag值
-(void)resetBtnStatus:(NSInteger )btnTag{
    //1把上一次选中的按钮的状态selected = NO
    UIButton *lastBtn = [self viewWithTag:_lastBtnTag];
    lastBtn.selected = NO;
    //2把传来的按钮的状态selected = YES
    UIButton *selectBtn = [self viewWithTag:btnTag];
    selectBtn.selected = YES;
    //3更新lastBtnTag的值
    _lastBtnTag = btnTag;
}
@end
