//
//  RSBottomView.m
//  Financeteam
//
//  Created by 张正飞 on 16/8/16.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "RSBottomView.h"

@interface RSBottomView ()

@property(nonatomic,assign)NSInteger lastBtnTag;

@end

@implementation RSBottomView

-(void)setTitleArray:(NSArray *)titleArray{
    
    CGFloat kBtnWidth = kScreenWidth/titleArray.count;
    CGFloat kBtnHeight = self.frame.size.height-8;
    
    for (int i = 0; i < titleArray.count; i++) {
        
        UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(i*kBtnWidth, 0, kBtnWidth, kBtnHeight)];
        btn.backgroundColor = [UIColor clearColor];
        
        
        //未选中图片名字
        NSString *imageName = [NSString stringWithFormat:@"c%d", i + 1];
        [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        
        //选中图片名字
        NSString *seletedName = [NSString stringWithFormat:@"%d", i + 1];
        [btn setImage:[UIImage imageNamed:seletedName] forState:UIControlStateSelected];
        

        btn.tag = 100+i;

        [btn addTarget:self action:@selector(BtnOnClick:) forControlEvents:UIControlEventTouchDown];
        if (i == 0) {
            btn.selected = YES;
            _lastBtnTag = i+100;
        }
        [self addSubview:btn];
        
        NSArray * labelArr =  @[@"拨号",@"电话簿",@"通话记录"];
        
        UILabel * lab = [[UILabel alloc]initWithFrame:CGRectMake(i*kBtnWidth, self.frame.size.height-8, kBtnWidth, 8)];
        lab.text = labelArr[i];
        lab.font = [UIFont systemFontOfSize:8];
        lab.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:lab];
        
        
    }
}

-(void)BtnOnClick:(UIButton *)btn{
    
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
        NSLog(@"没有设置代理或者没有");
    }
    
    
}



@end
