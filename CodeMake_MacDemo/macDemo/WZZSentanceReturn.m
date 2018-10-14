//
//  WZZSentanceReturn.m
//  macDemo
//
//  Created by 王泽众 on 2018/9/12.
//  Copyright © 2018年 王泽众. All rights reserved.
//

#import "WZZSentanceReturn.h"

@implementation WZZSentanceReturn

+ (instancetype)returnVar:(WZZVar *)returnVar {
    WZZSentanceReturn * sent = [[WZZSentanceReturn alloc] init];
    sent.returnVar = returnVar;
    return sent;
}

- (id)runSentance {
    return self.returnVar;
}

@end
