//
//  MemberTextFieldCell.h
//  Financeteam
//
//  Created by 张正飞 on 16/7/19.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MemberTextFieldCell : UITableViewCell<UITextFieldDelegate>
@property (nonatomic,strong) UIImageView * backgroundImage;
@property (nonatomic,strong) UITextField * customTextField;
@end
