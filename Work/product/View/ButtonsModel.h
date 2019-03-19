//
//  ButtonsModel.h
//  Financeteam
//
//  Created by 张正飞 on 16/6/15.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ButtonsModel : NSObject

@property (nonatomic) NSString *name;
@property (nonatomic) NSMutableArray *BtnArr;//按钮的个数和数据
@property (nonatomic) NSInteger type;
@property (nonatomic) NSInteger index;//点击的按钮

@end
