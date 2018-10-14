//
//  WZZSentancePutVar.m
//  macDemo
//
//  Created by 王泽众 on 2018/9/12.
//  Copyright © 2018年 王泽众. All rights reserved.
//

#import "WZZSentancePutVar.h"
#import "WZZSPECIALHeader.h"

@implementation WZZSentancePutVar

//MARK:创建赋值语句
+ (instancetype)sentanceWithName:(WZZVar *)aVar
                        varValue:(WZZObject *)varValue {
    WZZSentancePutVar * putVar = [[WZZSentancePutVar alloc] init];
    putVar.aVar = aVar;
    putVar.varValue = varValue;
    return putVar;
}

//MARK:执行
- (id)runSentance {
    self.aVar.varValue = self.varValue;
    return self.aVar;
}

@end
