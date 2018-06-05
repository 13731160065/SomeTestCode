//
//  ViewController.m
//  tmp3d
//
//  Created by 王泽众 on 2018/5/16.
//  Copyright © 2018年 王泽众. All rights reserved.
//

#import "ViewController.h"
#import "WZZARManager.h"
#import "WZZWindowNode.h"
#import "WZZ2DButtonNode.h"
#import "WZZShapeHandler.h"
#import "DoorWindowCalculationFormulaObjective.h"

#import "WZZSettingParamVC.h"
#import "WZZCalParamVC.h"
#import "WZZChangeTextureVC.h"
#import "WZZChangeFillVC.h"

@import UIKit;
@import SceneKit;

typedef struct {
    float x, y, z;    // position
    float nx, ny, nz; // normal
    float s, t;       // texture coordinates
} AAPLVertex;

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    SCNScene * mainScene;
    NSMutableArray * dataArr;
    SCNView * mainSCNV;
}
@property (weak, nonatomic) IBOutlet UIView *upView;
@property (weak, nonatomic) IBOutlet UITextField *widTF;
@property (weak, nonatomic) IBOutlet UITextField *heiTF;
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (weak, nonatomic) IBOutlet UIButton *arButton;
@property (weak, nonatomic) IBOutlet UISwitch *hvSwitch;
@property (weak, nonatomic) IBOutlet UISegmentedControl *actionSeg;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    dataArr = [NSMutableArray array];
    [dataArr addObject:[NSMutableDictionary dictionaryWithDictionary:@{
                         @"name":@"设置计算参数",
                         @"action":^() {
        WZZSettingParamVC * vc = [[WZZSettingParamVC alloc] init];
        [self presentViewController:vc animated:YES completion:nil];
    }}]];
    
    [dataArr addObject:[NSMutableDictionary dictionaryWithDictionary:@{
                         @"name":@"计算尺寸",
                         @"action":^() {
        WZZCalParamVC * vc = [[WZZCalParamVC alloc] init];
        vc.image = [self snapshot:mainSCNV];
        [self presentViewController:vc animated:YES completion:nil];
    }}]];
    
    [dataArr addObject:[NSMutableDictionary dictionaryWithDictionary:@{
                         @"name":@"改变挺材质",
                         @"action":^() {
        WZZChangeTextureVC * vc = [[WZZChangeTextureVC alloc] init];
        vc.textureBlock = ^(NSString *textureName) {
            NSMutableDictionary * dic = dataArr[2];
            dic[@"name"] = [NSString stringWithFormat:@"改变挺材质 - %@", textureName];
            [_mainTableView reloadData];
        };
        [self presentViewController:vc animated:YES completion:nil];
    }}]];
    
    [dataArr addObject:[NSMutableDictionary dictionaryWithDictionary:@{
                                                                       @"name":@"选择填充物",
                                                                       @"action":^() {
        WZZChangeFillVC * vc = [[WZZChangeFillVC alloc] init];
        vc.textureBlock = ^(NSString *textureName) {
            NSMutableDictionary * dic = dataArr[3];
            dic[@"name"] = [NSString stringWithFormat:@"改变填充物 - %@", textureName];
            [_mainTableView reloadData];
        };
        [self presentViewController:vc animated:YES completion:nil];
    }}]];
    
    [dataArr addObject:[NSMutableDictionary dictionaryWithDictionary:@{
                                                                       @"name":@"清空",
                                                                       @"action":^() {
        [self resetNode];
        [self resetUI];
    }}]];
    
    [dataArr addObject:[NSMutableDictionary dictionaryWithDictionary:@{
                                                                       @"name":@"重建",
                                                                       @"action":^() {
        NSDictionary * makerDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"makerDic"];
        WZZWindowNode * windowNode = [WZZShapeHandler makeAllWindowWithDic:makerDic];
        NSArray * arr = makerDic[@"outPoints"];
        if (arr.count == 4) {
            CGFloat offsetX = [[arr[2] componentsSeparatedByString:@","][1] doubleValue]/2.0f;
            CGFloat offsetY = [[arr[1] componentsSeparatedByString:@","][1] doubleValue]/2.0f;
            [windowNode setPosition:SCNVector3Make(windowNode.position.x-offsetX, windowNode.position.y-offsetY, windowNode.position.z)];
        }
        [mainScene.rootNode addChildNode:windowNode];
    }}]];
    
    //上部分视图
    UIView * upview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, _upView.frame.size.height)];
    [_upView addSubview:upview];
    [_upView bringSubviewToFront:_arButton];

    //3d视图
    mainSCNV = [[SCNView alloc] initWithFrame:upview.bounds];
    [upview addSubview:mainSCNV];
    mainSCNV.playing = YES;
    mainSCNV.allowsCameraControl = YES;
    //主场景
    mainScene = [SCNScene scene];
    mainSCNV.scene = mainScene;
    
    //初始化门窗计算工具
    [self setupDoorObj];
    
    [_mainTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [_mainTableView setTableFooterView:[[UIView alloc] init]];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [mainSCNV addGestureRecognizer:tap];
}

- (void)resetNode {
    mainSCNV.scene = mainScene = [SCNScene scene];
    
    //恢复默认
    [mainScene.rootNode enumerateChildNodesUsingBlock:^(SCNNode * _Nonnull child, BOOL * _Nonnull stop) {
        [child removeFromParentNode];
    }];
    //重置handler
    [WZZShapeHandler resetHandler];
}

- (void)resetUI {
    _hvSwitch.on = NO;
    _actionSeg.selectedSegmentIndex = 0;
}

- (void)setupWindowNode {
    [self resetNode];
    [self resetUI];
    
    CGFloat wid = _widTF.text.doubleValue;
    CGFloat hei = _heiTF.text.doubleValue;
    
    //默认宽高
//    const CGFloat widHei = WZZShapeHandler_mm_m(1.5);
    
#if 1
    //梯形
    //    WZZWindowNode * node233 = [WZZWindowNode nodeWithLeftHeight:widHei rightHeight:widHei/2 downWidth:widHei hasBorder:YES];
    //    [scene.rootNode addChildNode:node233];
    
    //矩形
    WZZWindowNode * node233 = [WZZWindowNode nodeWithHeight:hei width:wid windowBorderType:WZZShapeHandler_WindowBorderType_RootWindowBorder];
    [mainScene.rootNode addChildNode:node233];
#else
    //多边形
    NSMutableArray * arr = [NSMutableArray array];
    [arr addObject:[NSValue valueWithCGPoint:CGPointMake(0, 0)]];
    [arr addObject:[NSValue valueWithCGPoint:CGPointMake(0, hei)]];
    [arr addObject:[NSValue valueWithCGPoint:CGPointMake(wid/2.0f, hei+10)]];
    [arr addObject:[NSValue valueWithCGPoint:CGPointMake(wid+10, hei/3)]];
    [arr addObject:[NSValue valueWithCGPoint:CGPointMake(wid, 0)]];
    WZZWindowNode * node233 = [WZZWindowNode nodeWithPoints:arr windowBorderType:WZZShapeHandler_WindowBorderType_RootWindowBorder];
#endif
    
    node233.isRootWindow = YES;
    [mainScene.rootNode addChildNode:node233];
    [node233 setPosition:SCNVector3Make(-wid/2.0f, -hei/2.0f, 0)];
}

//配置计算参数
- (void)setupDoorObj {
    DoorWindowCalculationFormulaObjective * doorHandler = [DoorWindowCalculationFormulaObjective share];
    
    // 框小面
    doorHandler.circleSmallFace = 47.0f;
    // 框大面
    doorHandler.circleLargeFace = 76.0f;
    
    // 中梃小面
    doorHandler.centreSmallFace = 47.0f;
    // 中梃大面
    doorHandler.centreLargeFace = 76.0f;
    
    // 转向框小面
    doorHandler.toTurnToCircleSmallFace = 47.0f;
    // 转向框大面
    doorHandler.toTurnToCircleLargeFace = 76.0f;
    
    // 扇小面扣槽尺寸
    doorHandler.fanSmallGroovesFace = 47.0f;
    // 扇大面扣槽尺寸
    doorHandler.fanLargeGroovesFace = 76.0f;
    
    // 计算玻璃时一个不确定数。需要后台返回
    doorHandler.galssVariable = 15.0f;
    // 计算扇玻璃时一个不确定数，需要按照后台返回来的
    doorHandler.fanGalssVariable = 15.0f;
    // 扇尺寸单边搭接
    doorHandler.fanVariable = 12.0f;
    // 中梃插入量
    doorHandler.centreVariable = 9.0f;
}

//scnview点击
- (void)handleTap:(UIGestureRecognizer*)gestureRecognize {
    //点击了scnview
    SCNView *scnView = (SCNView *)gestureRecognize.view;
    
    //检测点击位置
    CGPoint p = [gestureRecognize locationInView:scnView];
//    NSArray *hitResults = [scnView hitTest:p options:@{SCNHitTestOptionSearchMode:@(SCNHitTestSearchModeAll)}];
    NSArray *hitResults = [scnView hitTest:p options:@{SCNHitTestSortResultsKey:@(1)}];
    
    //检测点击个数
    if([hitResults count] > 0){
        __block NSInteger level = -1;
        __block id node = nil;
        __block SCNHitTestResult * res;
        //返回第一个点击对象
        [hitResults enumerateObjectsUsingBlock:^(SCNHitTestResult * _Nonnull result, NSUInteger idx, BOOL * _Nonnull stop) {
            NSLog(@"%@", NSStringFromClass([result.node class]));
            if ([result.node isKindOfClass:[WZZInsideNode class]]) {
                WZZInsideNode * clickNode = (WZZInsideNode *)result.node;
                if (clickNode.nodeLevel > level) {
                    level = clickNode.nodeLevel;
                    node = clickNode;
                    res = result;
                }
            }
        }];
        if ([node isKindOfClass:[WZZInsideNode class]]) {
            [node nodeClick:res];
            NSLog(@">>%ld", [node nodeLevel]);
        }
    }
}

//创建
- (IBAction)changeC:(id)sender {
    [self.view endEditing:YES];
    
    [self setupWindowNode];
}

- (UIImage *)snapshot:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, YES, 0);
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (IBAction)hvChange:(UISwitch *)sender {
    [WZZShapeHandler shareInstance].insideHV = sender.on?WZZInsideNode_H:WZZInsideNode_V;
}

- (IBAction)actionClick:(UISegmentedControl *)sender {
    switch (sender.selectedSegmentIndex) {
        case 0:
        {
            [WZZShapeHandler shareInstance].insideAction = WZZInsideNode_Action_None;
        }
            break;
        case 1:
        {
            [WZZShapeHandler shareInstance].insideAction = WZZInsideNode_Action_Cut;
        }
            break;
        case 2:
        {
            [WZZShapeHandler shareInstance].insideAction = WZZInsideNode_Action_Fill;
        }
            break;
            
        default:
            break;
    }
}

- (IBAction)arKitClick:(id)sender {
    WZZARManager * ar = [WZZARManager shareInstance];
    [ar setupAR];
    [ar startAR];
}

#pragma mark - tableview代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text = dataArr[indexPath.row][@"name"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    void(^aBlock)(void) = dataArr[indexPath.row][@"action"];
    aBlock();
}

#pragma mark - 尝试


- (SCNNode *)starOutline {
    //Show bezier path
    UIBezierPath *star = [self starPathWithInnerRadius:6 outerRadius:3];
    
    SCNShape *shape = [SCNShape shapeWithPath:star extrusionDepth:1];
    shape.chamferRadius = 0.2;
    shape.chamferProfile = [self chamferProfileForOutline];
    shape.chamferMode = SCNChamferModeBoth;
    
    // that way only the outline of the model will be visible
    SCNMaterial *outlineMaterial = [SCNMaterial material];
    
    outlineMaterial.ambient.contents =
    outlineMaterial.diffuse.contents =
    outlineMaterial.specular.contents = [UIColor blackColor];
    
    outlineMaterial.emission.contents = @"mucai005.jpg";
    outlineMaterial.doubleSided = YES;
    
    SCNMaterial *tranparentMaterial = [SCNMaterial material];
    tranparentMaterial.transparency = 0.0;
    
    shape.materials = @[tranparentMaterial, tranparentMaterial, tranparentMaterial, outlineMaterial, outlineMaterial];
    
    SCNNode * _starOutline = [SCNNode node];
    _starOutline.geometry = shape;
//    _starOutline.position = SCNVector3Make(0, 5, 30);
//    [_starOutline runAction:[SCNAction repeatActionForever:[SCNAction rotateByX:0 y:M_PI*2 z:0 duration:10.0]]];
    
    return _starOutline;
}

- (UIBezierPath *)starPathWithInnerRadius:(CGFloat)innerRadius outerRadius:(CGFloat)outerRadius {
    NSUInteger raysCount = 5;
    CGFloat delta = 2.0 * M_PI / raysCount;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    for (NSUInteger i = 0; i < raysCount; ++i) {
        CGFloat alpha = i * delta + M_PI_2;
        
        if (i == 0)
            [path moveToPoint:CGPointMake(outerRadius * cos(alpha), outerRadius * sin(alpha))];
        else
            [path addLineToPoint:CGPointMake(outerRadius * cos(alpha), outerRadius * sin(alpha))];
        
        alpha += 0.5 * delta;
        [path addLineToPoint:CGPointMake(innerRadius * cos(alpha), innerRadius * sin(alpha))];
    }
    
    return path;
}

- (UIBezierPath *)chamferProfileForOutline {
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(1, 1)];
    [path addLineToPoint:CGPointMake(1, 0)];
    return path;
}

- (SCNGeometry *)mobiusStripWithSubdivisionCount:(NSInteger)subdivisionCount {
    NSInteger hSub = subdivisionCount;
    NSInteger vSub = subdivisionCount / 2;
    NSInteger vcount = (hSub + 1) * (vSub + 1);
    NSInteger icount = (hSub * vSub) * 6;
    
    AAPLVertex *vertices = malloc(sizeof(AAPLVertex) * vcount);
    unsigned short *indices = malloc(sizeof(unsigned short) * icount);
    
    // Vertices
    float sStep = 2.f * M_PI / hSub;
    float tStep = 2.f / vSub;
    AAPLVertex *v = vertices;
    float s = 0.f;
    float cosu, cosu2, sinu, sinu2;
    
    for (NSInteger i = 0; i <= hSub; ++i, s += sStep) {
        float t = -1.f;
        for (NSInteger j = 0; j <= vSub; ++j, t += tStep, ++v) {
            sinu = sin(s);
            cosu = cos(s);
            sinu2 = sin(s/2);
            cosu2 = cos(s/2);
            
            v->x = cosu * (1 + 0.5 * t * cosu2);
            v->y = sinu * (1 + 0.5 * t * cosu2);
            v->z = 0.5 * t * sinu2;
            
            v->nx = -0.125 * t * sinu  + 0.5  * cosu  * sinu2 + 0.25 * t * cosu2 * sinu2 * cosu;
            v->ny =  0.125 * t * cosu  + 0.5  * sinu2 * sinu  + 0.25 * t * cosu2 * sinu2 * sinu;
            v->nz = -0.5       * cosu2 - 0.25 * cosu2 * cosu2 * t;
            
            // normalize
            float invLen = 1. / sqrtf(v->nx * v->nx + v->ny * v->ny + v->nz * v->nz);
            v->nx *= invLen;
            v->ny *= invLen;
            v->nz *= invLen;
            
            
            v->s = 3.125 * s / M_PI;
            v->t = t * 0.5 + 0.5;
        }
    }
    
    // Indices
    unsigned short *ind = indices;
    unsigned short stripStart = 0;
    for (NSInteger i = 0; i < hSub; ++i, stripStart += (vSub + 1)) {
        for (NSInteger j = 0; j < vSub; ++j) {
            unsigned short v1    = stripStart + j;
            unsigned short v2    = stripStart + j + 1;
            unsigned short v3    = stripStart + (vSub+1) + j;
            unsigned short v4    = stripStart + (vSub+1) + j + 1;
            
            *ind++    = v1; *ind++    = v3; *ind++    = v2;
            *ind++    = v2; *ind++    = v3; *ind++    = v4;
        }
    }
    
    NSData *data = [NSData dataWithBytes:vertices length:vcount * sizeof(AAPLVertex)];
    free(vertices);
    
    // Vertex source
    SCNGeometrySource *vertexSource = [SCNGeometrySource geometrySourceWithData:data
                                                                       semantic:SCNGeometrySourceSemanticVertex
                                                                    vectorCount:vcount
                                                                floatComponents:YES
                                                            componentsPerVector:3
                                                              bytesPerComponent:sizeof(float)
                                                                     dataOffset:0
                                                                     dataStride:sizeof(AAPLVertex)];
    
    // Normal source
    SCNGeometrySource *normalSource = [SCNGeometrySource geometrySourceWithData:data
                                                                       semantic:SCNGeometrySourceSemanticNormal
                                                                    vectorCount:vcount
                                                                floatComponents:YES
                                                            componentsPerVector:3
                                                              bytesPerComponent:sizeof(float)
                                                                     dataOffset:offsetof(AAPLVertex, nx)
                                                                     dataStride:sizeof(AAPLVertex)];
    
    
    // Texture coordinates source
    SCNGeometrySource *texcoordSource = [SCNGeometrySource geometrySourceWithData:data
                                                                         semantic:SCNGeometrySourceSemanticTexcoord
                                                                      vectorCount:vcount
                                                                  floatComponents:YES
                                                              componentsPerVector:2
                                                                bytesPerComponent:sizeof(float)
                                                                       dataOffset:offsetof(AAPLVertex, s)
                                                                       dataStride:sizeof(AAPLVertex)];
    
    
    // Geometry element
    NSData *indicesData = [NSData dataWithBytes:indices length:icount * sizeof(unsigned short)];
    free(indices);
    
    SCNGeometryElement *element = [SCNGeometryElement geometryElementWithData:indicesData
                                                                primitiveType:SCNGeometryPrimitiveTypeTriangles
                                                               primitiveCount:icount/3
                                                                bytesPerIndex:sizeof(unsigned short)];
    
    // Create the geometry
    SCNGeometry *geometry = [SCNGeometry geometryWithSources:@[vertexSource, normalSource, texcoordSource] elements:@[element]];
    
    // Add textures
    geometry.firstMaterial = [SCNMaterial material];
    geometry.firstMaterial.diffuse.contents = @"mucai005.jpg";
    geometry.firstMaterial.diffuse.wrapS = SCNWrapModeRepeat;
    geometry.firstMaterial.diffuse.wrapT = SCNWrapModeRepeat;
    geometry.firstMaterial.doubleSided = YES;
    geometry.firstMaterial.reflective.intensity = 0.3;
    
    return geometry;
}

@end
