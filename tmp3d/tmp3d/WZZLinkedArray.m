//
//  WZZLinkedArray.m
//  tmp3d
//
//  Created by 王泽众 on 2018/5/24.
//  Copyright © 2018年 王泽众. All rights reserved.
//

#import "WZZLinkedArray.h"

@implementation WZZLinkedArray

+ (instancetype)arrayWithArray:(NSArray *)array {
    if (!array.count) {
        return nil;
    }
    
    //重构
    NSMutableArray * okArr = [NSMutableArray array];
    for (int i = 0; i < array.count; i++) {
        WZZLinkedObject * obj = [[WZZLinkedObject alloc] init];
        obj.thisObj = array[i];
        obj.indexType = WZZLinkedObject_Index_Middle;
        if (i == 0) {
            obj.indexType = WZZLinkedObject_Index_First;
        }
        if (i == array.count-1) {
            obj.indexType = WZZLinkedObject_Index_Last;
        }
        [okArr addObject:obj];
    }
    
    //链接
    NSMutableArray * arr = [NSMutableArray arrayWithArray:okArr];
    id objl = [arr lastObject];
    id objf = [arr firstObject];
    [arr addObject:objf];
    [arr insertObject:objl atIndex:0];
    
    for (int i = 1; i < arr.count-1; i++) {
        WZZLinkedObject * obj = arr[i];
        obj.lastObj = arr[i-1];
        obj.nextObj = arr[i+1];
    }
    
    WZZLinkedArray * link = [[WZZLinkedArray alloc] init];
    link.array = [NSArray arrayWithArray:okArr];
    return link;
}

@end

@implementation WZZLinkedObject

@end
