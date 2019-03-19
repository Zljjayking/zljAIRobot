//
//  CRMSignView.h
//  Financeteam
//
//  Created by Zccf on 2017/10/10.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HStartSelectView.h"
typedef void (^cancelBlock) ();
typedef void (^dataDicBlock) (NSString *userSign);
@interface CRMSignView : UIView
@property (strong, nonatomic) HStartSelectView *selectView;
@property (nonatomic, strong) NSString *customID;
@property (nonatomic, strong) NSString *signCode;
@property (nonatomic, strong) NSString *mech_id;
@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, strong) NSString *dept_id;
@property (nonatomic) cancelBlock cancelblock;
@property (nonatomic) dataDicBlock block;
- (id)initWithFrame:(CGRect)frame signCode:(NSString *)signCode customID:(NSString *)customID;
@end
