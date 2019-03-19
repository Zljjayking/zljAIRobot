//
//  productModel.h
//  Financeteam
//
//  Created by Zccf on 16/5/17.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface productModel : NSObject

@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *mechProName;
@property (nonatomic, strong) NSString *mechProType;
@property (nonatomic, strong) NSString *mechProIcon;
@property (nonatomic, strong) NSString *mechanName;
@property (nonatomic, strong) NSString *minDay;
@property (nonatomic, strong) NSString *maxDay;
@property (nonatomic, strong) NSString *minCash;
@property (nonatomic, strong) NSString *maxCash;
@property (nonatomic, strong) NSString *tabInterestRate;
@property (nonatomic, strong) NSString *mechProGoodness;
@property (nonatomic, strong) NSString *costDescription;
@property (nonatomic, strong) NSString *tabCustomerType;
@property (nonatomic, strong) NSString *tabReimburSement;
@property (nonatomic, strong) NSString *appliMaterials;
@property (nonatomic, strong) NSString *appliCondition;
@property (nonatomic, strong) NSString *mechProtext;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *proId;
@property (nonatomic, strong) NSString *cityId;
@property (nonatomic, strong) NSString *areaId;
@property (nonatomic, assign) BOOL isChoice;
@property (nonatomic, strong) NSString *method;//还款方式

@property (nonatomic, strong) NSString *myPushId;//我推送产品标志（有值代表我推送的）
@property (nonatomic, strong) NSString *ptpId;//我接受推送产品的标志（有值人家推送给我的）
@property (nonatomic, strong) NSString *mechId;//产品的机构ID
@property (nonatomic, strong) NSString *bankId;
@property (nonatomic, strong) NSString *publicity_mech_id;
@property (nonatomic, strong) NSString *jrq_mechanism_id;
@property (nonatomic, strong) NSString *mechUserid;
@property (nonatomic, strong) NSString *mechUserIcon;

//推送企业及创始人信息
@property (nonatomic, strong) NSString *ptpMechUserId;
@property (nonatomic, strong) NSString *ptpMechId;
@property (nonatomic, strong) NSString *ptpMechUserIcon;
@end
