//
//  WZZCalParamVC.m
//  tmp3d
//
//  Created by 王泽众 on 2018/5/28.
//  Copyright © 2018年 王泽众. All rights reserved.
//

#import "WZZCalParamVC.h"
#import "WZZShapeHandler.h"
#import "WZZWindowDataHandler.h"
#import "WZZHttpTool.h"

@interface WZZCalParamVC ()

@property (weak, nonatomic) IBOutlet UITextView *mainTextView;
@property (weak, nonatomic) IBOutlet UIImageView *mainImageView;
@end

@implementation WZZCalParamVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_mainImageView setImage:_image];
    [_mainImageView setContentMode:UIViewContentModeScaleAspectFit];
    _mainImageView.layer.borderColor = [UIColor blackColor].CGColor;
    _mainImageView.layer.borderWidth = 1.0f;
    
    [[WZZWindowDataHandler shareInstance] getRectAllBorderData:^(id borderData) {
        _mainTextView.text = [NSString stringWithFormat:@"\n压线尺寸:\n%@\n玻璃尺寸:\n%@\n中挺尺寸:\n%@\n扇尺寸:%@", borderData[@"yaxian"], borderData[@"boli"], borderData[@"zhongting"], borderData[@"shan"]];
//        _mainTextView.text = [NSString stringWithFormat:@"%@\n\njson数据:%@", _mainTextView.text, [self jsonFromObject:borderData]];
        
        NSMutableArray * yaXianArr = [NSMutableArray arrayWithArray:borderData[@"yaxian"]];
//        NSMutableArray * boliArr = [NSMutableArray arrayWithArray:borderData[@"boli"]];
        NSMutableArray * zhongTingArr = [NSMutableArray arrayWithArray:borderData[@"zhongting"]];
        NSMutableArray * kuangArr = [NSMutableArray arrayWithArray:borderData[@"kuang"]];
        NSMutableArray * shanArr = [NSMutableArray array];
        [borderData[@"shan"] enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [yaXianArr addObjectsFromArray:obj[@"shan_yaxian"]];
            [shanArr addObjectsFromArray:obj[@"shan"]];
        }];
        
        NSMutableDictionary * reqDic = [NSMutableDictionary dictionary];
        reqDic[@"yaxian"] = yaXianArr;
        reqDic[@"ting"] = zhongTingArr;
        reqDic[@"kuang"] = kuangArr;
        reqDic[@"shan"] = shanArr;
        
        NSString * data = [WZZHttpTool objectToJson:reqDic];
        
        [WZZHttpTool GET:@"http://192.168.0.27:8080/ReportForm/export.do" urlParamDic:@{@"data":data} successBlock:^(id httpResponse) {

        } failedBlock:^(NSError *httpError) {

        }];
    }];
    
    NSDictionary * makerDic = [WZZWindowDataHandler getAllMakerData];
    _mainTextView.text = [NSString stringWithFormat:@"%@\n\n全部数据字典:%@", _mainTextView.text, makerDic];
    [[NSUserDefaults standardUserDefaults] setObject:makerDic forKey:@"makerDic"];
}

//对象转json
- (NSString *)jsonFromObject:(id)obj {
    if (obj == nil) {
        return nil;
    }
    NSError * err;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj options:0 error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

- (IBAction)closeClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
