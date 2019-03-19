//
//  payGroupThreeTableViewCell.m
//  Financeteam
//
//  Created by Zccf on 17/4/28.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import "payGroupThreeTableViewCell.h"

@implementation payGroupThreeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupView];
    }
    return self;
}
- (void)setupView {
    
    
    
    self.backgroundColor = VIEW_BASE_COLOR;
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
