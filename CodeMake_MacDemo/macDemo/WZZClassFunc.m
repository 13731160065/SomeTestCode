//
//  WZZClassFunc.m
//  macDemo
//
//  Created by 王泽众 on 2018/9/12.
//  Copyright © 2018年 王泽众. All rights reserved.
//

#import "WZZClassFunc.h"

@implementation WZZClassFunc

- (WZZVar *)runFuncWithClass:(WZZClass *)runClass {
    self.runClass = runClass;
    return [super runFunc];
}

@end
