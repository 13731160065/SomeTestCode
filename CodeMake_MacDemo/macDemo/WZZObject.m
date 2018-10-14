//
//  WZZObject.m
//  macDemo
//
//  Created by 王泽众 on 2018/9/10.
//  Copyright © 2018年 王泽众. All rights reserved.
//

#import "WZZObject.h"
#import "WZZSPECIALHeader.h"

@implementation WZZObject

+ (instancetype)objectWithRealClass:(WZZClass *)aClass {
    WZZObject * obj = [[WZZObject alloc] init];
    obj->_realClass = aClass;
    return obj;
}

- (NSMutableArray<WZZProperty *> *)propertyArray {
    return _realClass.propertyArray;
}

- (NSMutableArray<WZZFunc *> *)objFuncArray {
    return _realClass.objFuncArray;
}

@end
