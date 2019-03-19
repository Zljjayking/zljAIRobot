//
//  buyMeView.h
//  Financeteam
//
//  Created by Zccf on 2017/8/8.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol buyMeDelegate 

- (void)clickToPayAndReturnTheResualt:(id)resualt;

@end
@interface buyMeView : UIView
@property (nonatomic, weak) id<buyMeDelegate>delegate;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) NSString *money;
@property (nonatomic, strong) NSString *orderNo;
@property (nonatomic, strong) NSString *payInfo;
@property (nonatomic, strong) UIButton *addressBtn;
@property (nonatomic, strong) UITextField *addressTF;
@property (nonatomic, strong) NSString *addressStr;
@property (nonatomic, strong) UITextField *postcodeTF;
@property (nonatomic, strong) UITextView *postcodeTV;
@property (nonatomic, strong) NSString *postcodeStr;
@property (nonatomic, strong) UITextField *receiverTF;
@property (nonatomic, strong) NSString *receiverStr;
@property (nonatomic, strong) UITextField *receiverMobileTF;
@property (nonatomic, strong) NSString *receiverMobileStr;
@property (nonatomic, strong) NSDictionary *paramaters;
@property (nonatomic, assign) BOOL isMechine;

@property (nonatomic, strong) NSString *proId;
@property (nonatomic, strong) NSString *cityId;
@property (nonatomic, strong) NSString *areaId;

@property (nonatomic, strong) NSMutableDictionary *mutableParamaters;
- (instancetype)initWithFrame:(CGRect)frame paramaters:(NSDictionary *)paramaters money:(NSString *)money mechineCount:(NSInteger)mechineCount;
@end
