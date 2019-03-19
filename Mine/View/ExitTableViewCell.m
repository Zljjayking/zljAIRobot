//
//  ExitTableViewCell.m
//  Financeteam
//
//  Created by Zccf on 16/5/16.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "ExitTableViewCell.h"

@implementation ExitTableViewCell
static NSString *identifier = @"exit";
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)cellWithTableView:(UITableView *)tableView {
    
    // 1.缓存中取
    ExitTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    // 2.创建
    if (cell == nil) {
        cell = [[ExitTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupView];
    }
    return self;
}
- (void)setupView {
    self.InfoImage = [[UIImageView alloc]init];
    [self addSubview:self.InfoImage];
    self.InfoImage.layer.masksToBounds = YES;
    [self.InfoImage.layer setCornerRadius:5];
    [self.InfoImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(7);
        make.left.equalTo(self.mas_left).offset(12);
        make.bottom.equalTo(self.mas_bottom).offset(-7);
        make.width.mas_equalTo(55);
    }];
    
    self.InfoLB = [[UILabel alloc] init];
    [self addSubview:self.InfoLB];
    self.InfoLB.font = [UIFont systemFontOfSize:13];
    [self.InfoLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(28);
        make.left.equalTo(self.InfoImage.mas_right).offset(10);
        make.height.mas_equalTo(13);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
