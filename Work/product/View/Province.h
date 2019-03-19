








#import <Foundation/Foundation.h>
#import "City.h"
@interface Province : NSObject
@property (nonatomic) NSInteger provinceId;
@property (nonatomic,strong) NSString * provinceName;
@property (nonatomic,strong) NSMutableArray* cityArray;
+(id)requestWithDic:(NSDictionary*)dic;

@end
