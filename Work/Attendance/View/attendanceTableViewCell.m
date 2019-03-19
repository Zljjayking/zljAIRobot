//
//  attendanceTableViewCell.m
//  Financeteam
//
//  Created by Zccf on 2017/6/1.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import "attendanceTableViewCell.h"

@implementation attendanceTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        [self setupView];
    }
    return self;
}
- (void)setupView {
    
    
    UIImageView *imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"attendance_fingerprint"]];
    [self addSubview:imageV];
    imageV.backgroundColor = [UIColor whiteColor];
    imageV.layer.cornerRadius = 17;
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(14);
        make.centerY.equalTo(self.mas_centerY);
        make.width.mas_equalTo(34);
        make.height.mas_equalTo(34);
    }];
    
    UIView *bgv = [[UIView alloc] init];
    [self addSubview:bgv];
    bgv.backgroundColor = kMyColor(83, 158, 239);
    bgv.layer.cornerRadius = 5;
    [bgv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageV.mas_right).offset(15);
        make.centerY.equalTo(self.mas_centerY);
        make.height.mas_equalTo(70);
        make.right.equalTo(self.mas_right).offset(-10);
    }];
    
    self.timeLB = [[UILabel alloc] init];
    [bgv addSubview:self.timeLB];
    self.timeLB.textColor = [UIColor whiteColor];
    self.timeLB.font = [UIFont systemFontOfSize:20];
    [self.timeLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgv.mas_left).offset(15);
        make.centerY.equalTo(bgv.mas_centerY).offset(-10);
        make.height.mas_equalTo(20);
    }];
    
    self.IDLB = [[UILabel alloc] init];
    [bgv addSubview:self.IDLB];
    self.IDLB.font = [UIFont systemFontOfSize:13];
    self.IDLB.textColor = [UIColor whiteColor];
    [self.IDLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bgv.mas_right).offset(-10);
        make.bottom.equalTo(bgv.mas_bottom).offset(-10);
        make.height.mas_equalTo(15);
    }];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
