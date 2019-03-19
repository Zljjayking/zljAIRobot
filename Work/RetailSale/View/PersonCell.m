//
//  PersonCell.m
//  BM
//
//  Created by yuhuajun on 15/7/13.
//  Copyright (c) 2015年 yuhuajun. All rights reserved.
//

#import "PersonCell.h"
#import "CDFInitialsAvatar.h"
@implementation PersonCell


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"cellviewbackground"]];
        
        _tximg=[[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 40,40)];
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
        
        
        _txtName=[[UILabel alloc]initWithFrame:CGRectMake(70, 10, 160, 25)];
        _txtName.font=[UIFont fontWithName:@"STHeitiTC-Light" size:16];
        
        [self.contentView addSubview:_txtName];
        
        _phoneNum=[[UILabel alloc]initWithFrame:CGRectMake(70, 30, 160, 25)];
        _phoneNum.font=[UIFont fontWithName:@"STHeitiTC-Light" size:13];
        [self.contentView addSubview:_phoneNum];
        self.txImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"头像"]];
        [_tximg addSubview:self.txImage];
        [self.txImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_tximg.mas_centerX);
            make.centerY.equalTo(_tximg.mas_centerY);
            make.width.mas_equalTo(25);
            make.height.mas_equalTo(25);
        }];
    }
    return self;
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
-(void)setData:(JXPersonInfo*)personDel;
{
    _txtName.text=personDel.fullName;
    NSArray *bb = personDel.phone;
    if (bb.count>0) {
        NSArray *aa = [personDel.phone[0] allObjects];
        if (aa.count >0) {
            NSString *phoneStr = [[personDel.phone[0] allObjects][0] stringByReplacingOccurrencesOfString:@" " withString:@""];
            phoneStr = [phoneStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
            _phoneNum.text=phoneStr;
            [self setTxcolorAndTitle:personDel.fullName title:phoneStr];
        }
    } else {
        _phoneNum.text=@"暂无联系方式";
    }
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
