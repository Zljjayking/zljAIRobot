//
//  addApprovalPeopleTableViewCell.m
//  Financeteam
//
//  Created by Zccf on 2017/5/15.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import "addApprovalPeopleTableViewCell.h"

@implementation addApprovalPeopleTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        //        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [addBtn setImage:[UIImage imageNamed:@"jia"] forState:UIControlStateNormal];
        [addBtn setTitleColor:kMyColor(34, 152, 214) forState:UIControlStateNormal];
        [addBtn setTitle:@"添加审批人员" forState:UIControlStateNormal];
        [self addSubview:addBtn];
        addBtn.userInteractionEnabled = NO;
        [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            make.centerX.equalTo(self.mas_centerX);
            make.height.mas_equalTo(20);
        }];
        
        UIView *seperator1 = [[UIView alloc]init];
        [self addSubview:seperator1];
        seperator1.backgroundColor = GRAY229;
        [seperator1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_bottom).offset(-1);
            make.height.mas_equalTo(0.3);
            make.width.mas_equalTo(kScreenWidth);
        }];
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
