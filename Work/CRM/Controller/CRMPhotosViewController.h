//
//  CRMPhotosViewController.h
//  Financeteam
//
//  Created by Zccf on 16/9/12.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "BaseViewController.h"
#import "CRMDetailsModel.h"
typedef void (^ReturnPhotoBlock)(CRMDetailsModel *photoModel);
@interface CRMPhotosViewController : BaseViewController
@property (nonatomic, strong) CRMDetailsModel *PhotoModel;
@property (nonatomic,assign) BOOL isUpdateCRM;
@property (nonatomic,copy) ReturnPhotoBlock returnPhotoBlock;
- (void)returnPhoto:(ReturnPhotoBlock)block;
@end
