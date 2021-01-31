//
//  LNDanmakuPopTrack.h
//  LNDanmakuMaster
//
//  Created by Levison on 31.1.21.
//  Copyright © 2021 Levison. All rights reserved.
//

#import "LNDanmakuAbstractTrack.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, LNDanmakuPopTrackStrategy)
{
    LNDanmakuPopTrackStrategyDynamic = 0,
    LNDanmakuPopTrackStrategyStatic
};

@interface LNDanmakuPopTrack : LNDanmakuAbstractTrack

@property (nonatomic, assign) float A; //Amplitude, default is 1.f
@property (nonatomic, assign) float beta; //damping, default is 10.f
@property (nonatomic, assign) float w; //palstance, default is M_PI/8.f
@property (nonatomic, assign) float theta; //phase, default is M_PI/2.f

/*
 * If user choose static we will use default parameters, and get every animation detail from a static array.
 * In this case, all track parameters will not effect.
 * Good performance, sir. \(^o^)/~
 **/
@property (nonatomic, assign) LNDanmakuPopTrackStrategy strategy;

@end

NS_ASSUME_NONNULL_END
