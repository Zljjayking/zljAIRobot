//
//  approvalFlowViewController.h
//  Financeteam
//
//  Created by Zccf on 2017/5/15.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import "BaseViewController.h"
typedef void (^returnFlowName) (NSString *flowNameStr);
typedef void (^returnFlowId) (NSString *flowIdStr);
typedef void (^returnPeopleArr) (NSArray *peopleArr);
@interface approvalFlowViewController : BaseViewController
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) returnFlowName returnFlowNameBlock;
@property (nonatomic, strong) returnFlowId returnFlowIdBlock;
@property (nonatomic, strong) returnPeopleArr returnPeopleArrBlock;

@property (nonatomic, strong) NSString *application_id;

@property (nonatomic, strong) NSString *flow_id;
@end
