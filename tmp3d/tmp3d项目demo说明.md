# 斯卡特项目demo说明

[TOC]

## 实现思路说明

* 本demo使用苹果原生SceneKit框架进行3D模型处理
* 主要以WZZWindowNode(窗体)和WZZInsideNode(内容)两个大构成，其中穿插WZZTingNode边框节点，WZZFillNode填充节点
* 窗体结构：最底层为根窗体，窗体上必然包含1个内容节点。内容节点可以供用户做分割和填充操作。内容节点包含0个或2个窗体。当用户做分割操作时，就会在用户点击点创建横/竖梃，然后以2个窗体填满当前内容节点。当用户做填充操作时会使用WZZFillNode填充节点填满整个内容节点并不可操作。
* 数据处理：每个窗体和内容节点都有其对应的WZZWindowDataMaker和WZZInsideDataMaker一一对应，DataMaker会记录该节点的状态，其中包括了节点的关键属性、用户操作等。当需要保存数据时WZZWindowDataHandler会根据节点对应的DataMaker的状态和构成的关键属性将节点转换成字典数据，递归存储。当需要根据数据创建视图时，WZZWindowDataHandler会根据字典使用其对应的DataMaker进行创建。



## 界面部分

### ViewController

主控制器，大部分界面的内容都在该控制器中，该控制器界面主要分为3部分

1. SCNView，3D展示部分
2. 切割、填充操作按钮部分
3. UITableView，其他点击操作部分

### WZZCalParamVC

计算控制器，主要功能是计算窗体构成和各部件的尺寸，同时上传给服务端

主要计算操作参考DoorWindowCalculationFormulaObjective和WZZWindowDataMaker类

### WZZChangeTextureVC

更换材质控制器，处理更换材质操作

### WZZChangeFillVC

填充控制器，处理填充(玻璃、扇等)操作

### WZZChangeZhongTingVC

改变中庭尺寸控制器



## 3D模型部分

### WZZWindowNode

窗体节点

* 窗体中存有画窗户时的内部点和外部点，一圈内外点可以使用UIBezierPath画出窗户路径并使用SCNShape类处理成3D样式。
* 窗体中还存有一圈边框数据，是否主窗体
* 窗体中必然存在一个WZZInsideNode填充节点，且新创建的窗体中填充节点必然是待填充状态

### WZZInsideNode

窗体内容填充节点

* 内容填充节点存有内容类型、操作方式等属性
* 内容节点中有最多2个最少0个WZZWindowNode窗体节点
* 当用户做切割动作时，会在切割点创建一个横/竖梃，如果为竖梃则在竖梃两侧添加两个窗体节点，相当于一根梃将内容节点分割成两个窗体，窗体中又包含内容节点以便用户操作
* 当用户做填充动作时，会将一个WZZFillNode填充节点填充满整个内容节点，并且该内容节点至此不可做其他任何操作

### WZZTingNode

梃节点父类

### WZZWindowBorderTingNode

窗框梃节点，最外边的梃，继承WZZTingNode

* 外边框，用来和中梃做区分，也方便判断计算时的边到中边到边情况

### WZZZhongTingNode

中梃节点，窗户中间的梃，继承WZZTingNode

* 中梃

### WZZFillNode

填充节点父类，填充节点添加在WZZInsideNode内容节点上，添加填充后，内容节点将不可操作

### WZZTextureFillNode

材质填充节点，继承WZZFillNode，一般填充玻璃等材质

### WZZShanFillNode

扇填充节点，继承WZZFillNode，一般填充扇类型材质



## 3D处理类

### WZZShapeHandler

该类为单例类，控制窗体及边框坐标计算、操作动作(填充、切割、操作队列)的记录。

主要方法为

```objective-c
/**
 计算多边形框

 @param linkArray 链接数组
 @param border 边框宽度
 @return 边框内点
 */
+ (NSArray <NSValue *>*)makeAnyBorder3WithLinkArray:(WZZLinkedArray *)linkArray
                                             border:(CGFloat)border;

/**
 创建边框，计算内边框位置
 
 @param linkArray 链表数组
 @param border 边框宽度
 @return 内边框位置
 */
+ (NSArray <NSValue *>*)makeBorderWithLinkArray:(WZZLinkedArray *)linkArray
                                         border:(CGFloat)border;

/**
 测试时快速显示点

 @param node 父node
 @param points 点
 @param color 颜色
 */
+ (void)showPointWithNode:(SCNNode *)node
                   points:(NSArray <NSValue *>*)points
                    color:(UIColor *)color;
```

弃用方法，虽然弃用单由于有一些参考价值，所以保留以供查阅，由于有计算多边形边框方法所以三角形灯方法都被弃用，但目前只实现了矩形计算窗户数据，所以还保留“创建边框，计算内边框位置”方法。

```objective-c
//x创建三角形边框
+ (NSArray <NSValue *>*)makeBorder3WithLinkArray:(WZZLinkedArray *)linkArray
                                          border:(CGFloat)border;

//x多边形
+ (NSArray <NSValue *>*)makeAnyBorderWithLinkArray:(WZZLinkedArray *)linkArray;

//x计算多边形边框
+ (NSArray <NSValue *>*)makeAnyBorder2WithLinkArray:(WZZLinkedArray *)linkArray;
```

### WZZWindowDataMaker

窗户数据计算类

主要有以下两个方法，在WZZWindowDataHandler转换数据时会递归调用每层maker进行创建视图或转换字典

```objective-c
/**
 用dic创建window

 @param dic 字典
 @return window
 */
+ (WZZWindowNode *)makeWindowWithDic:(NSDictionary *)dic;

/**
 window转换成字典，递归

 @return window字典
 */
+ (NSDictionary *)dicWithWindow:(WZZWindowNode *)windowNode;
```



### WZZInsideNodeMaker

内容数据计算类

主要有以下两个方法，在WZZWindowDataHandler转换数据时会递归调用每层maker进行创建视图或转换字典

```objective-c
/**
 处理inside

 @param dic inside字典
 @param insideNode 待处理insideNode
 */
+ (void)handleInsideWithDic:(NSDictionary *)dic inside:(WZZInsideNode *)insideNode;

/**
 inside转换成字典，递归
 
 @return inside字典
 */
+ (NSDictionary *)dicWithInside:(WZZInsideNode *)insideNode;
```

### WZZWindowDataHandler

主要记录所有3D节点和资源，主要方法有以下几种，记录状态、撤销、重做、计算边框数据、3D模型转存字典和字典转换为3D模型功能。

```objective-c
/**
 记录当前编辑状态
 */
+ (void)markdownState;

/**
 撤销
 */
+ (WZZWindowNode *)undo;

/**
 重做
 */
+ (WZZWindowNode *)redo;

/**
 获取矩形所有边框数据
 */
- (void)getRectAllBorderData:(void(^)(id borderData))borderDataBlock;

#pragma mark - 数据存储重组

/**
 获取所有重建数据
 
 @return 重建数据字典
 */
+ (NSDictionary *)getAllMakerData;

/**
 重建所有窗体
 
 @param dic 数据字典
 */
+ (WZZWindowNode *)makeAllWindowWithDic:(NSDictionary *)dic;

/**
 获取insdieDic以修改

 @param dic 所有数据的字典
 @param insideLevel inside等级
 @return 找到的dic
 */
+ (NSMutableDictionary *)getInsideDicWithAllWindowDic:(NSDictionary *)dic
                                          insideLevel:(NSInteger)insideLevel;
```





## 工具类

### WZZLinkedArray

链表结构数组，可以方便查找前驱后继的数组，使用普通数组生成链表数组，链表数组中的元素将不是源数组中的元素，而是WZZLinkedObject类

```objective-c
//链表元素
@interface WZZLinkedObject : NSObject

/**
 元素类型
 */
@property (nonatomic, assign) WZZLinkedObjectIndex indexType;

/**
 前驱
 */
@property (nonatomic, weak) WZZLinkedObject * lastObj;

/**
 后继
 */
@property (nonatomic, weak) WZZLinkedObject * nextObj;

/**
 源数据
 */
@property (nonatomic, weak) id thisObj;

@end
```



### WZZHttpTool

网络请求工具，GET、POST、PUT、DELETE请求

### DoorWindowCalculationFormulaObjective

各种型材计算公式计算类，调用时根据注释调用即可，计算方式一般分为边到边、边到中、中到中，其中边指的是窗户外边框，中指的是中梃，例:

```objective-c
/**
 扇压线尺寸计算方法

 @param formula 计算方式
 @param distance 距离
 @return 计算结果
 */
+ (double)DoorWindowFanPressingLineCalculationFormula:(CalculationFormula)formula distance:(double)distance;
```





## 没用类

### WZZSettingParamVC

设置属性视图，暂无内容

### WZZARVC

AR展示，暂无内容

### WZZMakeQueueModel

操作队列创建模型，暂无内容

### WZZ2DButtonNode

3D节点添加2Dbutton节点，暂无内容

### WZZARManager

AR管理者，暂无内容