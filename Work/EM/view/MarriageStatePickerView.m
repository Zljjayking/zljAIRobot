//
//  MarriageStatePickerView.m
//  365ChengRongWang
//
//  Created by Zccf on 17/1/6.
//  Copyright © 2017年 Zccf. All rights reserved.
//

#import "MarriageStatePickerView.h"

@implementation MarriageStatePickerView
-(MarriageStatePickerView *)initWithCustomeHeight:(CGFloat)height{
    
    self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, height=height<200?200:height)];
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
        confirm.frame = CGRectMake(SCREEN_WIDTH-70, 0, 50, 40);
        [confirm setTitle:@"确定" forState:0];
        [confirm setTitleColor:MYORANGE forState:0];
        confirm.tag = 2;
        [confirm addTarget:self action:@selector(cannelOrConfirm:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:confirm];
        
        
        _MarriageStatePicker = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, height-40)];
        _MarriageStatePicker.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _MarriageStatePicker.delegate = self;
        _MarriageStatePicker.dataSource = self;
        _MarriageStatePicker.showsSelectionIndicator = YES;
        [self addSubview:_MarriageStatePicker];
        
        _MarriageStateArr = [[NSArray alloc]initWithObjects:@"已婚",@"未婚",nil];
        
    }
    return self;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    return _MarriageStateArr.count;
}

#pragma Mark -- UIPickerViewDelegate
// 每列宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    
    return SCREEN_WIDTH;
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    
    return 40;
}

//返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    return [_MarriageStateArr objectAtIndex:row];
    
}

// 返回选中的行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    _MarriageStateName = [_MarriageStateArr objectAtIndex:row];
    
}


-(void)cannelOrConfirm:(UIButton *)sender{
    
    if(sender.tag == 2){
        if ([Utils isBlankString:_MarriageStateName]) {
            self.confirmBlock(@"已婚");
        } else {
            self.confirmBlock(_MarriageStateName);
        }
    }
    self.cannelBlock();
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
