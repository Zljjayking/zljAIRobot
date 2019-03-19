//
//  TopView.m
//  Financeteam
//
//  Created by 张正飞 on 16/6/12.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "TopView.h"


@interface TopView ()

@property(nonatomic,assign)NSInteger lastBtnTag;

@end

@implementation TopView

-(void)setTitleArray:(NSArray *)titleArray{
    
    //按钮的间距和宽度和高度
    CGFloat kBtnSpace = 0;
    CGFloat kBtnWidth = (kScreenWidth-80-kBtnSpace*(titleArray.count))/titleArray.count;
    CGFloat kBtnHeight = self.frame.size.height;
    //循环创建按钮
    for (int i = 0; i < titleArray.count; i++) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(kBtnSpace+ i*(kBtnWidth+kBtnSpace), 0, kBtnWidth, kBtnHeight)];
        btn.backgroundColor = VIEW_BASE_COLOR;
        [btn setTitle:titleArray[i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:18];
        
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        //设置选中状态的文字颜色
        [btn setTitleColor:TABBAR_BASE_COLOR forState:UIControlStateSelected];
        btn.tag = 100+i;
       // btn.titleLabel.adjustsFontSizeToFitWidth = YES;
        [btn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0) {
            btn.selected = YES;
            _lastBtnTag = i+100;
        }
        [self addSubview:btn];
    }
    
}

-(void)onClick:(UIButton *)btn{
    
    //1把上一次选中的按钮的状态selected = NO
    UIButton *lastBtn = [self viewWithTag:_lastBtnTag];
    lastBtn.selected = NO;
    //2把选中的按钮的状态selected = YES
    btn.selected = YES;
    //3更新lastBtnTag的值
    _lastBtnTag = btn.tag;
    
    //调用协议方法
    if (_delegate && [_delegate respondsToSelector:@selector(clickBtn:)] ) {
        [_delegate clickBtn:btn.tag-100];
    }else{
        NSLog(@"没有设置代理或者没有代理没有实现协议方法");
    }

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
