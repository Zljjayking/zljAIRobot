//
//  announcementView.m
//  Financeteam
//
//  Created by Zccf on 2017/6/23.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import "announcementView.h"
#import "blankView.h"
#import "rankingModel.h"
@implementation announcementView
- (id)initWithFrame:(CGRect)frame modelArr:(NSMutableArray *)modelArr title:(NSString *)title{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = customBackColor;
        if (modelArr.count) {
            if ([title isEqualToString:@"zao"]) {
                for (int i = 0; i<modelArr.count-1; ++i) {
                    for (int j=0; j<modelArr.count-i-1; ++j) {
                        rankingModel *model1 = modelArr[j];
                        rankingModel *model2 = modelArr[j+1];
                        if ([model1.count intValue] < [model2.count intValue]) {
                            rankingModel* tempModel = model1;
                            [modelArr replaceObjectAtIndex:j withObject:model2];
                            [modelArr replaceObjectAtIndex:j+1 withObject:tempModel];
                        }
                    }
                }
            }
            
            self.dataArr = modelArr;
            
            [self setupView];
        } else {
            blankView *blank = [[blankView alloc]initWithFrame:CGRectMake(kScreenWidth/2.0-60,kScreenHeight/2.0-60,120, 120) imageName:@"noData2" title:@"暂无榜单数据"];
            blank.titleLabel.textColor = [UIColor whiteColor];
            [self addSubview:blank];
        }
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapView)];
        [self addGestureRecognizer:tap];
    }
    return self;
}
- (void)tapView {
    self.isPopBlock();
    [self removeFromSuperview];
}
- (void)setupView {
    UIImageView *PodiumImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Podium"]];
    [self addSubview:PodiumImage];
    PodiumImage.frame = CGRectMake((kScreenWidth-256)/2.0, kScreenHeight, 256, 84.8);
//    [PodiumImage mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.mas_bottom);
//        make.centerX.equalTo(self.mas_centerX);
//        make.height.mas_equalTo(53);
//        make.width.mas_equalTo(160);
//    }];
    
    
    
    
    UIView *peopleOne = [[UIView alloc]init];
    peopleOne.backgroundColor = [UIColor clearColor];
    [self addSubview:peopleOne];
    peopleOne.frame = CGRectMake((kScreenWidth-60)/2.0-85, -100, 60, 100);
    
    UIImageView *ssOne = [[UIImageView alloc]init];
    [peopleOne addSubview:ssOne];
    ssOne.frame = CGRectMake(0, 10, 60, 60);
    ssOne.layer.masksToBounds = YES;
    ssOne.layer.cornerRadius = 30;
    
    UILabel *llOne = [[UILabel alloc]initWithFrame:CGRectMake(0, 80, 60, 16)];
    [peopleOne addSubview:llOne];
    llOne.font = [UIFont systemFontOfSize:14];
    llOne.textAlignment = NSTextAlignmentCenter;
    llOne.textColor = [UIColor whiteColor];
    
    if (self.dataArr.count >= 2) {
        rankingModel *model = self.dataArr[1];
        [ssOne sd_setImageWithURL:[model.icon convertHostUrl] placeholderImage:[UIImage imageNamed:@"聊天头像"]];
        llOne.text = model.name;
    }
//    [peopleOne mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.mas_top);
//        make.centerX.equalTo(self.mas_centerX).offset(-40);
//        make.width.mas_equalTo(30);
//        make.height.mas_equalTo(30);
//    }];
    
    
    UIView *peopleTwo = [[UIView alloc]init];
    peopleTwo.backgroundColor = [UIColor clearColor];
    [self addSubview:peopleTwo];
    peopleTwo.frame = CGRectMake((kScreenWidth-60)/2.0, -120, 60, 100);
    
    UIImageView *ssTwo = [[UIImageView alloc]init];
    [peopleTwo addSubview:ssTwo];
    ssTwo.frame = CGRectMake(0, 10, 60, 60);
    ssTwo.layer.masksToBounds = YES;
    ssTwo.layer.cornerRadius = 30;
    
    UILabel *llTwo = [[UILabel alloc]initWithFrame:CGRectMake(0, 80, 60, 16)];
    [peopleTwo addSubview:llTwo];
    llTwo.font = [UIFont systemFontOfSize:14];
    llTwo.textAlignment = NSTextAlignmentCenter;
    llTwo.textColor = [UIColor whiteColor];
    
    
    if (self.dataArr.count >= 1) {
        rankingModel *model = self.dataArr[0];
        [ssTwo sd_setImageWithURL:[model.icon convertHostUrl] placeholderImage:[UIImage imageNamed:@"聊天头像"]];
        llTwo.text = model.name;
    }
    
    UIView *peopleThree = [[UIView alloc]init];
    peopleThree.backgroundColor = [UIColor clearColor];
    [self addSubview:peopleThree];
    peopleThree.frame = CGRectMake((kScreenWidth-60)/2.0+85, -100, 60, 100);
    
    UIImageView *ssThree = [[UIImageView alloc]init];
    [peopleThree addSubview:ssThree];
    ssThree.frame = CGRectMake(0, 10, 60, 60);
    ssThree.layer.masksToBounds = YES;
    ssThree.layer.cornerRadius = 30;
    
    UILabel *llThree = [[UILabel alloc]initWithFrame:CGRectMake(0, 80, 60, 16)];
    [peopleThree addSubview:llThree];
    llThree.font = [UIFont systemFontOfSize:14];
    llThree.textColor = [UIColor whiteColor];
    llThree.textAlignment = NSTextAlignmentCenter;
    
    
    if (self.dataArr.count >= 3) {
        rankingModel *model = self.dataArr[2];
        [ssThree sd_setImageWithURL:[model.icon convertHostUrl] placeholderImage:[UIImage imageNamed:@"聊天头像"]];
        llThree.text = model.name;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        PodiumImage.frame = CGRectMake((kScreenWidth-256)/2.0, kScreenHeight/2.0, 256, 84.8);
        
        peopleTwo.frame = CGRectMake((kScreenWidth-60)/2.0, kScreenHeight/2.0-90, 60, 100);
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            
            peopleTwo.frame = CGRectMake((kScreenWidth-60)/2.0, kScreenHeight/2.0-120, 60, 100);
            
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 animations:^{
                
                peopleTwo.frame = CGRectMake((kScreenWidth-60)/2.0, kScreenHeight/2.0-100, 60, 100);
                
            }];
        }];
        
    }];
    
    [UIView animateWithDuration:0.4 animations:^{
        peopleOne.frame = CGRectMake((kScreenWidth-60)/2.0-85, kScreenHeight/2.0-60, 60, 100);
        peopleThree.frame = CGRectMake((kScreenWidth-60)/2.0+85, kScreenHeight/2.0-60, 60, 100);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            peopleOne.frame = CGRectMake((kScreenWidth-60)/2.0-85, kScreenHeight/2.0-90, 60, 100);
            peopleThree.frame = CGRectMake((kScreenWidth-60)/2.0+85, kScreenHeight/2.0-90, 60, 100);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 animations:^{
                peopleOne.frame = CGRectMake((kScreenWidth-60)/2.0-85, kScreenHeight/2.0-70, 60, 100);
                peopleThree.frame = CGRectMake((kScreenWidth-60)/2.0+85, kScreenHeight/2.0-70, 60, 100);
            }];
        }];
    }];
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
