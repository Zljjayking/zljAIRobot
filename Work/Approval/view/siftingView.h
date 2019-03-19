//
//  siftingView.h
//  Financeteam
//
//  Created by Zccf on 2017/5/11.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatePickerView.h"
#import "siftingOnePickerView.h"
#import "siftingTwoPickerView.h"
#import "DatePickerOneView.h"
typedef void (^hidesiftingViewBlock)();
typedef void (^siftingBlock)(NSMutableDictionary *dic);
@interface siftingView : UIView<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic, strong) UITableView *siftingTbaleView;
@property (nonatomic, strong) UIButton *cleanBtn;
@property (nonatomic, strong) UIButton *siftingBtn;

@property (nonatomic, strong) siftingOnePickerView *siftingOnePicker;
@property (nonatomic, strong) siftingTwoPickerView *siftingTwoPicker;
@property (strong,nonatomic) DatePickerView *datePickerView;//时间选择器
@property (nonatomic, strong) DatePickerOneView *datePickerOne;
@property (nonatomic, strong) DatePickerOneView *datePickerTwo;

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) hidesiftingViewBlock hideBlock;
@property (nonatomic, strong) siftingBlock siftBlock;
@property (nonatomic, strong) NSString *nameStr;
@property (nonatomic, strong) NSString *OneStr;
@property (nonatomic, strong) NSString *application_id;
@property (nonatomic, strong) NSString *TwoStr;
@property (nonatomic, strong) NSString *state_type;
@property (nonatomic, strong) NSString *ThreeStr;
@property (nonatomic, strong) NSString *FourStr;

@property (nonatomic, assign) BOOL isSifting;

@end
