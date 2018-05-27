//
//  DoorWindowCalculationFormulaObjective.h
//  门窗公式
//
//  Created by 潘儒贞 on 2018/5/24.
//  Copyright © 2018年 潘儒贞. All rights reserved.
//  门窗计算公式

#import <Foundation/Foundation.h>

typedef enum : NSInteger {
    CalculationFormula_EdgeAndEdge,//边到边
    CalculationFormula_EdgeAndIn,//边到中
    CalculationFormula_InAndIn,//中到中
} CalculationFormula;//计算方式

typedef enum : NSInteger {
    ScreenWindowTurn_NO,//无转向
    ScreenWindowTurn_YES,//有转向
}ScreenWindowTurn;//含不含转向

@interface DoorWindowCalculationFormulaObjective : NSObject

// 框小面
@property (nonatomic, assign) double circleSmallFace;
// 框大面
@property (nonatomic, assign) double circleLargeFace;

// 中梃小面
@property (nonatomic, assign) double centreSmallFace;
// 中梃大面
@property (nonatomic, assign) double centreLargeFace;

// 转向框小面
@property (nonatomic, assign) double toTurnToCircleSmallFace;
// 转向框大面
@property (nonatomic, assign) double toTurnToCircleLargeFace;

// 扇小面扣槽尺寸
@property (nonatomic, assign) double fanSmallGroovesFace;
// 扇大面扣槽尺寸
@property (nonatomic, assign) double fanLargeGroovesFace;

// 计算玻璃时一个不确定数。需要后台返回
@property (nonatomic, assign) double galssVariable;
// 计算扇玻璃时一个不确定数，需要按照后台返回来的
@property (nonatomic, assign) double fanGalssVariable;
// 扇尺寸单边搭接
@property (nonatomic, assign) double fanVariable;
// 中梃插入量
@property (nonatomic, assign) double centreVariable;

/**
 计算方式
 */
@property (nonatomic, assign) CalculationFormula formula;

+ (instancetype)share;

/**
 框的计算方法
gf
 @param formula 计算方式
 @param distance 距离
 @return 计算的结果
 */
+ (double)DoorWindowCircleCalculationFormula:(CalculationFormula)formula distance:(double)distance;

/**
 玻璃计算方法

 @param formula 计算方式
 @param distance 距离
 @return 计算结果
 */
+ (double)DoorWindowGlassCalculationFormula:(CalculationFormula)formula distance:(double)distance;

/**
 纱窗计算方法

 @param formula 计算方式
 @param turn 转不转向
 @param distance 距离
 @return 计算结果
 */
+ (double)DoorWindowScreenWindowCalculationFormula:(CalculationFormula)formula screenWindowTurn:(ScreenWindowTurn)turn distance:(double)distance;

/**
 转向框尺寸计算方法

 @param formula 计算方式
 @param distance 距离
 @return 计算结果
 */
+ (double)DoorWindowToTurnToCircleCalculationFormula:(CalculationFormula)formula distance:(double)distance;

/**
 扇压线尺寸计算方法

 @param formula 计算方式
 @param distance 距离
 @return 计算结果
 */
+ (double)DoorWindowFanPressingLineCalculationFormula:(CalculationFormula)formula distance:(double)distance;

/**
 扇玻璃尺寸计算方法
 
 @param formula 计算方式
 @param distance 距离
 @return 计算结果
 */
+ (double)DoorWindowFanGalssCalculationFormula:(CalculationFormula)formula distance:(double)distance;

/**
 扇尺寸

 @param formula 计算方式
 @param turn 是否含转向
 @param distance 距离
 @return 计算结果
 */
+ (double)DoorWindowFanCalculationFormula:(CalculationFormula)formula screenWindowTurn:(ScreenWindowTurn)turn distance:(double)distance;

/**
 中梃尺寸

 @param formula 计算方式
 @param distance 距离
 @return 计算结果
 */
+ (double)DoorWindowCentreGalssCalculationFormula:(CalculationFormula)formula distance:(double)distance;
@end
