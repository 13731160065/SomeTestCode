//
//  WZZClass.m
//  macDemo
//
//  Created by 王泽众 on 2018/9/10.
//  Copyright © 2018年 王泽众. All rights reserved.
//

#import "WZZClass.h"
#import "WZZSPECIALHeader.h"

@implementation WZZClass

- (instancetype)init
{
    return [self initWithSuperClass:nil];
}

- (instancetype)initWithSuperClass:(WZZClass *)superClass
{
    self = [super init];
    if (self) {
        self.superClass = superClass;
        self.classFuncArray = [NSMutableArray arrayWithArray:superClass.classFuncArray];
        self.objFuncArray = [NSMutableArray arrayWithArray:self.objFuncArray];
    }
    return self;
}

+ (instancetype)classWithSuperClass:(WZZClass *)superClass
                          className:(NSString *)className {
    //父类初始化类
    WZZClass * aClass = [[WZZClass alloc] initWithSuperClass:superClass];
    
    //类名
    aClass.className = className;
    
    //方法继承
    NSMutableArray * funcArr = [NSMutableArray array];
    for (WZZFunc * func in aClass.superClass.objFuncArray) {
        if (func.power == WZZSPECIALManager_Power_Public ||
            func.power == WZZSPECIALManager_Power_Protected ) {
            //继承
            [funcArr addObject:func];
        }
    }
    
    //属性继承
    NSMutableArray * propertyArr = [NSMutableArray array];
    for (WZZProperty * property in aClass.superClass.propertyArray) {
        if (property.power == WZZSPECIALManager_Power_Public ||
            property.power == WZZSPECIALManager_Power_Protected ) {
            //继承
            [propertyArr addObject:property];
        }
    }
    
    return aClass;
}

- (NSDictionary *)makeCode:(WZZSPECIALManager_CodeType)codeType {
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    switch (codeType) {
        case WZZSPECIALManager_CodeType_OC:
        {
            //.h
            NSMutableString * hstr = [NSMutableString string];
            //头部注释
            [hstr appendFormat:@
             "//\n"
             "//  %@.h\n"
             "//  %@\n"
             "//\n"
             "//  Created by %@ on 2018/9/10.\n"
             "//  Copyright © %@. All rights reserved.\n"
             "//\n"
             "\n",
             self.className,
             [WZZSPECIALManager shareInstance].projectName,
             [WZZSPECIALManager shareInstance].userName,
             [WZZSPECIALManager shareInstance].aCopyRight];
            
            //类开始
            [hstr appendFormat:@
             "@interface %@ : %@",
             self.className,
             self.superClass.className];
            
            
            
            //类结束
            [hstr appendFormat:@
             "@end\n"
             "\n"];
            
            //.m
            NSMutableString * mstr = [NSMutableString string];
            //头部注释
            [mstr appendFormat:@
             "//\n"
             "//  %@.m\n"
             "//  %@\n"
             "//\n"
             "//  Created by %@ on 2018/9/10.\n"
             "//  Copyright © %@. All rights reserved.\n"
             "//\n"
             "\n"
             "#import \"%@.h\"",
             self.className,
             [WZZSPECIALManager shareInstance].projectName,
             [WZZSPECIALManager shareInstance].userName,
             [WZZSPECIALManager shareInstance].aCopyRight,
             self.className];
            
            [mstr appendFormat:@
             "@implementation %@\n",
             self.className];
            
            //类结束
            [mstr appendFormat:@
             "@end\n"
             "\n"];
            
            
        }
            break;
            
        default:
            break;
    }
    
    return dic;
}

@end
