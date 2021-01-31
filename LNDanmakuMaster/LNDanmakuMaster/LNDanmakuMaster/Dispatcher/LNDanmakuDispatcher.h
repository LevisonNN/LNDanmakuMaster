//
//  LNDanmakuDispatcher.h
//  LNDanmakuMaster
//
//  Created by Levison on 31.1.21.
//  Copyright © 2021 Levison. All rights reserved.
//

#import "LNDanmakuAbstractDispatcher.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, LNDanmakuDispatchStrategy)
{
    LNDanmakuDispatchStrategyDefault = 0, //Find the first track to insert.
    LNDanmakuDispatchStrategyLowDensity, //Find the most free track to insert.
    LNDanmakuDispatchStrategyMostFastDisplay //Find the track with shortest waiting time.
};

typedef NS_ENUM(NSInteger, LNDanmakuRecoverDispatchStrategy)
{
    LNDanmakuRecoverDispatchStrategyDefault = 0,
    LNDanmakuRecoverDispatchStrategyLowDensity,
    LNDanmakuRecoverDispatchStrategyMostFastDisplay,
};

@interface LNDanmakuDispatcher : LNDanmakuAbstractDispatcher

@property (nonatomic, assign) LNDanmakuDispatchStrategy dispatchStrategy;
@property (nonatomic, assign) LNDanmakuRecoverDispatchStrategy recoverDispatcherStrategy;

@end

NS_ASSUME_NONNULL_END
