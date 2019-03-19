//
//  CRMDetailsModel.m
//  Financeteam
//
//  Created by Zccf on 16/6/7.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "CRMDetailsModel.h"
/*
 "person_colleague_company": null,
 "person_family_company": null,
 "user_house_type": null,
 "nowaddress": null,
 "jrq_table_personal_info_id": null,
 "asset_car_month": null,
 "person_company_address": null,
 "jrq_table_asset_info_id": null,
 "cpfMoney": null,
 "work_part": null,
 "hkaddress": null,
 "work_money": null,
 "asset_house_price": null,
 "work_money_type": null,
 "person_other_ship": null,
 "work_industry": null,
 "special_company_number": null,
 "issb": null,
 "asset_house_pro_id": null,
 "work_job": null,
 "person_colleague_moblie": null,
 "special_company_area": null,
 "special_company_type": null,
 "user_name": "哈喽",
 "asset_house_year": null,
 "special_company_date": null,
 "asset_house_type": null,
 "real_name": "薛永宽",
 "asset_house_area_id": null,
 "asset_house_month": null,
 "Id": 16,
 "jrq_table_special_info_id": null,
 "work_name": null,
 "person_family_ship": null,
 "work_date": null,
 "person_together": null,
 "person_family_moblie": null,
 "user_marry": null,
 "person_mobile": null,
 "user_id_number": "42588",
 "asset_house_area": null,
 "state": "4",
 "work_money_date": null,
 "asset_house": null,
 "isgrbx": null,
 "person_other_name": null,
 "purpose": null,
 "work_tel": null,
 "asset_car": null,
 "user_education": null,
 "jrq_table_work_info_id": null,
 "person_id_card": null,
 "special_company_type_other": null,
 "user_id_type": "1",
 "person_dear": null,
 "user_mobile": "9666",
 "money": null,
 "isbs": null,
 "asset_house_city_id": null,
 "work_address_pro_id": null,
 "person_colleague_name": null,
 "person_company_tel": null,
 "user_tel": null,
 "asset_car_date": null,
 "person_other_company": null,
 "asset_house_money": null,
 "work_type": null,
 "person_together_name": null,
 "person_know": null,
 "work_address_city_id": null,
 "adviserId": 4,
 "special_net_profit": null,
 "user_child": null,
 "asset_car_price": null,
 "adviserPlan": null,
 "user_house_money": null,
 "work_address_area_id": null,
 "asset_house_type_other": null,
 "work_address": null,
 "source": null,
 "createPsId": 2,
 "person_company_name": null,
 "person_other_moblie": null,
 "asset_house_property": null,
 "iscpf": null,
 "user_sex": "2",
 "person_address": null,
 "person_colleague_work": null,
 "person_family_name": null,
 "asset_house_date": null
 
 */
@implementation CRMDetailsModel
-(id)initWithDic:(NSDictionary*)dic
{
    if (self = [super init])
    {
        
        self.userSign = [NSString stringWithFormat:@"%@",dic[@"userSign"]];
        self.person_colleague_company = [NSString stringWithFormat:@"%@",dic[@"person_colleague_company"]];
        self.person_family_company = [NSString stringWithFormat:@"%@",dic[@"person_family_company"]];
        self.user_house_type = [NSString stringWithFormat:@"%@",dic[@"user_house_type"]];
        self.nowaddress = [NSString stringWithFormat:@"%@",dic[@"nowaddress"]];
        self.jrq_table_personal_info_id = [NSString stringWithFormat:@"%@",dic[@"jrq_table_personal_info_id"]];
        self.asset_car_month = [NSString stringWithFormat:@"%@",dic[@"asset_car_month"]];
        self.person_company_address = [NSString stringWithFormat:@"%@",dic[@"person_company_address"]];
        self.jrq_table_asset_info_id = [NSString stringWithFormat:@"%@",dic[@"jrq_table_asset_info_id"]];
        self.cpfMoney = [NSString stringWithFormat:@"%@",dic[@"cpfMoney"]];
        self.work_part = [NSString stringWithFormat:@"%@",dic[@"work_part"]];
        self.hkaddress = [NSString stringWithFormat:@"%@",dic[@"hkaddress"]];
        self.work_money = [NSString stringWithFormat:@"%@",dic[@"work_money"]];
        self.work_money_type = [NSString stringWithFormat:@"%@",dic[@"work_money_type"]];
        self.asset_house_price = [NSString stringWithFormat:@"%@",dic[@"asset_house_price"]];
        self.person_other_ship = [NSString stringWithFormat:@"%@",dic[@"person_other_ship"]];
        self.work_industry = [NSString stringWithFormat:@"%@",dic[@"work_industry"]];
        self.special_company_number = [NSString stringWithFormat:@"%@",dic[@"special_company_number"]];
        self.issb = [NSString stringWithFormat:@"%@",dic[@"issb"]];
        self.asset_house_pro_id = [NSString stringWithFormat:@"%@",dic[@"asset_house_pro_id"]];
        self.work_job = [NSString stringWithFormat:@"%@",dic[@"work_job"]];
        self.person_colleague_moblie = [NSString stringWithFormat:@"%@",dic[@"person_colleague_moblie"]];
        self.special_company_area = [NSString stringWithFormat:@"%@",dic[@"special_company_area"]];
        self.special_company_type = [NSString stringWithFormat:@"%@",dic[@"special_company_type"]];
        self.user_name = [NSString stringWithFormat:@"%@",dic[@"user_name"]];
        self.asset_house_year = [NSString stringWithFormat:@"%@",dic[@"asset_house_year"]];
        self.special_company_date = [NSString stringWithFormat:@"%@",dic[@"special_company_date"]];
        self.asset_house_type = [NSString stringWithFormat:@"%@",dic[@"asset_house_type"]];
        self.real_name = [NSString stringWithFormat:@"%@",dic[@"real_name"]];
        self.asset_house_area_id = [NSString stringWithFormat:@"%@",dic[@"asset_house_area_id"]];
        self.asset_house_month = [NSString stringWithFormat:@"%@",dic[@"asset_house_month"]];
        self.Id = [NSString stringWithFormat:@"%@",dic[@"Id"]];
        self.jrq_table_special_info_id = [NSString stringWithFormat:@"%@",dic[@"jrq_table_special_info_id"]];
        self.work_name = [NSString stringWithFormat:@"%@",dic[@"work_name"]];
        self.person_family_ship = [NSString stringWithFormat:@"%@",dic[@"person_family_ship"]];
        self.work_date = [NSString stringWithFormat:@"%@",dic[@"work_date"]];
        self.person_together = [NSString stringWithFormat:@"%@",dic[@"person_together"]];
        self.person_family_moblie = [NSString stringWithFormat:@"%@",dic[@"person_family_moblie"]];
        self.user_marry = [NSString stringWithFormat:@"%@",dic[@"user_marry"]];
        self.person_mobile = [NSString stringWithFormat:@"%@",dic[@"person_mobile"]];
        self.user_id_number = [NSString stringWithFormat:@"%@",dic[@"user_id_number"]];
        self.asset_house_area = [NSString stringWithFormat:@"%@",dic[@"asset_house_area"]];
        self.state = [NSString stringWithFormat:@"%@",dic[@"state"]];
        self.work_money_date = [NSString stringWithFormat:@"%@",dic[@"work_money_date"]];
        self.asset_house = [NSString stringWithFormat:@"%@",dic[@"asset_house"]];
        self.isgrbx = [NSString stringWithFormat:@"%@",dic[@"isgrbx"]];
        self.person_other_name = [NSString stringWithFormat:@"%@",dic[@"person_other_name"]];
        self.purpose = [NSString stringWithFormat:@"%@",dic[@"purpose"]];
        self.work_tel = [NSString stringWithFormat:@"%@",dic[@"work_tel"]];
        self.asset_car = [NSString stringWithFormat:@"%@",dic[@"asset_car"]];
        self.user_education = [NSString stringWithFormat:@"%@",dic[@"user_education"]];
        self.jrq_table_work_info_id = [NSString stringWithFormat:@"%@",dic[@"jrq_table_work_info_id"]];
        self.person_id_card = [NSString stringWithFormat:@"%@",dic[@"person_id_card"]];
        self.special_company_type_other = [NSString stringWithFormat:@"%@",dic[@"special_company_type_other"]];
        self.user_id_type = [NSString stringWithFormat:@"%@",dic[@"user_id_type"]];
        self.person_dear = [NSString stringWithFormat:@"%@",dic[@"person_dear"]];
        self.user_mobile = [NSString stringWithFormat:@"%@",dic[@"user_mobile"]];
        self.money = [NSString stringWithFormat:@"%@",dic[@"money"]];
        self.isbs = [NSString stringWithFormat:@"%@",dic[@"isbs"]];
        self.asset_house_city_id = [NSString stringWithFormat:@"%@",dic[@"asset_house_city_id"]];
        self.work_address_pro_id = [NSString stringWithFormat:@"%@",dic[@"work_address_pro_id"]];
        self.person_colleague_name = [NSString stringWithFormat:@"%@",dic[@"person_colleague_name"]];
        self.person_company_tel = [NSString stringWithFormat:@"%@",dic[@"person_company_tel"]];
        self.user_tel = [NSString stringWithFormat:@"%@",dic[@"user_tel"]];
        self.asset_car_date = [NSString stringWithFormat:@"%@",dic[@"asset_car_date"]];
        self.person_other_company = [NSString stringWithFormat:@"%@",dic[@"person_other_company"]];
        self.asset_house_money = [NSString stringWithFormat:@"%@",dic[@"asset_house_money"]];
        self.work_type = [NSString stringWithFormat:@"%@",dic[@"work_type"]];
        self.person_know = [NSString stringWithFormat:@"%@",dic[@"person_know"]];
        self.work_address_city_id = [NSString stringWithFormat:@"%@",dic[@"work_address_city_id"]];
        self.person_together_name = [NSString stringWithFormat:@"%@",dic[@"person_together_name"]];
        self.adviserId = [NSString stringWithFormat:@"%@",dic[@"adviserId"]];
        self.special_net_profit = [NSString stringWithFormat:@"%@",dic[@"special_net_profit"]];
        self.user_child = [NSString stringWithFormat:@"%@",dic[@"user_child"]];
        self.asset_car_price = [NSString stringWithFormat:@"%@",dic[@"asset_car_price"]];
        self.adviserPlan = [NSString stringWithFormat:@"%@",dic[@"adviserPlan"]];
        self.user_house_money = [NSString stringWithFormat:@"%@",dic[@"user_house_money"]];
        self.work_address_area_id = [NSString stringWithFormat:@"%@",dic[@"work_address_area_id"]];
        self.asset_house_type_other = [NSString stringWithFormat:@"%@",dic[@"asset_house_type_other"]];
        self.work_address = [NSString stringWithFormat:@"%@",dic[@"work_address"]];
        self.source = [NSString stringWithFormat:@"%@",dic[@"source"]];
        self.createPsId = [NSString stringWithFormat:@"%@",dic[@"createPsId"]];
        self.person_company_name = [NSString stringWithFormat:@"%@",dic[@"person_company_name"]];
        self.person_other_moblie = [NSString stringWithFormat:@"%@",dic[@"person_other_moblie"]];
        self.asset_house_property = [NSString stringWithFormat:@"%@",dic[@"asset_house_property"]];
        self.iscpf = [NSString stringWithFormat:@"%@",dic[@"iscpf"]];
        self.user_sex = [NSString stringWithFormat:@"%@",dic[@"user_sex"]];
        self.person_address = [NSString stringWithFormat:@"%@",dic[@"person_address"]];
        self.person_colleague_work = [NSString stringWithFormat:@"%@",dic[@"person_colleague_work"]];
        self.person_family_name = [NSString stringWithFormat:@"%@",dic[@"person_family_name"]];
        self.asset_house_date = [NSString stringWithFormat:@"%@",dic[@"asset_house_date"]];
        self.mechProId = [NSString stringWithFormat:@"%@",dic[@"mechProId"]];
        self.remark = [NSString stringWithFormat:@"%@",dic[@"remark"]];
        self.icon = [NSString stringWithFormat:@"%@",dic[@"icon"]];
        
        self.photoIdFront = [NSString stringWithFormat:@"%@",dic[@"photo_id_front"]];
        self.photoIdBack = [NSString stringWithFormat:@"%@",dic[@"photo_id_back"]];
        self.photoRegist = [NSString stringWithFormat:@"%@",dic[@"photo_registered"]];
        self.photoRegist2 = [NSString stringWithFormat:@"%@",dic[@"photo_registered2"]];
        self.photoRegist3 = [NSString stringWithFormat:@"%@",dic[@"photo_registered3"]];
        
        self.photoHouse = [NSString stringWithFormat:@"%@",dic[@"photo_house"]];
        self.photoHouse2 = [NSString stringWithFormat:@"%@",dic[@"photo_house2"]];
        self.photoHouse3 = [NSString stringWithFormat:@"%@",dic[@"photo_house3"]];
        self.photoMarry = [NSString stringWithFormat:@"%@",dic[@"photo_marry"]];
        self.photoMarry2 = [NSString stringWithFormat:@"%@",dic[@"photo_marry2"]];
        
        self.photoMarry3 = [NSString stringWithFormat:@"%@",dic[@"photo_marry3"]];
        self.photoWork = [NSString stringWithFormat:@"%@",dic[@"photo_work"]];
        self.photoWork2 = [NSString stringWithFormat:@"%@",dic[@"photo_work2"]];
        self.photoWork3 = [NSString stringWithFormat:@"%@",dic[@"photo_work3"]];
        self.photoWages = [NSString stringWithFormat:@"%@",dic[@"photo_wages"]];
        
        self.photoWages2 = [NSString stringWithFormat:@"%@",dic[@"photo_wages2"]];
        self.photoWages3 = [NSString stringWithFormat:@"%@",dic[@"photo_wages3"]];
        self.photoOther = [NSString stringWithFormat:@"%@",dic[@"photo_other"]];
        self.photoOther2 = [NSString stringWithFormat:@"%@",dic[@"photo_other2"]];
        self.photoOther3 = [NSString stringWithFormat:@"%@",dic[@"photo_other3"]];
        
        self.photoCredit = [NSString stringWithFormat:@"%@",dic[@"photo_credit"]];
        self.photoCredit2 = [NSString stringWithFormat:@"%@",dic[@"photo_credit2"]];
        self.photoCredit3 = [NSString stringWithFormat:@"%@",dic[@"photo_credit3"]];
        self.photoCredit4 = [NSString stringWithFormat:@"%@",dic[@"photo_credit4"]];
        self.photoCredit5 = [NSString stringWithFormat:@"%@",dic[@"photo_credit5"]];
        self.photoCredit6 = [NSString stringWithFormat:@"%@",dic[@"photo_credit6"]];
        self.photoCredit7 = [NSString stringWithFormat:@"%@",dic[@"photo_credit7"]];
        self.photoCredit8 = [NSString stringWithFormat:@"%@",dic[@"photo_credit8"]];
        self.photoCredit9 = [NSString stringWithFormat:@"%@",dic[@"photo_credit9"]];
        self.photoCredit10 = [NSString stringWithFormat:@"%@",dic[@"photo_credit10"]];
        
        self.cpfRange = [NSString stringWithFormat:@"%@",dic[@"cpfRange"]];
        /**
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
         */
        self.asset_house_totalPrice = [NSString stringWithFormat:@"%@",dic[@"asset_house_totalPrice"]];
        
        self.asset_house_totalval = [NSString stringWithFormat:@"%@",dic[@"asset_house_totalval"]];
        self.asset_house_monRange = [NSString stringWithFormat:@"%@",dic[@"asset_house_monRange"]];
        self.asset_house_dateRange = [NSString stringWithFormat:@"%@",dic[@"asset_house_dateRange"]];
        
        self.asset_car_type = [NSString stringWithFormat:@"%@",dic[@"asset_car_type"]];
        
        self.asset_car_totalRange = [NSString stringWithFormat:@"%@",dic[@"asset_car_totalRange"]];
        self.asset_car_monRange = [NSString stringWithFormat:@"%@",dic[@"asset_car_monRange"]];
        self.asset_car_dateRange = [NSString stringWithFormat:@"%@",dic[@"asset_car_dateRange"]];
        /**
         #pragma mark == 新加职业类型
         @property (nonatomic) NSString *occ_type;
         #pragma mark == 新增个人保险缴纳年限范围
         @property (nonatomic) NSString *grbx_term_range;
         #pragma mark == 新增个人保险缴纳金额
         @property (nonatomic) NSString *grbx_sum;
         */
        self.occ_type = [NSString stringWithFormat:@"%@",dic[@"occ_type"]];
        self.grbx_term_range = [NSString stringWithFormat:@"%@",dic[@"grbx_term_range"]];
        self.grbx_sum = [NSString stringWithFormat:@"%@",dic[@"grbx_sum"]];
        self.audio_url = [NSString stringWithFormat:@"%@",dic[@"audio_url"]];
        self.tepl_url = [NSString stringWithFormat:@"%@",dic[@"tepl_url"]];
    }
    return self;
}
+(id)requestWithDic:(NSDictionary*)dic
{
    return [[self alloc] initWithDic:dic];
}
@end
