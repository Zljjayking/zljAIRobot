//
//  announcementView.h
//  Financeteam
//
//  Created by Zccf on 2017/6/23.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^isPopEnable)();
@interface announcementView : UIView
@property (nonatomic) isPopEnable isPopBlock;
@property (nonatomic, strong) NSArray *dataArr;
- (id)initWithFrame:(CGRect)frame modelArr:(NSMutableArray *)modelArr title:(NSString *)title;
@end
