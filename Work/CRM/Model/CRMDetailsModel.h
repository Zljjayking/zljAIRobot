//
//  CRMDetailsModel.h
//  Financeteam
//
//  Created by Zccf on 16/6/7.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CRMDetailsModel : NSObject

@property (nonatomic) NSString *person_colleague_company;
@property (nonatomic) NSString *person_family_company;
@property (nonatomic) NSString *user_house_type;
@property (nonatomic) NSString *nowaddress;
@property (nonatomic) NSString *jrq_table_personal_info_id;
@property (nonatomic) NSString *asset_car_month;
@property (nonatomic) NSString *person_company_address;
@property (nonatomic) NSString *jrq_table_asset_info_id;
@property (nonatomic) NSString *cpfMoney;
@property (nonatomic) NSString *work_part;
@property (nonatomic) NSString *hkaddress;
@property (nonatomic) NSString *work_money;
@property (nonatomic) NSString *asset_house_price;
@property (nonatomic) NSString *work_money_type;
@property (nonatomic) NSString *person_other_ship;
@property (nonatomic) NSString *work_industry;
@property (nonatomic) NSString *special_company_number;
@property (nonatomic) NSString *issb;
@property (nonatomic) NSString *asset_house_pro_id;
@property (nonatomic) NSString *work_job;
@property (nonatomic) NSString *person_colleague_moblie;
@property (nonatomic) NSString *special_company_area;
@property (nonatomic) NSString *special_company_type;
@property (nonatomic) NSString *user_name;
@property (nonatomic) NSString *asset_house_year;
@property (nonatomic) NSString *special_company_date;
@property (nonatomic) NSString *asset_house_type;
@property (nonatomic) NSString *real_name;
@property (nonatomic) NSString *asset_house_area_id;
@property (nonatomic) NSString *asset_house_month;
@property (nonatomic) NSString *Id;
@property (nonatomic) NSString *jrq_table_special_info_id;
@property (nonatomic) NSString *work_name;
@property (nonatomic) NSString *person_family_ship;
@property (nonatomic) NSString *work_date;
@property (nonatomic) NSString *person_together;
@property (nonatomic) NSString *person_family_moblie;
@property (nonatomic) NSString *user_marry;
@property (nonatomic) NSString *person_mobile;
@property (nonatomic) NSString *user_id_number;
@property (nonatomic) NSString *asset_house_area;
@property (nonatomic) NSString *state;
@property (nonatomic) NSString *work_money_date;
@property (nonatomic) NSString *asset_house;
@property (nonatomic) NSString *isgrbx;
@property (nonatomic) NSString *person_other_name;
@property (nonatomic) NSString *purpose;
@property (nonatomic) NSString *work_tel;
@property (nonatomic) NSString *asset_car;
@property (nonatomic) NSString *user_education;
@property (nonatomic) NSString *jrq_table_work_info_id;
@property (nonatomic) NSString *person_id_card;
@property (nonatomic) NSString *special_company_type_other;
@property (nonatomic) NSString *user_id_type;
@property (nonatomic) NSString *person_dear;
@property (nonatomic) NSString *user_mobile;
@property (nonatomic) NSString *money;
@property (nonatomic) NSString *isbs;
@property (nonatomic) NSString *asset_house_city_id;
@property (nonatomic) NSString *work_address_pro_id;
@property (nonatomic) NSString *person_colleague_name;
@property (nonatomic) NSString *person_company_tel;
@property (nonatomic) NSString *user_tel;
@property (nonatomic) NSString *asset_car_date;
@property (nonatomic) NSString *person_other_company;
@property (nonatomic) NSString *asset_house_money;
@property (nonatomic) NSString *work_type;
@property (nonatomic) NSString *person_together_name;
@property (nonatomic) NSString *person_know;
@property (nonatomic) NSString *work_address_city_id;
@property (nonatomic) NSString *adviserId;
@property (nonatomic) NSString *special_net_profit;
@property (nonatomic) NSString *user_child;
@property (nonatomic) NSString *asset_car_price;
@property (nonatomic) NSString *adviserPlan;
@property (nonatomic) NSString *user_house_money;
@property (nonatomic) NSString *work_address_area_id;
@property (nonatomic) NSString *asset_house_type_other;
@property (nonatomic) NSString *work_address;
@property (nonatomic) NSString *source;
@property (nonatomic) NSString *createPsId;
@property (nonatomic) NSString *person_company_name;
@property (nonatomic) NSString *person_other_moblie;
@property (nonatomic) NSString *asset_house_property;
@property (nonatomic) NSString *iscpf;
@property (nonatomic) NSString *user_sex;
@property (nonatomic) NSString *person_address;
@property (nonatomic) NSString *person_colleague_work;
@property (nonatomic) NSString *person_family_name;
@property (nonatomic) NSString *asset_house_date;
@property (nonatomic) NSString *mechProId;
@property (nonatomic) NSString *remark;
@property (nonatomic) NSString *icon;
@property (nonatomic) NSString *userSign;
/*
 客户的图片材料
 "photoIdFront": "/idcardfront/icf1460618290339_min.jpg",
 "photoIdBack": "/idcardfback/icb1460618296614_min.jpg",
 "photoRegist": "/hhr/hhr1460618300686_min.jpg",
 "photoRegist2": "/hhr/hhr1460618432222_min.png",
 "photoRegist3": "/hhr/hhr1460618432252_min.png",
 "photoHouse": "/houseInfo/hif1460618432280_min.png",
 "photoHouse2": "/houseInfo/hif1460618432310_min.png",
 "photoHouse3": "/houseInfo/hif1460618469186_min.png",
 "photoMarry": "/marryInfo/mif1460618469220_min.png",
 "photoMarry2": "/marryInfo/mif1460618469252_min.png",
 "photoMarry3": "/marryInfo/mif1460618469283_min.png",
 "photoWork": "/workInfo/wkf1460618469314_min.png",
 "photoWork2": "/workInfo/wkf1460618469344_min.png",
 "photoWork3": "/workInfo/wkf1460618469406_min.png",
 "photoWages": "/moneyInfo/myf1460618305210_min.jpg",
 "photoWages2": "/moneyInfo/myf1460618313391_min.jpg",
 "photoWages3": "/moneyInfo/myf1460618678907_min.png",
 "photoOther": "/otherInfo/oif1460618679074_min.png",
 "photoOther2": "/otherInfo/oif1460618679102_min.png",
 "photoOther3": "/otherInfo/oif1460618679130_min.png",
 "photoCredit": "/creditInfo/cdt1460618678935_min.png",
 "photoCredit2": "/creditInfo/cdt1460618678963_min.png",
 "photoCredit3": "/creditInfo/cdt1460618678991_min.png",
 "photoCredit4": "/creditInfo/cdt1460618679018_min.png",
 "photoCredit5": "/creditInfo/cdt1460618679046_min.png",
 */
@property (nonatomic) NSString *photoIdFront;
@property (nonatomic) NSString *photoIdBack;
@property (nonatomic) NSString *photoRegist;
@property (nonatomic) NSString *photoRegist2;
@property (nonatomic) NSString *photoRegist3;

@property (nonatomic) NSString *photoHouse;
@property (nonatomic) NSString *photoHouse2;
@property (nonatomic) NSString *photoHouse3;
@property (nonatomic) NSString *photoMarry;
@property (nonatomic) NSString *photoMarry2;

@property (nonatomic) NSString *photoMarry3;
@property (nonatomic) NSString *photoWork;
@property (nonatomic) NSString *photoWork2;
@property (nonatomic) NSString *photoWork3;
@property (nonatomic) NSString *photoWages;

@property (nonatomic) NSString *photoWages2;
@property (nonatomic) NSString *photoWages3;
@property (nonatomic) NSString *photoOther;
@property (nonatomic) NSString *photoOther2;
@property (nonatomic) NSString *photoOther3;

@property (nonatomic) NSString *photoCredit;
@property (nonatomic) NSString *photoCredit2;
@property (nonatomic) NSString *photoCredit3;
@property (nonatomic) NSString *photoCredit4;
@property (nonatomic) NSString *photoCredit5;
@property (nonatomic) NSString *photoCredit6;
@property (nonatomic) NSString *photoCredit7;
@property (nonatomic) NSString *photoCredit8;
@property (nonatomic) NSString *photoCredit9;
@property (nonatomic) NSString *photoCredit10;

#pragma mark == 新加公积金范围
@property (nonatomic) NSString *cpfRange;
#pragma mark == 新加房产总价范围
@property (nonatomic) NSString *asset_house_totalPrice;
#pragma mark == 新加房产总价
@property (nonatomic) NSString *asset_house_totalval;//asset_house_totalPrice为4时填写
#pragma mark == 新加房产月供范围
@property (nonatomic) NSString *asset_house_monRange;//asset_house_dateRange
#pragma mark == 新加购房日期范围
@property (nonatomic) NSString *asset_house_dateRange;

#pragma mark == 新加车辆总价范围
@property (nonatomic) NSString *asset_car_totalRange;
#pragma mark == 新加购车形式
@property (nonatomic) NSString *asset_car_type;//asset_house_totalPrice为4时填写
#pragma mark == 新加车辆月供范围
@property (nonatomic) NSString *asset_car_monRange;//asset_house_dateRange
#pragma mark == 新加购房日期范围
@property (nonatomic) NSString *asset_car_dateRange;

#pragma mark == 新加职业类型
@property (nonatomic) NSString *occ_type;
#pragma mark == 新增个人保险缴纳年限范围
@property (nonatomic) NSString *grbx_term_range;
#pragma mark == 新增个人保险缴纳金额
@property (nonatomic) NSString *grbx_sum;

@property (nonatomic, strong) NSString *audio_url;
@property (nonatomic, strong) NSString *tepl_url;
+(id)requestWithDic:(NSDictionary*)dic;

@end
