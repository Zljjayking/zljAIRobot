//
//  RootModel.m
//  PrecisionExperiment
//
//  Copyright © 2016年 张帅 All rights reserved.
//

#import "RootModel.h"
/*
 基础模型类
 只作为父类
 
 */
@implementation RootModel
- (id)init{
    self = [super init];
    if (self) {
        _indexStr = @"";
        _isSeleted = NO;
        _DelFlag = @"";
        _CreateMan=@"";
    }
    return self;
}

////重载选择 使用的LKDBHelper
//+(LKDBHelper *)getUsingLKDBHelper
//{
//    static LKDBHelper* db;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        db = [[LKDBHelper alloc]init];
//    });
//    return db;
//}
//
//+(void)dbDidAlterTable:(LKDBHelper *)helper tableName:(NSString *)tableName addColumns:(NSArray *)columns
//{
//    for (int i=0; i<columns.count; i++)
//    {
//        LKDBProperty* p = [columns objectAtIndex:i];
//        if([p.propertyName isEqualToString:@"error"])
//        {
//            [helper executeDB:^(FMDatabase *db) {
//                NSString* sql = [NSString stringWithFormat:@"update %@ set error = name",tableName];
//                [db executeUpdate:sql];
//            }];
//        }
//    }
//    LKErrorLog(@"your know %@",columns);
//}
//
//// 将要插入数据库
//+(BOOL)dbWillInsert:(NSObject *)entity
//{
//    LKErrorLog(@"will insert : %@",NSStringFromClass(self));
//    return YES;
//}
////已经插入数据库
//+(void)dbDidInserted:(NSObject *)entity result:(BOOL)result
//{
//    LKErrorLog(@"did insert : %@",NSStringFromClass(self));
//}
//
////手动or自动 绑定sql列
//+(NSDictionary *)getTableMapping
//{
//    return nil;
//}
//
//+ (NSString *)getPrimaryKey{
//    return @"rowid";
//}
//
//+ (NSString *)getTableName{
//    return @"RootModelTable";
//}

@end
