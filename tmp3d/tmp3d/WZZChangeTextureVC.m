//
//  WZZChangeTextureVC.m
//  tmp3d
//
//  Created by 王泽众 on 2018/5/28.
//  Copyright © 2018年 王泽众. All rights reserved.
//

#import "WZZChangeTextureVC.h"
#import "WZZShapeHandler.h"
#import "WZZWindowDataHandler.h"

@interface WZZChangeTextureVC ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *segView;

@end

@implementation WZZChangeTextureVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

- (IBAction)changeClick:(UISegmentedControl *)sender {
    switch (sender.selectedSegmentIndex) {
        case 0:
        {
            [WZZWindowDataHandler shareInstance].borderTexture = @"lvhejin.jpg";
        }
            break;
        case 1:
        {
            [WZZWindowDataHandler shareInstance].borderTexture = @"mucai005.jpg";
        }
            break;
        case 2:
        {
            [WZZWindowDataHandler shareInstance].borderTexture = @"metal.jpg";
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
