//
//  AvilableTableViewCell.m
//  Financeteam
//
//  Created by Zccf on 16/5/18.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "AvilableTableViewCell.h"

@implementation AvilableTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        self.avilablePersonNameArr = [NSMutableArray array];
//        [self.avilablePersonNameArr addObject:@" "];
//        self.avilablePersonImageArr = [NSMutableArray array];
//        [self.avilablePersonImageArr addObject:@"增加群聊（大加）"];
//        [self setupView];
    }
    return self;
}
-(void)setupView {
    self.MyDelegate = [UIApplication sharedApplication].delegate;
    NSLog(@"self.avilablePersonNameArr.count = %ld",self.avilablePersonNameArr.count);
    for (int i=0; i < self.avilablePersonNameArr.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        NSString *imagePath = [NSString stringWithFormat:@"%@%@",PHOTO_ADDRESS,self.avilablePersonImageArr[i]];
                        NSURL *imageURL = [NSURL URLWithString:imagePath];
        
        if (i==self.avilablePersonNameArr.count-1) {
            btn.imageView.image = [UIImage imageNamed:self.avilablePersonImageArr[i]];
        } else {
            [btn.imageView sd_setImageWithURL:imageURL completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            }];
        
        }
        btn.titleLabel.text = self.avilablePersonNameArr[i];
        [self addSubview:btn];
        btn.frame = CGRectMake(i*60, 0, 40, 40);

        
//        [self addSubview:btn];
//        if (i != self.avilablePersonImageArr.count - 1) {
//            NSString *imagePath = [NSString stringWithFormat:@"%@/%@",PHOTO_ADDRESS,self.avilablePersonImageArr[i]];
//            NSURL *imageURL = [NSURL URLWithString:imagePath];
//            [btn.imageView sd_setImageWithURL:imageURL completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//            }];
//            
//        } else {
//            btn.imageView.image = [UIImage imageNamed:self.avilablePersonImageArr[i]];
//        }
//        btn.tag = i+1000;
//        btn.titleLabel.text = self.avilablePersonNameArr[i];
//        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.mas_top).offset(i/6 * 68+6);
//            make.left.equalTo(self.mas_left).offset(i * (kScreenWidth-12)/6 + 12);
//            make.width.mas_equalTo(52);
//            make.height.mas_equalTo(62);
//        }];
//        if (i == self.avilablePersonImageArr.count - 1) {
//            [btn.deleteBtn setHidden:YES];
//        }
    }
//    self.AvailableCollection = [[UICollectionView alloc] init];
//    self.AvailableCollection.collectionViewLayout = [[UICollectionViewFlowLayout alloc]init];
//    [self addSubview:self.AvailableCollection];
//    [self.AvailableCollection mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.mas_left).offset(0);
//        make.right.equalTo(self.mas_right).offset(0);
//        make.top.equalTo(self.mas_top).offset(0);
//        make.bottom.equalTo(self.mas_bottom).offset(0);
//        make.centerY.mas_equalTo(self.mas_centerY);
//    }];
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
