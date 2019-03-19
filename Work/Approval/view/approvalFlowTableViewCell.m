//
//  approvalFlowTableViewCell.m
//  Financeteam
//
//  Created by Zccf on 2017/5/16.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import "approvalFlowTableViewCell.h"

@implementation approvalFlowTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
//        self.selectionStyle = UITableViewCellSelectionStyleBlue;
        self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.frame];
        self.selectedBackgroundView.backgroundColor = VIEW_BASE_COLOR;
//        self.selectedBackgroundView.backgroundColor = VIEW_BASE_COLOR;
        //        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [self setupView];
    }
    return self;
}
- (void)setupView {
    UIView *numberView = [[UIView alloc] init];
    numberView.backgroundColor = VIEW_BASE_COLOR;
    [self addSubview:numberView];
    [numberView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10);
        make.centerY.equalTo(self.mas_centerY);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(40);
    }];
    
    self.numberLB = [[UILabel alloc]init];
    [self addSubview:self.numberLB];
    self.numberLB.textAlignment = NSTextAlignmentCenter;
    self.numberLB.font = [UIFont systemFontOfSize:13];
    [self.numberLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10);
        make.centerY.equalTo(self.mas_centerY);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(20);
    }];
    
//    self.headerImage = [[UIImageView alloc]init];
//    [self addSubview:self.headerImage];
//    
//    [self.headerImage mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(numberView.mas_right).offset(10);
//        make.centerY.equalTo(self.mas_centerY);
//        make.width.mas_equalTo(50);
//        make.height.mas_equalTo(50);
//    }];
    
    self.nameLB = [[UILabel alloc] init];
    [self addSubview:self.nameLB];
    self.nameLB.numberOfLines = 0;
    self.nameLB.font = [UIFont systemFontOfSize:15];
    [self.nameLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(numberView.mas_right).offset(10);
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
    }];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
