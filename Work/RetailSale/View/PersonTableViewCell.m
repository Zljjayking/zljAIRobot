//
//  PersonTableViewCell.m
//  Financeteam
//
//  Created by Zccf on 16/9/1.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "PersonTableViewCell.h"
#import "CDFInitialsAvatar.h"
@implementation PersonTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initUIs];
    }
    return self;
}
- (void)initUIs {
    self.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"cellviewbackground"]];
    
    self.tximg=[[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 40,40)];
    [self.contentView addSubview:_tximg];
    
    CDFInitialsAvatar *topAvatar = [[CDFInitialsAvatar alloc] initWithRect:_tximg.bounds fullName:@""];
    topAvatar.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"tx_five"]];
    topAvatar.initialsFont=[UIFont fontWithName:@"STHeitiTC-Light" size:14];
    CALayer *mask = [CALayer layer]; // this will become a mask for UIImageView
    UIImage *maskImage = [UIImage imageNamed:@"AvatarMask"]; // circle, in this case
    mask.contents = (id)[maskImage CGImage];
    mask.frame = _tximg.bounds;
    _tximg.layer.mask = mask;
    //_tximg.layer.cornerRadius = YES;
    _tximg.image = topAvatar.imageRepresentation;
    _topAvatar=topAvatar;
    
    _txtName=[[UILabel alloc]init];
    _txtName.font=[UIFont fontWithName:@"STHeitiTC-Light" size:17];
    [self.contentView addSubview:_txtName];
    [_txtName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_tximg.mas_right).offset(15);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    _phoneNum=[[UILabel alloc]init];
    _phoneNum.font=[UIFont fontWithName:@"STHeitiTC-Light" size:14];
    [self.contentView addSubview:_phoneNum];
    [_phoneNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_txtName.mas_right).offset(10);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    _stateLB = [[UILabel alloc]init];
    _stateLB.textAlignment = NSTextAlignmentRight;
    _stateLB.font=[UIFont fontWithName:@"STHeitiTC-Light" size:14];
    [self.contentView addSubview:_stateLB];
    [_stateLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-10);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    self.txImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"头像"]];
    [_tximg addSubview:self.txImage];
    [self.txImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_tximg.mas_centerX);
        make.centerY.equalTo(_tximg.mas_centerY);
        make.width.mas_equalTo(25);
        make.height.mas_equalTo(25);
    }];
    
}
-(void)setTxcolorAndTitle:(NSString*)title title:(NSString*)fid
{
    NSArray *tximgLis=@[@"tx_one",@"tx_two",@"tx_three",@"tx_four",@"tx_five"];
    NSString *strImg;
    if(fid.length!=0)//利用号码不同来随机颜色
    {
        NSString *strCarc= fid.length<7? [fid substringToIndex:fid.length]:[fid substringToIndex:7];
        int allnum=[strCarc intValue];
        strImg=tximgLis[allnum%5];
    }else
    {
        strImg=tximgLis[0];
    }
    
    if(title.length <= 2)
    {
        title= title;
    }else
    {
        title= [title substringWithRange:NSMakeRange(title.length - 2, 2)];
    }
    
    CDFInitialsAvatar *topAvatar = [[CDFInitialsAvatar alloc] initWithRect:_tximg.bounds fullName:title];
    
    topAvatar.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:strImg]];
    
    topAvatar.initialsFont=[UIFont fontWithName:@"STHeitiTC-Light" size:14];
    CALayer *mask = [CALayer layer]; // this will become a mask for UIImageView
    UIImage *maskImage = [UIImage imageNamed:@"AvatarMask"]; // circle, in this case
    mask.contents = (id)[maskImage CGImage];
    mask.frame = _tximg.bounds;
    _tximg.layer.mask = mask;
    _tximg.layer.cornerRadius = YES;
    _tximg.image = topAvatar.imageRepresentation;
    _topAvatar=topAvatar;
    
}
-(void)setData:(PersonModel*)personDel;
{
    NSString *nameStr=[personDel.nameStr  stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSString *phoneStr = [personDel.phoneStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    phoneStr = [phoneStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    NSString *stateStr = [NSString stringWithFormat:@"%@",personDel.callStateStr];
    
    if (nameStr.length == 0) {
        self.txtName.text = phoneStr;
        self.phoneNum.text=@"";
    } else {
        self.txtName.text = [NSString stringWithFormat:@"%@",nameStr];
        self.phoneNum.text=phoneStr;
    }
    
    if ([stateStr isEqualToString:@"1"]) {
        self.stateLB.text = @"已呼叫";
        self.stateLB.textColor = TABBAR_BASE_COLOR;
    } else if ([stateStr isEqualToString:@"0"]) {
        self.stateLB.text = @"呼叫失败";
        self.stateLB.textColor = [UIColor redColor];
    } else if ([stateStr isEqualToString:@"2"]){
        self.stateLB.text = @"未接通";
        self.stateLB.textColor = [UIColor redColor];
    } else {
        self.stateLB.text = @"未拨打";
        self.stateLB.textColor = [UIColor grayColor];
    }
    
    [self setTxcolorAndTitle:nameStr title:phoneStr];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
