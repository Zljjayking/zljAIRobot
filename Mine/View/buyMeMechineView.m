//
//  buyMeMechineView.m
//  Financeteam
//
//  Created by Zccf on 2017/8/9.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import "buyMeMechineView.h"

@implementation buyMeMechineView

- (instancetype)initWithFrame:(CGRect)frame type:(NSInteger)type {
    if (self = [super initWithFrame:frame]) {
        if (type == 1) {
            self.imageArr = @[@"kaoQin1",@"kaoQin2",@"kaoQin3"];
            self.titleStr = @"考勤机";
            self.contentStr = @"考勤机考勤机考勤机考勤机考勤机考勤机考勤机考勤机考勤机考勤机考勤机考勤机";
        } else {
            self.imageArr = @[@"gaoPai1",@"gaoPai2",@"gaoPai3"];
            self.titleStr = @"高拍";
            self.contentStr = @"高拍高拍高拍高拍高拍高拍高拍高拍高拍高拍高拍高拍高拍高拍高拍高拍高拍高拍";
        }
        [self setupView];
    }
    return self;
}
- (void)setupView{
    self.backgroundColor = [UIColor clearColor];
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 10;
    
    self.topScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 260*KAdaptiveRateWidth, 370*KAdaptiveRateWidth)];
    self.topScroll.scrollEnabled = YES;
    self.topScroll.pagingEnabled = YES;
    self.topScroll.delegate = self;
    self.topScroll.layer.masksToBounds = YES;
    self.topScroll.layer.cornerRadius = 10;
    self.topScroll.showsHorizontalScrollIndicator = NO;
    self.topScroll.contentSize = CGSizeMake(3*260*KAdaptiveRateWidth, 0);
    [self addSubview:self.topScroll];
//    [self.topScroll mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.mas_left).offset(0);
//        make.right.equalTo(self.mas_right).offset(-0);
//        make.top.equalTo(self.mas_top).offset(0);
//        make.height.mas_equalTo(370);
//    }];
    
    
    for (int i = 0; i < self.imageArr.count; i++) {
        NSString *imageName = self.imageArr[i];
        UIImageView *imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imageName]];
        [self.topScroll addSubview:imageV];
        imageV.frame = CGRectMake(i*260*KAdaptiveRateWidth, 0, 260*KAdaptiveRateWidth, 370*KAdaptiveRateWidth);
//        [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.topScroll.mas_left).offset(i*260);
//            make.top.equalTo(self.topScroll.mas_top);
//            make.bottom.equalTo(self.topScroll.mas_bottom);
//            make.width.mas_equalTo(260);
//            make.height.mas_equalTo(370);
//        }];
    }

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollview {
//    int page = scrollview.contentOffset.x / scrollview.frame.size.width;
//    [self.page setCurrentPage:page];
}
@end
