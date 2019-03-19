//
//  TreeViewNode.h
//  Financeteam
//
//  Created by Zccf on 16/6/8.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TreeViewNode : NSObject
@property (nonatomic) int nodeLevel; //节点所处层次
@property (nonatomic) int type; //节点类型 1:显示textfield 2:显示button 3:显示范围
@property (nonatomic) id nodeData;//节点数据
@property (nonatomic) BOOL isExpanded;//节点是否展开
@property (strong,nonatomic) NSMutableArray *sonNodes;//子节点
@property (nonatomic, strong) NSString *ndoeName;
@end
