//
//  LatestTableViewCell.m
//  Financeteam
//
//  Created by Zccf on 16/7/11.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "LatestTableViewCell.h"

@implementation LatestTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupView];
    }
    return self;
}
-(void)setupView {
    self.contentLb = [[UILabel alloc]init];
    [self addSubview:self.contentLb];
    self.contentLb.textColor = [UIColor redColor];
    self.contentLb.numberOfLines = 0;
    self.contentLb.font = [UIFont systemFontOfSize:13];
    [self.contentLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10);
        make.top.equalTo(self.mas_top).offset(10);
        make.bottom.equalTo(self.mas_bottom).offset(-15);
        make.width.mas_equalTo(kScreenWidth-20);
    }];
    
    self.timeLb = [[UILabel alloc] init];
    [self addSubview:self.timeLb];
    self.timeLb.font = [UIFont systemFontOfSize:10];
    [self.timeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-10);
        make.top.equalTo(self.contentLb.mas_bottom).offset(3);
        make.height.mas_equalTo(8);
    }];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
