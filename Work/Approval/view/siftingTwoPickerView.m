//
//  siftingOnePickerView.m
//  Financeteam
//
//  Created by Zccf on 2017/5/11.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import "siftingTwoPickerView.h"

@implementation siftingTwoPickerView
//- (UIPickerView *)siftingTwoPicker {
//    if (!_siftingTwoPicker) {
//        
//    }
//    return _siftingTwoPicker;
//}
-(siftingTwoPickerView *)initWithCustomeHeight:(CGFloat)height{
    
    self = [super initWithFrame:CGRectMake(0, 0, kScreenWidth, height=height<200?200:height)];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.layer.borderWidth = 1;
        self.layer.borderColor = [UIColor colorWithWhite:0 alpha:0.05].CGColor;
        
        //创建取消 确定按钮
        UIButton *cannel = [UIButton buttonWithType:UIButtonTypeCustom];
        cannel.frame = CGRectMake(20, 0, 50, 40);
        [cannel setTitle:@"取消" forState:0];
        [cannel setTitleColor:MYORANGE forState:0];
        cannel.tag = 1;
        [cannel addTarget:self action:@selector(cannelOrConfirm:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cannel];
        
        
        UIButton *confirm = [UIButton buttonWithType:UIButtonTypeCustom];
        confirm.frame = CGRectMake(kScreenWidth-70, 0, 50, 40);
        [confirm setTitle:@"确定" forState:0];
        [confirm setTitleColor:MYORANGE forState:0];
        confirm.tag = 2;
        [confirm addTarget:self action:@selector(cannelOrConfirm:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:confirm];
        
        self.siftingTwoPicker = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 40, kScreenWidth, 210)];
        self.siftingTwoPicker.backgroundColor = [UIColor groupTableViewBackgroundColor];
        self.siftingTwoPicker.delegate = self;
        self.siftingTwoPicker.dataSource = self;
        self.siftingTwoPicker.showsSelectionIndicator = YES;
        
        [self addSubview:self.siftingTwoPicker];
        
        _siftingTwoArr = @[@"全部",@"未提交",@"撤回",@"审批中",@"驳回",@"审批通过"];
        
    }
    return self;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    return _siftingTwoArr.count;
}

#pragma Mark -- UIPickerViewDelegate
// 每列宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    
    return kScreenWidth;
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    
    return 40;
}

//返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    return [_siftingTwoArr objectAtIndex:row];
    
}

// 返回选中的行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    _siftingTwoName = [_siftingTwoArr objectAtIndex:row];
    
}


-(void)cannelOrConfirm:(UIButton *)sender{
    
    if(sender.tag == 2){
        if ([Utils isBlankString:_siftingTwoName]) {
            self.confirmTwoBlock(@"全部");
        } else {
            self.confirmTwoBlock(_siftingTwoName);
        }
    } else {
        self.cannelTwoBlock();
    }
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
