//
//  approvalOrRejectView.h
//  Financeteam
//
//  Created by Zccf on 2017/5/24.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^isPop)();
typedef void (^isSuccess)();
@interface approvalOrRejectView : UIView<UITextViewDelegate>
@property (nonatomic, strong) UIView *bgView;

@property (nonatomic) UITextView *pwdTF;
@property (nonatomic) NSString *pwd;
@property (nonatomic) isPop isPopBlock;
@property (nonatomic) isSuccess isSuccessBlock;

@property (nonatomic) NSString *ID;
@property (nonatomic) NSString *seqID;
@property (nonatomic) NSString *mechID;
@property (nonatomic) NSString *nowUserId;

@property (nonatomic) NSString *title;
@property (nonatomic) UILabel *titleLB;
@property (nonatomic) UILabel *placeHolderLB;
@property (nonatomic) UIButton *approveBtn;
+(id)initWithTitle:(NSString *)title ID:(NSString *)ID seqID:(NSString *)seqID mech_id:(NSString *)mech_id nowUserId:(NSString *)nowUserId frame:(CGRect)frame;
@end
