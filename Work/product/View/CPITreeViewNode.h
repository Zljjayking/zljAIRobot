//
//  CPITreeViewNode.h
//  Financeteam
//
//  Created by 张正飞 on 16/6/14.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CPITreeViewNode : NSObject

@property (nonatomic) int nodeLevel; //节点所处层次
@property (nonatomic) int type; //节点类型
@property (nonatomic) id nodeData;//节点数据
@property (nonatomic) BOOL isExpanded;//节点是否展开
@property (strong,nonatomic) NSMutableArray *sonNodes;//子节点

@end
