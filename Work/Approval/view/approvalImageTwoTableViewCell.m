//
//  approvalImageTwoTableViewCell.m
//  Financeteam
//
//  Created by Zccf on 2017/5/17.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import "approvalImageTwoTableViewCell.h"

@implementation approvalImageTwoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
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
