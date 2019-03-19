//
//  NoticeDetailsViewController.h
//  Financeteam
//
//  Created by Zccf on 16/6/21.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "BaseViewController.h"
typedef void (^ReturnIsRefreshNoticeBlock)(NSString *returnIsRefrshNotice);
@interface NoticeDetailsViewController : BaseViewController
@property (nonatomic) NSString *bid;
@property (nonatomic) BOOL isUpdateNotice;
@property (nonatomic) ReturnIsRefreshNoticeBlock isRefreshNotice;
- (void)returnIsRefreshNotice:(ReturnIsRefreshNoticeBlock)block;
@property (nonatomic) NSInteger setype;
@end
