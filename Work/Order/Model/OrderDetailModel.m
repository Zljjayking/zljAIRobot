//
//  OrderDetailModel.m
//  Financeteam
//
//  Created by 张正飞 on 16/6/21.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "OrderDetailModel.h"

@implementation OrderDetailModel
-(id)initWithDic:(NSDictionary*)dic
{
    if (self = [super init])
    {
        self.tabQuota = [dic[@"tabQuota"] floatValue];
        self.tabRepayMonth = [dic[@"tabRepayMonth"] integerValue];
        self.tabTerm = [dic[@"tabTerm"] integerValue];
        self.tabLoan = [dic[@"tabLoan"] integerValue];
        self.tabLoanDetail = dic[@"tabLoanDetail"];
        
        
        self.houseType = [dic[@"houseType"] integerValue];
        self.houseTypeOther = dic[@"houseTypeOther"];
        self.houseArea = [dic[@"houseArea"] integerValue];
        self.housePrice = [dic[@"housePrice"] integerValue];
        self.houseDate = [dic[@"houseDate"] longLongValue]/1000;
        self.houseProperty = [dic[@"houseProperty"] integerValue];
        self.houseYear = [dic[@"houseYear"] floatValue];
        self.houseMonth = [dic[@"houseMonth"] integerValue];
        self.houseMoney = [dic[@"houseMoney"] floatValue];
        self.carName = dic[@"carName"];
        self.carDate = [dic[@"carDate"] longLongValue]/1000;
        self.carPrice = [dic[@"carPrice"]floatValue];
        self.carMonth= [dic[@"carMonth"]integerValue];
        self.houseProId= [dic[@"houseProId"]integerValue];
        self.houseCityId= [dic[@"houseCityId"]integerValue];
        self.houseAreaId= [dic[@"houseAreaId"]integerValue];
        self.houseDetail= dic[@"houseDetail"];
        
        
        self.dearName= dic[@"dearName"];
        self.idCard= dic[@"idCard"];
        self.perMobile= dic[@"perMobile"];
        self.companyName= dic[@"companyName"];
        self.companyAddress= dic[@"companyAddress"];
        self.companyTel= dic[@"companyTel"];
        self.perAddress= dic[@"perAddress"];
        self.perFamName= dic[@"perFamName"];
        self.perFamShip= dic[@"perFamShip"];
        self.perFamMobile= dic[@"perFamMobile"];
        self.perFamCompany= dic[@"perFamCompany"];
        self.perCollName= dic[@"perCollName"];
        self.perCollWork= dic[@"perCollWork"];
        self.perCollMobile= dic[@"perCollMobile"];
        self.perCollCompany= dic[@"perCollCompany"];
        self.perOtherName= dic[@"perOtherName"];
        self.perOtherShip= dic[@"perOtherShip"];
        self.perOtherMobile= dic[@"perOtherMobile"];
        self.perOtherCompany= dic[@"perOtherCompany"];
        self.perKnow= dic[@"perKnow"];
        self.perTogetherName= dic[@"perTogetherName"];
        
        
        self.photoIdFront= dic[@"photoIdFront"];
        self.photoIdBack= dic[@"photoIdBack"];
        
        self.photoRegist= dic[@"photoRegist"];
        self.photoRegist2= dic[@"photoRegist2"];
        self.photoRegist3= dic[@"photoRegist3"];
        
        self.photoHouse= dic[@"photoHouse"];
        self.photoHouse2= dic[@"photoHouse2"];
        self.photoHouse3= dic[@"photoHouse3"];
        
        self.photoMarry= dic[@"photoMarry"];
        self.photoMarry2= dic[@"photoMarry2"];
        self.photoMarry3= dic[@"photoMarry3"];
        
        self.photoWork= dic[@"photoWork"];
        self.photoWork2= dic[@"photoWork2"];
        self.photoWork3= dic[@"photoWork3"];
        
        self.photoWages= dic[@"photoWages"];
        self.photoWages2= dic[@"photoWages2"];
        self.photoWages3= dic[@"photoWages3"];
        
        self.photoOther= dic[@"photoOther"];
        self.photoOther2= dic[@"photoOther2"];
        self.photoOther3= dic[@"photoOther3"];
        
        self.photoCredit= dic[@"photoCredit"];
        self.photoCredit2= dic[@"photoCredit2"];
        self.photoCredit3= dic[@"photoCredit3"];
        self.photoCredit4= dic[@"photoCredit4"];
        self.photoCredit5= dic[@"photoCredit5"];
        
        self.photoCredit6= dic[@"photoCredit6"];
        self.photoCredit7= dic[@"photoCredit7"];
        self.photoCredit8= dic[@"photoCredit8"];
        self.photoCredit9= dic[@"photoCredit9"];
        self.photoCredit10= dic[@"photoCredit10"];
        
        self.speComType= [dic[@"speComType"] integerValue];
        self.speComTypeOther= dic[@"speComTypeOther"];
        self.speComDate= dic[@"speComDate"];
        self.speComNumber= [dic[@"speComNumber"] integerValue];
        self.speNetProfit= [dic[@"speNetProfit"] integerValue];
        self.speComArea= [dic[@"speComArea"] integerValue];
        
        self.tabUName= dic[@"tabUName"];
        self.tabUSex= [dic[@"tabUSex"] integerValue];
        self.tabUMobile= dic[@"tabUMobile"];
        self.tabUIdType= [dic[@"tabUIdType"] integerValue];
        self.tabUIdNum= dic[@"tabUIdNum"];
        self.tabUMarry= [dic[@"tabUMarry"] integerValue];
        self.tabUChild= [dic[@"tabUChild"] integerValue];
        self.tabUEdu= [dic[@"tabUEdu"] integerValue];
        self.tabUqqNum= dic[@"tabUqqNum"];
        self.tabUEmail= dic[@"tabUEmail"];
        self.tabUPostAds= dic[@"tabUPostAds"];
        self.tabUPostAdsRegi= dic[@"tabUPostAdsRegi"];
        self.tabUHsType= [dic[@"tabUHsType"] integerValue];
        self.tabUHsMoney= [dic[@"tabUHsMoney"] integerValue];
        self.tabUHsOther= dic[@"tabUHsOther"];
        self.tabUTel= dic[@"tabUTel"];
        self.adsTime= [dic[@"adsTime"]longLongValue]/1000;
        self.adsStarTime= [dic[@"adsStarTime"]longLongValue]/1000;
        self.proId= [dic[@"proId"] integerValue];
        self.cityId= [dic[@"cityId"] integerValue];
        self.areaId= [dic[@"areaId"]integerValue];
        self.tabURegi= dic[@"tabURegi"];
        self.adsProId= [dic[@"adsProId"] integerValue];
        self.adsCityId= [dic[@"adsCityId"] integerValue];
        self.adsAreaId= [dic[@"adsAreaId"] integerValue];
        self.tabUAds= dic[@"tabUAds"];
        
        self.wkName= dic[@"wkName"];
        self.wkType= [dic[@"wkType"] integerValue]/1000;
        self.wkTel= dic[@"wkTel"];
        self.wkPart= dic[@"wkPart"];
        self.wkJob= dic[@"wkJob"];
        self.wkDate = [dic[@"wkDate"] longLongValue]/1000;
        self.wkIndu= dic[@"wkIndu"];
        self.wkMoney= [dic[@"wkMoney"] integerValue];
        self.wkMonDate= [dic[@"wkMonDate"]integerValue];
        self.wkMonType= [dic[@"wkMonType"]integerValue];
        self.wkAds= dic[@"wkAds"];
        self.wkProId= [dic[@"wkProId"]integerValue];
        self.wkCityId= [dic[@"wkCityId"]integerValue];
        self.wkAreaId= [dic[@"wkAreaId"]integerValue];
        
        self.orderID = [dic[@"id"]integerValue];
        self.mechProId = [dic[@"mechProId"] integerValue];
        
        self.tabUserId = [dic[@"tabUserId"]integerValue];
        self.userId = [dic[@"userId"]integerValue];
        self.UserIcon = dic[@"userIcon"];
        self.tabUserIcon = dic[@"tabUserIcon"];
        
        self.tableWorkInfoId = [dic[@"tableWorkInfoId"] integerValue];
        self.tableAssetInfoId = [dic[@"tableAssetInfoId"] integerValue];
        self.tableUserInfoId = [dic[@"tableUserInfoId"] integerValue];
        self.tableSpecialInfoId = [dic[@"tableSpecialInfoId"]integerValue];
        self.tablePhotoInfoId = [dic[@"tablePhotoInfoId"] integerValue];
        self.tablePersonalInfoId = [dic[@"tablePersonalInfoId"] integerValue];
        self.tabCreateTime = [dic[@"tabCreateTime"] longLongValue]/1000;
        self.tabSpeed = [dic[@"tabSpeed"] integerValue];
        self.tableFinishTime = [dic[@"tableFinishTime"] longLongValue]/1000;
        
        self.tabSerMoney = [dic[@"tabSerMoney"] floatValue];
        self.tabSerMoneyMech = [dic[@"tabSerMoneyMech"] floatValue];
        
        _mpName = dic[@"mpName"];
        _mpIcon = dic[@"mpIcon"];
        _failureCause = dic[@"failureCause"];
        _examineInfo = dic[@"examineInfo"];
    
        self.publicity_mech_id = [NSString stringWithFormat:@"%@",dic[@"publicity_mech_id"]];
        self.jrq_mechanism_id = [NSString stringWithFormat:@"%@",dic[@"jrq_mechanism_id"]];
    }
    return self;
}

+(id)requestWithDic:(NSDictionary*)dic
{
    return [[self alloc]initWithDic:dic];
}


@end
