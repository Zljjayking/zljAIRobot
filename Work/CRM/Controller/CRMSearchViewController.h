//
//  CRMSearchViewController.h
//  Financeteam
//
//  Created by 张正飞 on 16/7/27.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "BaseViewController.h"
typedef void (^ReturnNSMutableDictionaryBlock)(NSMutableDictionary *returnMutableDictionary);
@interface CRMSearchViewController : BaseViewController
@property (nonatomic,copy) ReturnNSMutableDictionaryBlock returnNSMutableDictionaryBlock;
- (void)returnMutableDictionary:(ReturnNSMutableDictionaryBlock)block;
@end
