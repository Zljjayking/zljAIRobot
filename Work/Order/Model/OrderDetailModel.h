//
//  OrderDetailModel.h
//  Financeteam
//
//  Created by 张正飞 on 16/6/21.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderDetailModel : NSObject

/*贷款申请信息*/
//申请额度
@property (nonatomic)float tabQuota;
//月接受还款额（默认1000）
@property (nonatomic)float tabRepayMonth;
//申请期限(默认三个月)
@property (nonatomic)long tabTerm;


/*个人信息*/

//申请人姓名
@property (nonatomic,strong) NSString *tabUName;
//申请人性别
@property (nonatomic)NSInteger tabUSex;
//申请人手机
@property (nonatomic,strong) NSString *tabUMobile;
//证件类型1身份证2护照3军官证
@property (nonatomic)NSInteger tabUIdType;
//证件号码,需要验证重复
@property (nonatomic,strong) NSString *tabUIdNum;
//婚姻状况1已婚2未婚3离异4丧偶
@property (nonatomic)NSInteger tabUMarry;
//有无子女1有2无
@property (nonatomic)NSInteger tabUChild;
//最高学历1本科及以上2大专3高中4高中及以下
@property (nonatomic)NSInteger tabUEdu;
//QQ
@property (nonatomic,strong) NSString *tabUqqNum;
//邮箱
@property (nonatomic,strong) NSString *tabUEmail;
//户口所在地邮政编码
@property (nonatomic,strong) NSString *tabUPostAds;
//现住址邮政编码
@property (nonatomic,strong) NSString *tabUPostAdsRegi;
//住宅类型1租用2商业按揭购房3公积金按揭购房4全款商品房5自建房6家族房7单位宿舍8其他
@property (nonatomic)NSInteger tabUHsType;
//租金或还款 如果tabUHsType为123则必填 元
@property (nonatomic)NSInteger tabUHsMoney;
//其他 如果tabUHsType为8则必填
@property (nonatomic,strong) NSString *tabUHsOther;
//住宅电话
@property (nonatomic,strong) NSString *tabUTel;
//来本地时间
@property (nonatomic)long long  adsTime;
//开始居住时间
@property (nonatomic)long long  adsStarTime;
//户口所在省
@property (nonatomic)NSInteger proId;
//户口所在市
@property (nonatomic)NSInteger cityId;
//户口所在区
@property (nonatomic)NSInteger areaId;
//户口所在地具体地址
@property (nonatomic,strong) NSString *tabURegi;
//住址省
@property (nonatomic)NSInteger adsProId;
//住址市
@property (nonatomic)NSInteger adsCityId;
//住址区
@property (nonatomic)NSInteger adsAreaId;
//具体住址
@property (nonatomic,strong) NSString *tabUAds;



/*资产信息*/
// 房产类型 1揭购房 2自建房 3全款房 4其他
@property (nonatomic)NSInteger houseType;
//如果houseType为4则必填
@property (nonatomic,strong) NSString *houseTypeOther;
//建筑面积 ㎡
@property (nonatomic)float houseArea;
//购买单价 元/㎡
@property (nonatomic)float housePrice;
//购房时间
@property (nonatomic)long long  houseDate;
//产权比例 %
@property (nonatomic)float houseProperty;
//贷款年限 年
@property (nonatomic)float houseYear;
//月供 元
@property (nonatomic)float houseMonth;
//贷款余额 万元
@property (nonatomic)float houseMoney;
//车辆品牌
@property (nonatomic,strong) NSString *carName;
//购车时间
@property (nonatomic)long long  carDate;
//车辆购买价格 万元
@property (nonatomic)float carPrice;
//车贷月供 元
@property (nonatomic)float carMonth;
//房产地址 省
@property (nonatomic)NSInteger houseProId;
//房产地址 市
@property (nonatomic)NSInteger houseCityId;
//房产地址 区
@property (nonatomic)NSInteger houseAreaId;
//房产具体地址
@property (nonatomic,strong) NSString *houseDetail;


/*工作信息*/
//单位名称
@property (nonatomic,strong) NSString *wkName;
//单位性质1行政事业单位、社会团体 2国企 3民营 4外资 5合资 6私营 7个体
@property (nonatomic)NSInteger wkType;
//单位电话
@property (nonatomic,strong) NSString *wkTel;
//所在部门
@property (nonatomic,strong) NSString *wkPart;
//职位
@property (nonatomic,strong) NSString *wkJob;
//入职时间
@property (nonatomic)long long  wkDate;
//所属行业
@property (nonatomic,strong) NSString *wkIndu;
//月薪
@property (nonatomic)float wkMoney;
//每月发薪日1-31
@property (nonatomic)NSInteger  wkMonDate;
//工资发放形式 1银行代发 2现金 3网银
@property (nonatomic)NSInteger wkMonType;
//单位地址省
@property (nonatomic)NSInteger wkProId;
//单位地址市
@property (nonatomic)NSInteger wkCityId;
//单位地址区
@property (nonatomic)NSInteger wkAreaId;
//单位具体地址
@property (nonatomic,strong) NSString *wkAds;


/*公司信息*/
//企业类型企业类型 1个体工商户 2个人独资/合伙企业 3有限责任公司 4其他
@property (nonatomic)NSInteger speComType;
//如果speComType是4则必填
@property (nonatomic,strong) NSString *speComTypeOther;
//成立时间
@property (nonatomic)NSString *speComDate;
//员工人数
@property (nonatomic)NSInteger speComNumber;
//每月净利润
@property (nonatomic)float speNetProfit;
//营业面积
@property (nonatomic)float speComArea;



/*联系人信息*/
//配偶姓名
@property (nonatomic,strong) NSString *dearName;
//配偶身份证号码
@property (nonatomic,strong) NSString *idCard;
//配偶手机号码
@property (nonatomic,strong) NSString *perMobile;
//配偶单位名称
@property (nonatomic,strong) NSString *companyName;
//配偶单位地址
@property (nonatomic,strong) NSString *companyAddress;
//配偶单位电话
@property (nonatomic,strong) NSString *companyTel;
//配偶居住地址
@property (nonatomic,strong) NSString *perAddress;
//直系亲属姓名
@property (nonatomic,strong) NSString *perFamName;
//亲属关系
@property (nonatomic,strong) NSString *perFamShip;
//亲属电话号码
@property (nonatomic,strong) NSString *perFamMobile;
//亲属单位
@property (nonatomic,strong) NSString *perFamCompany;
//同事姓名
@property (nonatomic,strong) NSString *perCollName;
//同事职务
@property (nonatomic,strong) NSString *perCollWork;
//同事电话
@property (nonatomic,strong) NSString *perCollMobile;
//同事单位
@property (nonatomic,strong) NSString *perCollCompany;
//其他联系人
@property (nonatomic,strong) NSString *perOtherName;
//与其他联系人关系
@property (nonatomic,strong) NSString *perOtherShip;
//其他联系人电话
@property (nonatomic,strong) NSString *perOtherMobile;
//其他联系人所在单位
@property (nonatomic,strong) NSString *perOtherCompany;
//以上哪些人可以知晓贷款
@property (nonatomic,strong) NSString *perKnow;
//共同借款人
@property (nonatomic,strong) NSString *perTogetherName;
// 贷款用途1经营2消费
@property (nonatomic)NSInteger tabLoan;
//贷款详细用途
@property (nonatomic,strong) NSString *tabLoanDetail;



/*图片证明信息*/
//身份证正面
@property (nonatomic,strong) NSString *photoIdFront;
//身份证反面
@property (nonatomic,strong) NSString *photoIdBack;
//户口本
@property (nonatomic,strong) NSString *photoRegist;
@property (nonatomic,strong) NSString *photoRegist2;
@property (nonatomic,strong) NSString *photoRegist3;

//房产证
@property (nonatomic,strong) NSString *photoHouse;
@property (nonatomic,strong) NSString *photoHouse2;
@property (nonatomic,strong) NSString *photoHouse3;

//结婚证
@property (nonatomic,strong) NSString *photoMarry;
@property (nonatomic,strong) NSString *photoMarry2;
@property (nonatomic,strong) NSString *photoMarry3;

//工作收入证明
@property (nonatomic,strong) NSString *photoWork;
@property (nonatomic,strong) NSString *photoWork2;
@property (nonatomic,strong) NSString *photoWork3;

//工资流水证明
@property (nonatomic,strong) NSString *photoWages;
@property (nonatomic,strong) NSString *photoWages2;
@property (nonatomic,strong) NSString *photoWages3;

//其他证明
@property (nonatomic,strong) NSString *photoOther;
@property (nonatomic,strong) NSString *photoOther2;
@property (nonatomic,strong) NSString *photoOther3;
// 信用报告
@property (nonatomic,strong) NSString *photoCredit;
@property (nonatomic,strong) NSString *photoCredit2;
@property (nonatomic,strong) NSString *photoCredit3;
@property (nonatomic,strong) NSString *photoCredit4;
@property (nonatomic,strong) NSString *photoCredit5;
@property (nonatomic,strong) NSString *photoCredit6;
@property (nonatomic,strong) NSString *photoCredit7;
@property (nonatomic,strong) NSString *photoCredit8;
@property (nonatomic,strong) NSString *photoCredit9;
@property (nonatomic,strong) NSString *photoCredit10;


@property (nonatomic)NSInteger orderID;
@property (nonatomic)NSInteger mechProId;
@property (nonatomic)NSInteger tabUserId;//代理申请人id
@property (nonatomic)NSInteger userId;
@property (nonatomic)NSString *UserIcon;//新加代理申请人头像
@property (nonatomic)NSString *tabUserIcon;
@property (nonatomic)NSString *mechName;//新加代理申请人机构名称

@property (nonatomic)long long   tabCreateTime;
@property (nonatomic)NSInteger  tabSpeed;
@property (nonatomic)long long   tableFinishTime;

@property (nonatomic)NSInteger tableAssetInfoId;
@property (nonatomic)NSInteger tablePersonalInfoId;
@property (nonatomic)NSInteger tablePhotoInfoId;
@property (nonatomic)NSInteger tableSpecialInfoId;
@property (nonatomic)NSInteger tableWorkInfoId;
@property (nonatomic)NSInteger tableUserInfoId;

@property (nonatomic)float tabSerMoney;
@property (nonatomic)float tabSerMoneyMech;

@property (nonatomic,strong) NSString * mpName;
@property (nonatomic,strong) NSString * mpIcon;

@property (nonatomic,strong) NSString * failureCause;//失败原因
@property (nonatomic,strong) NSString * examineInfo;//审批备注

@property (nonatomic,strong) NSString *publicity_mech_id;
@property (nonatomic,strong) NSString *jrq_mechanism_id;

+(id)requestWithDic:(NSDictionary*)dic;

@end
