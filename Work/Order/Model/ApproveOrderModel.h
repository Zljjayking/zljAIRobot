//
//  ApproveOrderModel.h
//  Financeteam
//
//  Created by 张正飞 on 16/6/21.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "JSONModel.h"

@interface ApproveOrderModel : JSONModel
@property (strong, nonatomic) NSNumber<Optional>* kid;
@property (nonatomic, copy) NSString<Optional> *icon;
@property (nonatomic, copy) NSString<Optional> *name;
@property (nonatomic, copy) NSString<Optional> *number_id;
@property (nonatomic,copy)  NSString<Optional> *real_name;
@property (strong, nonatomic) NSNumber<Optional>* speed;
@end
