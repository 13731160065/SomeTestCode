//
//  WZZBaseValueClass.m
//  macDemo
//
//  Created by 王泽众 on 2018/9/14.
//  Copyright © 2018年 王泽众. All rights reserved.
//

#import "WZZBaseValueClass.h"

@implementation WZZBaseValueClass

- (void)setRealNumberValue:(NSNumber *)realNumberValue {
    _realNumberValue = realNumberValue;
    _realStringValue = realNumberValue.stringValue;
}

- (void)setRealStringValue:(NSString *)realStringValue {
    _realStringValue = realStringValue;
    _realNumberValue = [NSDecimalNumber decimalNumberWithString:realStringValue];
}

- (NSString *)objDesc {
    return self.realStringValue;
}

@end
