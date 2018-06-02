//
//  WZZChangeFillVC.m
//  tmp3d
//
//  Created by 王泽众 on 2018/5/28.
//  Copyright © 2018年 王泽众. All rights reserved.
//

#import "WZZChangeFillVC.h"
#import "WZZShapeHandler.h"
#import "WZZTextureFillNode.h"
#import "WZZShanFillNode.h"

@interface WZZChangeFillVC ()

@end

@implementation WZZChangeFillVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)segClick:(UISegmentedControl *)sender {
    switch (sender.selectedSegmentIndex) {
        case 0:
        {
            [WZZShapeHandler shareInstance].insideContentType = WZZInsideNodeContentType_Fill_Texture_Glass;
        }
            break;
        case 1:
        {
            [WZZShapeHandler shareInstance].insideContentType = WZZInsideNodeContentType_Fill_Shan_NormalShan;
        }
            break;
        case 2:
        {
            [WZZShapeHandler shareInstance].insideContentType = WZZInsideNodeContentType_Turn;
        }
            break;
            
        default:
            break;
    }
    if (_textureBlock) {
        _textureBlock([sender titleForSegmentAtIndex:sender.selectedSegmentIndex]);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)closeClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
