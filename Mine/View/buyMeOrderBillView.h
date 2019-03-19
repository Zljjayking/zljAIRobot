//
//  buyMeOrderBillView.h
//  Financeteam
//
//  Created by Zccf on 2017/8/21.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^buyMeSubmmitBlock) ();
@interface buyMeOrderBillView : UIView
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSDictionary *paramaters;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) UITextField *titleTF;
@property (nonatomic, strong) NSString *titleStr;
@property (nonatomic, strong) UITextField *TaxNumberTF;
@property (nonatomic, strong) NSString *TaxNumber;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, strong) buyMeSubmmitBlock submmitBlock;
- (instancetype)initWithFrame:(CGRect)frame ID:(NSString *)ID type:(NSInteger)type;
@end
