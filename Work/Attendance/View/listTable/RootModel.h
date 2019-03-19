//
//  RootModel.h

#import <Foundation/Foundation.h>

@interface RootModel : NSObject

@property (nonatomic,copy) NSString *Id;//主键

@property (nonatomic,copy) NSString *DelFlag;//是否废弃

@property (nonatomic,copy) NSString *CreateMan;//创建人改为单位

@property (nonatomic,copy) NSString *CreateTime;//创建时间

@property (nonatomic,copy) NSString *indexStr;  //标记

@property (nonatomic,assign) BOOL isSeleted;

@property (nonatomic,copy) NSString *showString;

@property (nonatomic,copy) NSString *PinYinFirstCode;

@end
