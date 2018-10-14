//
//  WZZSentanceCreateVar.m
//  macDemo
//
//  Created by 王泽众 on 2018/9/12.
//  Copyright © 2018年 王泽众. All rights reserved.
//

#import "WZZSentanceCreateVar.h"
#import "WZZSPECIALHeader.h"

@implementation WZZSentanceCreateVar

//MARK:创建变量语句
+ (instancetype)sentanceWithClass:(WZZClass *)aClass
                          varName:(NSString *)varName
                         varValue:(WZZObject *)aObj {
    WZZSentanceCreateVar * varSent = [[WZZSentanceCreateVar alloc] init];
    varSent.pointClass = aClass;
    varSent.varValue = aObj;
    varSent.varName = varName;
    return varSent;
}

//MARK:执行语句
- (id)runSentance {
    WZZVar * var = [[WZZVar alloc] init];
    var.name = self.varName;
    var.pointClass = self.pointClass;
    var.varValue = self.varValue;
    return var;
}

@end
