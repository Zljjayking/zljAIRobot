//
//  MyOrderModel.h
//  Financeteam
//
//  Created by 张正飞 on 16/6/20.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "JSONModel.h"

@interface MyOrderModel : JSONModel

@property (strong, nonatomic) NSNumber<Optional>* kid;
@property (nonatomic, copy) NSString<Optional> *icon;
@property (nonatomic, copy) NSString<Optional> *name;
@property (nonatomic, copy) NSString<Optional> *number_id;
@property (nonatomic,copy)  NSString<Optional> *real_name;
@property (strong, nonatomic) NSNumber<Optional>* speed;

@property (nonatomic, copy) NSString<Optional> *myPushId;//我推送的
@property (nonatomic, copy) NSString<Optional> *ptpId;//我接受的
@property (nonatomic, copy) NSString<Optional> *failureCause;

@property (nonatomic, copy) NSString<Optional> *orderId;
@property (nonatomic, copy) NSString<Optional> *orderType;
@property (nonatomic, copy) NSString<Optional> *proName;
@property (nonatomic, copy) NSString<Optional> *userName;
@property (nonatomic, copy) NSString<Optional> *yncrw;

@property (nonatomic, copy) NSString<Optional> *proId;
@property (nonatomic, copy) NSString<Optional> *delId;
@property (nonatomic, copy) NSString<Optional> *bankId;
@property (nonatomic, copy) NSString<Optional> *create_time;
@property (nonatomic, copy) NSString<Optional> *examineInfo;
@property (nonatomic, copy) NSString<Optional> *failurecause;
@property (nonatomic, copy) NSString<Optional> *finish_time;
@property (nonatomic, copy) NSString<Optional> *isPay;
@property (nonatomic, copy) NSString<Optional> *payMoney;
@property (nonatomic, copy) NSString<Optional> *quota;
@property (nonatomic, copy) NSString<Optional> *jrq_mechanism_id;
@property (nonatomic, copy) NSString<Optional> *publicity_mech_id;

//推送企业及创始人信息
@property (nonatomic, copy) NSString<Optional> *ptpMechUserId;
@property (nonatomic, copy) NSString<Optional> *ptpMechId;
@property (nonatomic, copy) NSString<Optional> *ptpMechUserIcon;
@property (nonatomic, copy) NSString<Optional> *mechanism_other_id;

/**
 "proId": 124,//订单id
 "delId": null,//删除id
 "bankId": 7,
 "create_time": 1488953025000,
 "examineInfo": null,
 "failurecause": null,
 "finish_time": null,
 "icon": "err",
 "id": 1005,
 "isPay": null,
 "myPushId": null,////我推送产品标志（有值代表我推送的）
 "name": "1",
 "number_id": "20170308140345340000",
 "payMoney": "",
 "ptpId": null,////我接受推送产品的标志（有值人家推送给我的）
 "quota": null,
 "real_name": "翟良杰",
 "speed": 1
 */
@end
