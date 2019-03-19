//
//  employeeInfoModel.m
//  Financeteam
//
//  Created by Zccf on 17/4/25.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import "employeeInfoModel.h"
/**
 @property (nonatomic) NSString *address;
 @property (nonatomic) NSString *birthday;
 @property (nonatomic) NSString *company_address;
 @property (nonatomic) NSString *company_name;
 @property (nonatomic) NSString *education;
 @property (nonatomic) NSString *home_address;
 @property (nonatomic) NSString *jrq_id_card;
 @property (nonatomic) NSString *marital_status;
 @property (nonatomic) NSString *mobile;
 @property (nonatomic) NSString *post_name;
 @property (nonatomic) NSString *real_name;
 @property (nonatomic) NSString *sex;
 @property (nonatomic) NSString *telephone;
 @property (nonatomic) NSString *userId;
 */
@implementation employeeInfoModel
- (id)initWithDic:(NSDictionary *)dic {
    if (self = [super init]) {
        
        NSArray *comp = (NSArray *)dic[@"compList"];
        NSDictionary *compDic;
        if (comp.count) {
            compDic = comp[0];
            self.telephone = [NSString stringWithFormat:@"%@",compDic[@"telephone"]];
            self.post_name = [NSString stringWithFormat:@"%@",compDic[@"post_name"]];
            self.company_address = [NSString stringWithFormat:@"%@",compDic[@"company_address"]];
            self.company_name = [NSString stringWithFormat:@"%@",compDic[@"company_name"]];
        } else {
            self.telephone = [NSString stringWithFormat:@"%@",@""];
            self.post_name = [NSString stringWithFormat:@"%@",@""];
            self.company_address = [NSString stringWithFormat:@"%@",@""];
            self.company_name = [NSString stringWithFormat:@"%@",@""];
        }
        
        self.address = [NSString stringWithFormat:@"%@",dic[@"address"]];
        
        self.birthday = [NSString stringWithFormat:@"%@",dic[@"birthday"]];
        if (![Utils isBlankString:self.birthday]) {
            self.birthday = [Utils transportToDate:[self.birthday longLongValue]];
        }
        
        self.education = [NSString stringWithFormat:@"%@",dic[@"education"]];
        self.home_address = [NSString stringWithFormat:@"%@",dic[@"home_address"]];
        self.jrq_id_card = [NSString stringWithFormat:@"%@",dic[@"jrq_id_card"]];
        self.marital_status = [NSString stringWithFormat:@"%@",dic[@"marital_status"]];
        self.mobile = [NSString stringWithFormat:@"%@",dic[@"mobile"]];
        
        self.real_name = [NSString stringWithFormat:@"%@",dic[@"real_name"]];
        self.sex = [NSString stringWithFormat:@"%@",dic[@"sex"]];
        
        self.userId = [NSString stringWithFormat:@"%@",dic[@"userId"]];
    }
    return self;
}
+(id)requestWithDic:(NSDictionary *)dic {
    return [[self alloc] initWithDic:dic];
}
@end
