//
//  WZZExcelSheet.h
//  WZZBaseProject
//
//  Created by 王泽众 on 2018/10/10.
//  Copyright © 2018年 王泽众. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WZZExcelSheet : NSObject

/**
 表名
 */
@property (nonatomic, strong) NSString * name;

/**
 列，列中包含行，二维数组
 */
@property (nonatomic, strong) NSMutableArray <NSMutableArray <NSString *>*>* columnArr;

/**
 列数
 */
@property (nonatomic, assign, readonly) NSUInteger column;

/**
 行数
 */
@property (nonatomic, assign, readonly) NSUInteger row;

/**
 初始化

 @param name 表明
 @return 实例
 */
+ (instancetype)sheetWithName:(NSString *)name;

/**
 添加列
 */
- (void)addOneColumn;

/**
 添加行
 
 @param dataStr 数据
 */
- (void)addOneRowToColumn:(NSUInteger)column
                  dataStr:(nullable NSString *)dataStr;

@end
