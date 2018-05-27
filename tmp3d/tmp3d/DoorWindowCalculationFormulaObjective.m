//
//  DoorWindowCalculationFormulaObjective.m
//  门窗公式
//
//  Created by 潘儒贞 on 2018/5/24.
//  Copyright © 2018年 潘儒贞. All rights reserved.
//

#import "DoorWindowCalculationFormulaObjective.h"

static DoorWindowCalculationFormulaObjective *doorWindowObjective;

@implementation DoorWindowCalculationFormulaObjective

+ (instancetype)share{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        doorWindowObjective = [[DoorWindowCalculationFormulaObjective alloc] init];
    });
    return doorWindowObjective;
}

/**
 框的计算方法
 
 @param formula 计算方式
 @param distance 距离
 @return 计算的结果
 */
+ (double)DoorWindowCircleCalculationFormula:(CalculationFormula)formula distance:(double)distance{
    double result = 0;
    if (formula == CalculationFormula_EdgeAndEdge) {//边到边
        result = distance-doorWindowObjective.circleSmallFace-doorWindowObjective.circleSmallFace;
    }else if (formula == CalculationFormula_EdgeAndIn){//边到中
        result = (distance-doorWindowObjective.circleSmallFace-(doorWindowObjective.centreSmallFace/2));
    }else if (formula == CalculationFormula_InAndIn){//中到中
        result = distance-(doorWindowObjective.centreSmallFace/2)-(doorWindowObjective.centreSmallFace/2);
    }
    return result;
}

/**
 玻璃计算方法
 
 @param formula 计算方式
 @param distance 距离
 @return 计算结果
 */
+ (double)DoorWindowGlassCalculationFormula:(CalculationFormula)formula distance:(double)distance{
    double result = 0;
    if (formula == CalculationFormula_EdgeAndIn) {//边到中，边到中—框小面—中挺小面/2—15
        result = distance-doorWindowObjective.circleSmallFace-(doorWindowObjective.centreSmallFace/2)-doorWindowObjective.galssVariable;
    }else if (formula == CalculationFormula_InAndIn){//中到中,中到中—中挺小面/2—中挺小面/2—15
        result = distance-(doorWindowObjective.centreSmallFace/2)-(doorWindowObjective.centreSmallFace/2)-doorWindowObjective.galssVariable;
    }else if (formula == CalculationFormula_EdgeAndEdge){//边到边,边到边—框小面—框小面—15
        result = distance-doorWindowObjective.circleSmallFace-doorWindowObjective.circleSmallFace-doorWindowObjective.galssVariable;
    }
    return result;
}

/**
 纱窗计算方法
 
 @param formula 计算方式
 @param turn 转不转向
 @param distance 距离
 @return 计算结果
 */
+ (double)DoorWindowScreenWindowCalculationFormula:(CalculationFormula)formula screenWindowTurn:(ScreenWindowTurn)turn distance:(double)distance{
    double result = 0;
    if (turn == ScreenWindowTurn_YES) {//转向
        if (formula == CalculationFormula_EdgeAndIn) {//边到中
            result = distance-(doorWindowObjective.centreSmallFace/2)-(doorWindowObjective.circleSmallFace-(doorWindowObjective.toTurnToCircleLargeFace*2));
        }else if (formula == CalculationFormula_InAndIn){//中到中
            result = distance-(doorWindowObjective.centreSmallFace/2)-(doorWindowObjective.centreSmallFace/2)-(doorWindowObjective.toTurnToCircleLargeFace*2);
        }else if (formula == CalculationFormula_EdgeAndEdge){//边到边
            result = distance-doorWindowObjective.circleSmallFace-doorWindowObjective.circleSmallFace-(doorWindowObjective.toTurnToCircleLargeFace*2);
        }
    }else if (turn == ScreenWindowTurn_NO){//不转向
        if (formula == CalculationFormula_EdgeAndIn) {//边到中
            result = distance-(doorWindowObjective.centreLargeFace/2)-doorWindowObjective.circleLargeFace;
        }else if (formula == CalculationFormula_InAndIn){//中到中
            result = distance-(doorWindowObjective.centreLargeFace/2)-(doorWindowObjective.centreLargeFace/2);
        }else if (formula == CalculationFormula_EdgeAndEdge){//边到边
            result = distance-doorWindowObjective.circleLargeFace-doorWindowObjective.circleLargeFace;
        }
    }
    return result;
}

/**
 转向框尺寸
 
 @param formula 计算方式
 @param distance 距离
 @return 计算结果
 */
+ (double)DoorWindowToTurnToCircleCalculationFormula:(CalculationFormula)formula distance:(double)distance{
    double result = 0;
    if (formula == CalculationFormula_EdgeAndIn) {//边到中
        result = distance-(doorWindowObjective.centreSmallFace/2)-doorWindowObjective.circleSmallFace;
    }else if (formula == CalculationFormula_InAndIn){//中到中
        result = distance-(doorWindowObjective.centreSmallFace/2)-(doorWindowObjective.centreSmallFace/2);
    }else if (formula == CalculationFormula_EdgeAndEdge){//边到边
        result = distance-doorWindowObjective.circleSmallFace-doorWindowObjective.circleSmallFace;
    }
    return result;
}

/**
 扇压线尺寸
 
 @param formula 计算方式
 @param distance 距离
 @return 计算结果
 */
+ (double)DoorWindowFanPressingLineCalculationFormula:(CalculationFormula)formula distance:(double)distance{
    double result = 0;
    return result = distance-(doorWindowObjective.fanSmallGroovesFace*2);
}

/**
 扇玻璃尺寸
 
 @param formula 计算方式
 @param distance 距离
 @return 计算结果
 */
+ (double)DoorWindowFanGalssCalculationFormula:(CalculationFormula)formula distance:(double)distance{
    double result = 0;
    return result = distance-(doorWindowObjective.fanSmallGroovesFace*2)-doorWindowObjective.fanGalssVariable;
}

/**
 扇尺寸
 
 @param formula 计算方式
 @param turn 是否含转向
 @param distance 距离
 @return 计算结果
 */
+ (double)DoorWindowFanCalculationFormula:(CalculationFormula)formula screenWindowTurn:(ScreenWindowTurn)turn distance:(double)distance{
    double result = 0;
    if (turn == ScreenWindowTurn_YES) {//含转向
        if (formula == CalculationFormula_EdgeAndIn) {//边到中
            result = distance-((doorWindowObjective.centreSmallFace/2)+doorWindowObjective.circleSmallFace+(doorWindowObjective.toTurnToCircleSmallFace*2)-(doorWindowObjective.fanVariable*2));
        }else if (formula == CalculationFormula_InAndIn){//中到中
            result = distance-((doorWindowObjective.centreSmallFace/2)+(doorWindowObjective.centreSmallFace/2)+(doorWindowObjective.toTurnToCircleSmallFace*2)-(doorWindowObjective.fanVariable*2));
        }else if (formula == CalculationFormula_EdgeAndEdge){//边到边
            result = distance-(doorWindowObjective.circleSmallFace+doorWindowObjective.circleSmallFace+(doorWindowObjective.toTurnToCircleSmallFace*2)-(doorWindowObjective.fanVariable*2));
        }
    }else if (turn == ScreenWindowTurn_NO){//不含转向
        if (formula == CalculationFormula_EdgeAndIn) {//边到中
            result = distance-((doorWindowObjective.centreSmallFace/2)+doorWindowObjective.circleSmallFace-(doorWindowObjective.fanVariable*2));
        }else if (formula == CalculationFormula_InAndIn){//中到中
            result = distance-((doorWindowObjective.centreSmallFace/2)+(doorWindowObjective.centreSmallFace/2)-(doorWindowObjective.fanVariable*2));
        }else if (formula == CalculationFormula_EdgeAndEdge){//边到边
            result = distance-(doorWindowObjective.circleSmallFace+doorWindowObjective.circleSmallFace-(doorWindowObjective.fanVariable*2));
        }
    }
    return result;
}

/**
 中梃尺寸
 
 @param formula 计算方式
 @param distance 距离
 @return 计算结果
 */
+ (double)DoorWindowCentreGalssCalculationFormula:(CalculationFormula)formula distance:(double)distance{
    double result = 0;
    if (formula == CalculationFormula_EdgeAndIn) {//边到中
        result = distance-((doorWindowObjective.centreSmallFace/2)+doorWindowObjective.circleSmallFace-doorWindowObjective.centreVariable);
    }else if (formula == CalculationFormula_InAndIn){//中到中
        result = distance-((doorWindowObjective.centreSmallFace/2)+(doorWindowObjective.centreSmallFace/2)-doorWindowObjective.centreVariable);
    }else if (formula == CalculationFormula_EdgeAndEdge){//边到边
        result = distance-(doorWindowObjective.circleSmallFace+doorWindowObjective.circleSmallFace-doorWindowObjective.centreVariable);
    }
    return result;
}

@end
