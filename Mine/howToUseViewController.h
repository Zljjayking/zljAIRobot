//
//  howToUseViewController.h
//  Financeteam
//
//  Created by Zccf on 2017/8/17.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import "BaseViewController.h"

@interface howToUseViewController : BaseViewController
@property (nonatomic, copy) NSString *urlStr;
/**是否支持web下拉刷新 default is NO*/
@property (nonatomic, assign) BOOL isPullRefresh;
@end
