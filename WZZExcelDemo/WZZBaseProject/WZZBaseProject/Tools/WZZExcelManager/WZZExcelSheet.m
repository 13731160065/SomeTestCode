//
//  WZZExcelSheet.m
//  WZZBaseProject
//
//  Created by 王泽众 on 2018/10/10.
//  Copyright © 2018年 王泽众. All rights reserved.
//

#import "WZZExcelSheet.h"

@implementation WZZExcelSheet

+ (instancetype)sheetWithName:(NSString *)name {
    WZZExcelSheet * sheet = [[WZZExcelSheet alloc] init];
    sheet.name = name;
    sheet.columnArr = [NSMutableArray array];
    return sheet;
}

- (NSUInteger)column {
    return self.columnArr.count;
}

- (NSUInteger)row {
    NSInteger max = 0;
    for (NSArray * rowArr in self.columnArr) {
        if (rowArr.count > max) {
            max = rowArr.count;
        }
    }
    return max;
}

//MARK:添加列
- (void)addOneColumn {
    [self.columnArr addObject:[NSMutableArray array]];
}

//MARK:添加行
- (void)addOneRowToColumn:(NSUInteger)column
                  dataStr:(nullable NSString *)dataStr {
    [self.columnArr[column] addObject:dataStr?dataStr:@""];
}

@end
