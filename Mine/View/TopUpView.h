//
//  TopUpView.h
//  365ChengRongWang
//
//  Created by 张正飞 on 16/12/21.
//  Copyright © 2016年 Zccf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PopUpView.h"
typedef void (^isPop)();
typedef void (^isSuccess)();
@interface TopUpView : UIView<UITextFieldDelegate>

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic) UITextField *moneyTF;
@property (nonatomic) NSString *money;
@property (nonatomic) NSString *orderNo;
@property (nonatomic) NSString *payInfo;
@property (nonatomic) isPop isPopBlock;
@property (nonatomic) isSuccess isSuccessBlock;
@end
