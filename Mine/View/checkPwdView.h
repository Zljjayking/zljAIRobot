//
//  checkPwdView.h
//  Financeteam
//
//  Created by Zccf on 17/4/14.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^isPop)();
typedef void (^isSuccess)();
@interface checkPwdView : UIView<UITextFieldDelegate>
@property (nonatomic, strong) UIView *bgView;

@property (nonatomic) UITextField *pwdTF;
@property (nonatomic) NSString *pwd;
@property (nonatomic) isPop isPopBlock;
@property (nonatomic) isSuccess isSuccessBlock;
@end
