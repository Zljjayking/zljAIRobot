//
//  BottomView.m
//  Financeteam
//
//  Created by 张正飞 on 16/6/12.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "BottomView.h"

@interface BottomView ()

@property(nonatomic,assign)NSInteger lastBtnTag;
@property(nonatomic,strong)UIView * backgroundView;

@end

@implementation BottomView

static NSInteger step = 0;


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
    
    self.backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth/2, self.frame.size.width)];
    self.backgroundView.backgroundColor = TABBAR_BASE_COLOR;
    [self addSubview:self.backgroundView];
    
}

-(void)setTitleArray:(NSArray *)titleArray{
    
    CGFloat kBtnWidth = kScreenWidth/titleArray.count;
    CGFloat kBtnHeight = self.frame.size.height;
    
    for (int i = 0; i < titleArray.count; i++) {
        
        UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(i*kBtnWidth, 0, kBtnWidth, kBtnHeight)];
        btn.backgroundColor = [UIColor clearColor];
        
        [btn setTitle:titleArray[i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:18];
        
        [btn setTitleColor:TABBAR_BASE_COLOR forState:UIControlStateNormal];
        //设置选中状态的文字颜色
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        
         btn.tag = 100+i;
        
        [btn addTarget:self action:@selector(BtnonClick:) forControlEvents:UIControlEventTouchDown];
        if (i == 0) {
            btn.selected = YES;
            _lastBtnTag = i+100;
        }
        [self addSubview:btn];
        
    }


}

-(void)BtnonClick:(UIButton * )button{
    
    UIButton * lastBtn = [self viewWithTag:_lastBtnTag];
    lastBtn.selected = NO;
    
    button.selected = YES;
    
    _lastBtnTag = button.tag;
    
    
    if (button.tag == 101) {
        
        step++;
    
        
        if (step > 5) {

           int num =5;
           step = num;
        
            
            JKAlertView * firstAlertView = [[JKAlertView alloc]initWithTitle:@"已经是最后一步了" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [firstAlertView show];
        }
        else  {
            if (_delegate && [_delegate respondsToSelector:@selector(clickButton:)] ) {
                [_delegate clickButton:step];
            }else{
                NSLog(@"没有设置代理或者没有代理没有实现协议方法");
            }

        }
        CGFloat newX = (button.tag-100) * button.frame.size.width;
        CGRect rect = button.frame;
        rect.origin.x = newX;
//        
        [UIView animateWithDuration:0.1 animations:^{
            
            self.backgroundView.frame = rect;
           
       }];
       
    }else if (button.tag == 100){
        
        step--;
    
        if (step < 0 ) {
            int num = 0;
            step = num;
            
            JKAlertView * firstAlertView = [[JKAlertView alloc]initWithTitle:@"已经是第一步了" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [firstAlertView show];
            
        } else  {
            if (_delegate && [_delegate respondsToSelector:@selector(clickButton:)] ) {
                [_delegate clickButton:step];
            }else{
                NSLog(@"没有设置代理或者没有代理没有实现协议方法");
            }
            
        }
        
        
       CGFloat newX = (button.tag-100) * button.frame.size.width;
       CGRect rect = button.frame;
       rect.origin.x = newX;
       
       [UIView animateWithDuration:0.1 animations:^{
           
            self.backgroundView.frame = rect;
           
        }];
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
