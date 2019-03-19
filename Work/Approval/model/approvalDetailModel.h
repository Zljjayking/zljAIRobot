//
//  approvalDetailModel.h
//  Financeteam
//
//  Created by Zccf on 2017/5/15.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface approvalDetailModel : NSObject
/**
 "deptName": "技术部",
 "application_id": 1,
 "apply_name": null,
 "businessAddress": null,
 "clock_time": null,
 "create_time": 1494385495000,
 "end_time": 1494385388000,
 "flow_id": 1,
 "goodsPurchased": null,
 "handover": null,
 "hour": 1,
 "icon": "/usericon/uic1469538741943.jpg",
 "leave_reason": "1",
 "leave_type_id": 1,
 "leave_type_name": "年休假",
 "nextNickName": "Zccf丶",
 "nick_name": "Zccf丶",
 "nowUserId": null,
 "number": null,
 "position": null,
 "reason": null,
 "reimbursement_amount": null,
 "specificationModel": null,
 "start_time": 1494385386000,
 "state_type": 1,
 "title": null,
 "toUser": "1",
 "toUserName": "瀚承鸿澜",
 "iconList": [
 {
 "approval_id": 1,
 "create_time": 1494923682000,
 "icon": "http: //baidu.com",
 "id": 1,
 "status": 0
 }
 ]
 */
@property (nonatomic) NSString *nextUserId;
@property (nonatomic) NSString *realName;
@property (nonatomic) NSString *apply_name;
@property (nonatomic) NSString *application_id;
@property (nonatomic) NSString *application_name;
@property (nonatomic) NSString *create_time;
@property (nonatomic) NSString *end_time;
@property (nonatomic) NSString *businessAddress;
@property (nonatomic) NSString *clock_time;
@property (nonatomic) NSString *goodsPurchased;
@property (nonatomic) NSString *handover;
@property (nonatomic) NSString *leave_type_name;
@property (nonatomic) NSString *nowUserId;
@property (nonatomic) NSString *number;
@property (nonatomic) NSString *position;
@property (nonatomic) NSString *reason;
@property (nonatomic) NSString *reimbursement_amount;
@property (nonatomic) NSString *specificationModel;
@property (nonatomic) NSString *start_time;
@property (nonatomic) NSString *state_type;
@property (nonatomic) NSString *status;
@property (nonatomic) NSString *title;
@property (nonatomic) NSString *toUser;
@property (nonatomic) NSString *toUserName;
@property (nonatomic) NSString *flow_id;
@property (nonatomic) NSString *flow_name;
@property (nonatomic) NSString *leave_reason;
@property (nonatomic) NSString *leave_type_id;
@property (nonatomic) NSString *hour;
@property (nonatomic) NSString *icon;
@property (nonatomic) NSString *nextNickName;
@property (nonatomic) NSString *nick_name;
@property (nonatomic) NSString *deptName;
@property (nonatomic) NSString *Id;
@property (nonatomic) NSString *apply_id;
@property (nonatomic) NSString *seq_id;
//@property (nonatomic) NSString *apply_name;
//29
+(id)requestWithDic:(NSDictionary*)dic;
@end
