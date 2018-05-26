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
@import UIKit;
@import SceneKit;

typedef struct {
    float x, y, z;    // position
    float nx, ny, nz; // normal
    float s, t;       // texture coordinates
} AAPLVertex;

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    NSMutableDictionary * nodeDic;
    NSMutableArray * textureArr;
    NSMutableArray * textureNameArr;
    NSInteger textureIdx;
}
@property (weak, nonatomic) IBOutlet UIView *upView;
@property (weak, nonatomic) IBOutlet UITextField *widTF;
@property (weak, nonatomic) IBOutlet UITextField *heiTF;
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (weak, nonatomic) IBOutlet UIButton *arButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView * upview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, _upView.frame.size.height)];
    [_upView addSubview:upview];
    [_upView bringSubviewToFront:_arButton];
    
    //3d
    SCNView * scnView = [[SCNView alloc] initWithFrame:upview.bounds];
    [upview addSubview:scnView];
    scnView.playing = YES;
    scnView.allowsCameraControl = YES;
    
    SCNScene * scene = [SCNScene scene];
    scnView.scene = scene;
//    scene.background.contents = [UIColor blackColor];
    
    
    const CGFloat widHei = 20.0f;
    
    WZZWindowNode * node233 = [WZZWindowNode nodeWithLeftHeight:widHei rightHeight:widHei/2 downWidth:widHei hasBorder:YES];
    [scene.rootNode addChildNode:node233];
//    NSMutableArray * arr = [NSMutableArray array];
//    [arr addObject:[NSValue valueWithCGPoint:CGPointMake(0, 0)]];
//    [arr addObject:[NSValue valueWithCGPoint:CGPointMake(0, widHei)]];
//    [arr addObject:[NSValue valueWithCGPoint:CGPointMake(widHei, widHei/2.0f)]];
//    [arr addObject:[NSValue valueWithCGPoint:CGPointMake(widHei, 0)]];
//    WZZWindowNode * node233 = [WZZWindowNode nodeWithPoints:arr hasBorder:YES];
//    [scene.rootNode addChildNode:node233];
//    [node233 setPosition:SCNVector3Make(-widHei/2.0f, -widHei/2.0f, 0)];
    
    //旧的
    textureArr = [NSMutableArray array];
    [textureArr addObject:@"mucai005.jpg"];
    [textureArr addObject:@"met.jpg"];
    [textureArr addObject:@"metal.jpg"];
    [textureArr addObject:@"metal2.jpg"];
    
    textureNameArr = [NSMutableArray array];
    [textureNameArr addObject:@"木材"];
    [textureNameArr addObject:@"金属"];
    [textureNameArr addObject:@"金属2"];
    [textureNameArr addObject:@"金属3"];
    
    textureIdx = 0;
    
    [_mainTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [_mainTableView setTableFooterView:[[UIView alloc] init]];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [scnView addGestureRecognizer:tap];
}

- (void)handleTap:(UIGestureRecognizer*)gestureRecognize
{
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

- (IBAction)changeC:(id)sender {
    [self.view endEditing:YES];
    SCNNode * lineNode = nodeDic[@"lineNode"];
    SCNNode * lineNode2 = nodeDic[@"lineNode2"];
    SCNNode * lineNode3 = nodeDic[@"lineNode3"];
    SCNNode * lineNode4 = nodeDic[@"lineNode4"];
    
    CGFloat wid = _widTF.text.doubleValue/100.0f;
    CGFloat hei = _heiTF.text.doubleValue/100.0f;
    
#if 1
    
    
    //添加框
    SCNBox * box = [SCNBox boxWithWidth:0.5 height:hei length:0.5 chamferRadius:0.0f];
    SCNBox * box2 = [SCNBox boxWithWidth:0.5 height:wid length:0.5 chamferRadius:0.0f];
    [lineNode setGeometry:box];
    [lineNode2 setGeometry:box];
    [lineNode3 setGeometry:box2];
    [lineNode4 setGeometry:box2];
#else
    //高12
    SCNBox * box = (SCNBox *)lineNode.geometry;
    box.length = hei;
    SCNBox * box2 = (SCNBox *)lineNode2.geometry;
    box2.length = hei;
    
    //宽34
    SCNBox * box3 = (SCNBox *)lineNode3.geometry;
    box3.length = wid;
    SCNBox * box4 = (SCNBox *)lineNode4.geometry;
    box4.length = wid;
#endif
    
    lineNode.position = SCNVector3Make(-(wid-0.5)/2.0f, 0, 0);
    
    lineNode2.position = SCNVector3Make((wid-0.5)/2.0f, 0, 0);
    
    lineNode3.position = SCNVector3Make(0, -(hei-0.5)/2.0f, 0);
    lineNode3.rotation = SCNVector4Make(0, 0, 1, M_PI_2);
    
    lineNode4.position = SCNVector3Make(0, (hei-0.5)/2.0f, 0);
    lineNode4.rotation = SCNVector4Make(0, 0, 1, M_PI_2);
    
    [self changeClick];
}

- (void)changeClick {
    [nodeDic.allValues enumerateObjectsUsingBlock:^(SCNNode * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.geometry.firstMaterial.diffuse.contents = textureArr[textureIdx];
    }];
}
- (IBAction)hvChange:(UISwitch *)sender {
    [WZZShapeHandler shareInstance].insideHV = sender.on?WZZInsideNode_H:WZZInsideNode_V;
}

- (IBAction)actionChange:(UISwitch *)sender {
    [WZZShapeHandler shareInstance].insideAction = sender.on?WZZInsideNode_Action_Cut:WZZInsideNode_Action_None;
}

- (IBAction)fillChange:(UISwitch *)sender {
        [WZZShapeHandler shareInstance].insideAction = sender.on?WZZInsideNode_Action_Fill:WZZInsideNode_Action_None;
}

- (IBAction)arKitClick:(id)sender {
    WZZARManager * ar = [WZZARManager shareInstance];
    [ar setupAR];
    [ar startAR];
}

#pragma mark - tableview代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return textureArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text = textureNameArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    textureIdx = indexPath.row;
    [self changeClick];
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
