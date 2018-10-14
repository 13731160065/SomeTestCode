//
//  WZZSentanceLogic.m
//  macDemo
//
//  Created by 王泽众 on 2018/9/12.
//  Copyright © 2018年 王泽众. All rights reserved.
//

#import "WZZSentanceLogic.h"
#import "WZZSPECIALHeader.h"

@implementation WZZSentanceLogic

+ (instancetype)sentanceWithObjA:(id)objA
                       logicType:(WZZSentanceLogic_Type)logicType
                            objB:(id)objB {
    WZZSentanceLogic * logic = [[WZZSentanceLogic alloc] init];
    logic.objA = objA;
    logic.objB = objB;
    logic.logicType = logicType;
    return logic;
}

- (id)runSentance {
    switch (self.logicType) {
        case WZZSentanceLogic_Type_Or:
        {
            //或
            if ([self.objA isKindOfClass:[WZZNumber class]] && [self.objB isKindOfClass:[WZZNumber class]]) {
                WZZNumber * aa = self.objA;
                WZZNumber * bb = self.objB;
                BOOL boolValue = NO;
                if (aa.realNumber.integerValue || bb.realNumber.integerValue) {
                    boolValue = YES;
                }
                WZZNumber * boolN = [WZZNumber numberWithNumber:@(boolValue) type:WZZNumber_Type_Bool];
                return boolN;
            }
        }
            break;
        case WZZSentanceLogic_Type_And:
        {
            //且
            if ([self.objA isKindOfClass:[WZZNumber class]] && [self.objB isKindOfClass:[WZZNumber class]]) {
                WZZNumber * aa = self.objA;
                WZZNumber * bb = self.objB;
                BOOL boolValue = NO;
                if (aa.realNumber.integerValue && bb.realNumber.integerValue) {
                    boolValue = YES;
                }
                WZZNumber * boolN = [WZZNumber numberWithNumber:@(boolValue) type:WZZNumber_Type_Bool];
                return boolN;
            }
        }
            break;
        case WZZSentanceLogic_Type_Not:
        {
            //非
            if ([self.objA isKindOfClass:[WZZNumber class]]) {
                WZZNumber * aa = self.objA;
                BOOL boolValue = !aa.realNumber.integerValue;
                WZZNumber * boolN = [WZZNumber numberWithNumber:@(boolValue) type:WZZNumber_Type_Bool];
                return boolN;
            }
        }
            break;
        case WZZSentanceLogic_Type_Equal:
        {
            //等对比
            if ([self.objA isKindOfClass:[WZZNumber class]] && [self.objB isKindOfClass:[WZZNumber class]]) {
                WZZNumber * aa = self.objA;
                WZZNumber * bb = self.objB;
                BOOL boolValue = [aa.realNumber isEqualToNumber:bb.realNumber];
                WZZNumber * boolN = [WZZNumber numberWithNumber:@(boolValue) type:WZZNumber_Type_Bool];
                return boolN;
            } else if ([self.objA isKindOfClass:[WZZString class]] && [self.objB isKindOfClass:[WZZString class]]) {
                WZZString * aa = self.objA;
                WZZString * bb = self.objB;
                BOOL boolValue = [aa.string isEqualToString:bb.string];
                WZZNumber * boolN = [WZZNumber numberWithNumber:@(boolValue) type:WZZNumber_Type_Bool];
                return boolN;
            }
        }
            break;
        case WZZSentanceLogic_Type_NotEqual:
        {
            //不等
            if ([self.objA isKindOfClass:[WZZNumber class]] && [self.objB isKindOfClass:[WZZNumber class]]) {
                WZZNumber * aa = self.objA;
                WZZNumber * bb = self.objB;
                BOOL boolValue = [aa.realNumber isEqualToNumber:bb.realNumber];
                WZZNumber * boolN = [WZZNumber numberWithNumber:@(!boolValue) type:WZZNumber_Type_Bool];
                return boolN;
            } else if ([self.objA isKindOfClass:[WZZString class]] && [self.objB isKindOfClass:[WZZString class]]) {
                WZZString * aa = self.objA;
                WZZString * bb = self.objB;
                BOOL boolValue = [aa.string isEqualToString:bb.string];
                WZZNumber * boolN = [WZZNumber numberWithNumber:@(!boolValue) type:WZZNumber_Type_Bool];
                return boolN;
            }
        }
            break;
        case WZZSentanceLogic_Type_Big:
        {
            //大于
            if ([self.objA isKindOfClass:[WZZNumber class]] && [self.objB isKindOfClass:[WZZNumber class]]) {
                WZZNumber * aa = self.objA;
                WZZNumber * bb = self.objB;
                BOOL boolValue = [aa.realNumber isGreaterThan:bb.realNumber];
                WZZNumber * boolN = [WZZNumber numberWithNumber:@(boolValue) type:WZZNumber_Type_Bool];
                return boolN;
            } else if ([self.objA isKindOfClass:[WZZString class]] && [self.objB isKindOfClass:[WZZString class]]) {
                WZZString * aa = self.objA;
                WZZString * bb = self.objB;
                BOOL boolValue = [aa.string isGreaterThan:bb.string];
                WZZNumber * boolN = [WZZNumber numberWithNumber:@(boolValue) type:WZZNumber_Type_Bool];
                return boolN;
            }
        }
            break;
        case WZZSentanceLogic_Type_BigEqual:
        {
            //大于等于
            if ([self.objA isKindOfClass:[WZZNumber class]] && [self.objB isKindOfClass:[WZZNumber class]]) {
                WZZNumber * aa = self.objA;
                WZZNumber * bb = self.objB;
                BOOL boolValue = [aa.realNumber isGreaterThanOrEqualTo:bb.realNumber];
                WZZNumber * boolN = [WZZNumber numberWithNumber:@(boolValue) type:WZZNumber_Type_Bool];
                return boolN;
            } else if ([self.objA isKindOfClass:[WZZString class]] && [self.objB isKindOfClass:[WZZString class]]) {
                WZZString * aa = self.objA;
                WZZString * bb = self.objB;
                BOOL boolValue = [aa.string isGreaterThanOrEqualTo:bb.string];
                WZZNumber * boolN = [WZZNumber numberWithNumber:@(boolValue) type:WZZNumber_Type_Bool];
                return boolN;
            }
        }
            break;
        case WZZSentanceLogic_Type_Small:
        {
            //小于
            if ([self.objA isKindOfClass:[WZZNumber class]] && [self.objB isKindOfClass:[WZZNumber class]]) {
                WZZNumber * aa = self.objA;
                WZZNumber * bb = self.objB;
                BOOL boolValue = [aa.realNumber isLessThan:bb.realNumber];
                WZZNumber * boolN = [WZZNumber numberWithNumber:@(boolValue) type:WZZNumber_Type_Bool];
                return boolN;
            } else if ([self.objA isKindOfClass:[WZZString class]] && [self.objB isKindOfClass:[WZZString class]]) {
                WZZString * aa = self.objA;
                WZZString * bb = self.objB;
                BOOL boolValue = [aa.string isLessThan:bb.string];
                WZZNumber * boolN = [WZZNumber numberWithNumber:@(boolValue) type:WZZNumber_Type_Bool];
                return boolN;
            }
        }
            break;
        case WZZSentanceLogic_Type_SmallEqual:
        {
            //小于等于
            if ([self.objA isKindOfClass:[WZZNumber class]] && [self.objB isKindOfClass:[WZZNumber class]]) {
                WZZNumber * aa = self.objA;
                WZZNumber * bb = self.objB;
                BOOL boolValue = [aa.realNumber isLessThanOrEqualTo:bb.realNumber];
                WZZNumber * boolN = [WZZNumber numberWithNumber:@(boolValue) type:WZZNumber_Type_Bool];
                return boolN;
            } else if ([self.objA isKindOfClass:[WZZString class]] && [self.objB isKindOfClass:[WZZString class]]) {
                WZZString * aa = self.objA;
                WZZString * bb = self.objB;
                BOOL boolValue = [aa.string isLessThanOrEqualTo:bb.string];
                WZZNumber * boolN = [WZZNumber numberWithNumber:@(boolValue) type:WZZNumber_Type_Bool];
                return boolN;
            }
        }
            break;
            
        default:
            break;
    }
    
    return nil;
}

@end
