//
//  WZZChangeTextureVC.m
//  tmp3d
//
//  Created by 王泽众 on 2018/5/28.
//  Copyright © 2018年 王泽众. All rights reserved.
//

#import "WZZChangeTextureVC.h"
#import "WZZShapeHandler.h"

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
            [WZZShapeHandler shareInstance].borderTexture = @"lvhejin.jpg";
        }
            break;
        case 1:
        {
            [WZZShapeHandler shareInstance].borderTexture = @"mucai005.jpg";
        }
            break;
        case 2:
        {
            [WZZShapeHandler shareInstance].borderTexture = @"metal.jpg";
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
