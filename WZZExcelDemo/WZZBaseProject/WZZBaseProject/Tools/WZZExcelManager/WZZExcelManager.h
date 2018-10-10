//
//  WZZExcelManager.h
//  WZZBaseProject
//
//  Created by 王泽众 on 2018/10/10.
//  Copyright © 2018年 王泽众. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WZZExcelSheet.h"

@interface WZZExcelManager : NSObject

/**
 表格
 */
@property (nonatomic, strong) NSArray <WZZExcelSheet *>* sheetArr;


/**
 初始化
 */
+ (instancetype)excel;

/**
 保存文件

 @param filePath 文件路径
 @param complete 完成回调
 */
- (void)saveAsFile:(NSString *)filePath
          complete:(void(NS_NOESCAPE^)(BOOL isOK, NSURL * fileUrl))complete;

@end
