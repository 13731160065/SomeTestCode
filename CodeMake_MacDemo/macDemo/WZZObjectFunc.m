//
//  WZZObjectFunc.m
//  macDemo
//
//  Created by 王泽众 on 2018/9/12.
//  Copyright © 2018年 王泽众. All rights reserved.
//

#import "WZZObjectFunc.h"

@implementation WZZObjectFunc

- (WZZVar *)runFuncWithObject:(WZZObject *)runObject {
    self.runObject = runObject;
    return [super runFunc];
}

@end
