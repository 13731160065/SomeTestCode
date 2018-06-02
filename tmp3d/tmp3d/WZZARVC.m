//
//  WZZARVC.m
//  tmp3d
//
//  Created by 王泽众 on 2018/5/30.
//  Copyright © 2018年 王泽众. All rights reserved.
//

#import "WZZARVC.h"
@import ARKit;

@interface WZZARVC ()
{
    ARSession * mainSession;
}
@property (weak, nonatomic) IBOutlet ARSCNView *arView;

@end

@implementation WZZARVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ARWorldTrackingConfiguration * worldConf = [[ARWorldTrackingConfiguration alloc] init];
    worldConf.planeDetection = ARPlaneDetectionNone;
    mainSession = [[ARSession alloc] init];
//    [mainSession runWithConfiguration:<#(nonnull ARConfiguration *)#>]
}

- (IBAction)backClick:(id)sender {
    
}

@end
