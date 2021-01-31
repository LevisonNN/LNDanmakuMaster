//
//  LNDanmakuDispatcher.m
//  LNDanmakuMaster
//
//  Created by Levison on 31.1.21.
//  Copyright © 2021 Levison. All rights reserved.
//

#import "LNDanmakuDispatcher.h"
#import "LNDanmakuDispatchQueue.h"

@interface LNDanmakuDispatcher () <LNDanmakuDispatchQueueDelegate>

@property (nonatomic, strong) LNDanmakuDispatchQueue *attributesQueue;

@end

@implementation LNDanmakuDispatcher

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.maxSmoothGrainNum = 1;
        
        self.dispatchStrategy = LNDanmakuDispatchStrategyMostFastDisplay;
        self.recoverDispatcherStrategy = LNDanmakuRecoverDispatchStrategyMostFastDisplay;
    }
    return self;
}

- (void)dispatchNewAttributesToFreeTracks:(NSArray<LNDanmakuAbstractTrackController *> *)trackControllerArray
{
    if ([self.attributesQueue isEmpty]) {
        return;
    }
    //n * log(n - maxGrainNum) is wasted。
    if (self.restGrainNum == 0) {
        return;
    } else if (self.restGrainNum == 1) {
        // O(n)
        [self _dispatchOneNewAttributesToFreeTracks:trackControllerArray];
    } else {
        // O(n*logn)
        [self _dispatchSeveralNewAttributesToFreeTracks:trackControllerArray];
    }
}

- (NSArray <LNDanmakuAbstractTrackController *> *)getFreeTrackControllers:(NSArray<LNDanmakuAbstractTrackController *> *)trackControllerArray
{
    NSMutableArray <LNDanmakuAbstractTrackController *> *trackControllerMArr = [[NSMutableArray alloc] init];
    for (LNDanmakuAbstractTrackController *trackController in trackControllerArray) {
        if ([trackController isFree]) {
            [trackControllerMArr addObject:trackController];
        }
    }
    trackControllerArray = [NSArray arrayWithArray:trackControllerMArr];
    return trackControllerArray;
}


- (void)_dispatchOneNewAttributesToFreeTracks:(NSArray<LNDanmakuAbstractTrackController *> *)trackControllerArray
{
    if ([self.attributesQueue isEmpty] || self.restGrainNum <= 0) {
        return;
    }
    trackControllerArray = [self getFreeTrackControllers:trackControllerArray];
    LNDanmakuAbstractTrackController *targetTrackController = [trackControllerArray firstObject];
    switch (self.dispatchStrategy) {
        case LNDanmakuDispatchStrategyMostFastDisplay: {
            LNDanmakuAbstractAttributes *targetAttributes = [self.attributesQueue top];
            NSTimeInterval minWaitTime = MAXFLOAT;
            if (targetAttributes) {
                for (LNDanmakuAbstractTrackController * obj in trackControllerArray) {
                    NSTimeInterval currentWaitTime = [obj estimatedMinDisplayWaitTimeFor:targetAttributes];
                    if (currentWaitTime < minWaitTime) {
                        minWaitTime = currentWaitTime;
                        targetTrackController = obj;
                    }
                }
            }
        } break;
        case LNDanmakuDispatchStrategyLowDensity: {
            LNDanmakuAbstractAttributes *targetAttributes = [self.attributesQueue top];
            NSTimeInterval minFinishTime = MAXFLOAT;
            if (targetAttributes) {
                for (LNDanmakuAbstractTrackController * obj in trackControllerArray) {
                    NSTimeInterval currentFinishTime = [obj estimatedFinishTimeForCurrentAttributes];
                    if (currentFinishTime < minFinishTime) {
                        minFinishTime = currentFinishTime;
                        targetTrackController = obj;
                    }
                }
            }
        } break;
        default: {
            
        } break;
    }
    
    if (self.restGrainNum > 0 && targetTrackController) {
        LNDanmakuAbstractAttributes *attributes = [self.attributesQueue pop];
        if (attributes) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(dispatcher:willDispatch:to:)]) {
                [self.delegate dispatcher:self willDispatch:attributes to:targetTrackController];
            }
            [targetTrackController loadAttributes:attributes];
            [self decreaseRestGrainNum];
            if (self.delegate && [self.delegate respondsToSelector:@selector(dispatcher:didDispatch:to:)]) {
                [self.delegate dispatcher:self didDispatch:attributes to:targetTrackController];
            }
        }
    }
}

- (void)_dispatchSeveralNewAttributesToFreeTracks:(NSArray<LNDanmakuAbstractTrackController *> *)trackControllerArray
{
    if ([self.attributesQueue isEmpty] || self.restGrainNum <= 0) {
        return;
    }
    
    trackControllerArray = [self getFreeTrackControllers:trackControllerArray];
    NSMutableArray<LNDanmakuAbstractTrackController *> *mArr = [NSMutableArray arrayWithArray:trackControllerArray];
    
    NSMutableDictionary *mDic = [[NSMutableDictionary alloc] init];
    
    switch (self.dispatchStrategy) {
        case LNDanmakuDispatchStrategyMostFastDisplay: {
            LNDanmakuAbstractAttributes *targetAttributes = [self.attributesQueue top];
            if (targetAttributes) {
                [mArr sortWithOptions:NSSortStable usingComparator:^NSComparisonResult(LNDanmakuAbstractTrackController  * _Nonnull obj1, LNDanmakuAbstractTrackController   * _Nonnull obj2) {
                    NSTimeInterval waitTime1 = [obj1 estimatedMinDisplayWaitTimeFor:targetAttributes];
                    NSTimeInterval waitTime2 = [obj2 estimatedMinDisplayWaitTimeFor:targetAttributes];
                    [mDic setObject:@(waitTime1) forKey:obj1.description];
                    [mDic setObject:@(waitTime2) forKey:obj2.description];
                    if (waitTime1 < waitTime2) {
                        return NSOrderedAscending;
                    } else if (waitTime1 > waitTime2) {
                        return NSOrderedDescending;
                    } else {
                        return NSOrderedSame;
                    }
                }];
            }
        } break;
        case LNDanmakuDispatchStrategyLowDensity: {
            [mArr sortWithOptions:NSSortStable usingComparator:^NSComparisonResult(LNDanmakuAbstractTrackController  * _Nonnull obj1, LNDanmakuAbstractTrackController   * _Nonnull obj2) {
                NSTimeInterval finishTime1 = [obj1 estimatedFinishTimeForCurrentAttributes];
                NSTimeInterval finishTime2 = [obj2 estimatedFinishTimeForCurrentAttributes];
                if (finishTime1 < finishTime2) {
                    return NSOrderedAscending;
                } else if (finishTime1 > finishTime2) {
                    return NSOrderedDescending;
                } else {
                    return NSOrderedSame;
                }
            }];
        } break;
        default: {
            
        } break;
    }
    
    for (LNDanmakuAbstractTrackController *trackController in mArr) {
        if (self.restGrainNum > 0) {
            LNDanmakuAbstractAttributes *attributes = [self.attributesQueue pop];
            if (self.delegate && [self.delegate respondsToSelector:@selector(dispatcher:willDispatch:to:)]) {
                [self.delegate dispatcher:self willDispatch:attributes to:trackController];
            }
            [trackController loadAttributes:attributes];
            [self decreaseRestGrainNum];
            if (self.delegate && [self.delegate respondsToSelector:@selector(dispatcher:didDispatch:to:)]) {
                [self.delegate dispatcher:self didDispatch:attributes to:trackController];
            }
        } else {
            break;
        }
    }
}

- (void)insertNewAttributes:(NSArray<LNDanmakuAbstractAttributes *> *)newAttributesArray
{
    for (LNDanmakuAbstractAttributes *attributes in newAttributesArray) {
        [self.attributesQueue push:attributes];
    }
}

- (void)insertHighPriorityAttributes:(NSArray<LNDanmakuAbstractAttributes *> *)highPriorityAttributesArray
{
    for (LNDanmakuAbstractAttributes *attributes in highPriorityAttributesArray) {
        [self.attributesQueue push:attributes priority:LNDanmakuDispatchQueuePriorityHigh];
    }
}

- (void)clear
{
    NSArray<LNDanmakuAbstractAttributes *> *clearedAttributesArr = [self.attributesQueue clearQueue];
    if (self.delegate && [self.delegate respondsToSelector:@selector(dispatcher:clear:)]) {
        [self.delegate dispatcher:self clear:clearedAttributesArr];
    }
}

- (BOOL)containsAttributes:(LNDanmakuAbstractAttributes *)attributes
{
    if ([self.attributesQueue contains:attributes]) {
        return YES;
    }
    return NO;
}

- (void)removeAttributes:(LNDanmakuAbstractAttributes *)attributes
{
    if ([self.attributesQueue contains:attributes]) {
        [self.attributesQueue remove:attributes];
    }
}

- (LNDanmakuDispatchQueue *)attributesQueue
{
    if (!_attributesQueue) {
        _attributesQueue = [[LNDanmakuDispatchQueue alloc] init];
        _attributesQueue.delegate = self;
    }
    return _attributesQueue;
}

- (void)danmakuDispatchQueueDidDrop:(LNDanmakuAbstractAttributes *)attributes
{
    //满了
    if (self.delegate && [self.delegate respondsToSelector:@selector(dispatcher:drop:)]) {
        [self.delegate dispatcher:self drop:attributes];
    }
}

@end

@implementation LNDanmakuDispatcher (Recover)

- (void)recoverInsertAttributes:(NSArray<LNDanmakuAbstractAttributes *> *)attributesArray toTrackControllers:(NSArray<LNDanmakuAbstractTrackController *> *)trackControllerArray
{
    for (LNDanmakuAbstractAttributes *attributes in attributesArray) {
        [self _recoverInsertOneAttributes:attributes to:trackControllerArray];
    }
}

- (void)_recoverInsertOneAttributes:(LNDanmakuAbstractAttributes *)attributes to:(NSArray<LNDanmakuAbstractTrackController *> *)trackControllerArray
{
    trackControllerArray = [self getFreeTrackControllers:trackControllerArray];
    LNDanmakuAbstractTrackController *targetTrackController = [trackControllerArray firstObject];
    switch (self.recoverDispatcherStrategy) {
        case LNDanmakuRecoverDispatchStrategyMostFastDisplay: {
            LNDanmakuAbstractAttributes *targetAttributes = attributes;
            NSTimeInterval maxAliveTime = -1.f;
            if (targetAttributes) {
                for (LNDanmakuAbstractTrackController * obj in trackControllerArray) {
                    NSTimeInterval currentAliveTime = MIN([obj estimatedMaxAliveTimeFor:targetAttributes],targetAttributes.currentAliveTime);
                    if (currentAliveTime > maxAliveTime) {
                        maxAliveTime = currentAliveTime;
                        targetTrackController = obj;
                    }
                }
            }
        } break;
        case LNDanmakuRecoverDispatchStrategyLowDensity: {
            LNDanmakuAbstractAttributes *targetAttributes = attributes;
            NSTimeInterval minFinishTime = MAXFLOAT;
            if (targetAttributes) {
                for (LNDanmakuAbstractTrackController * obj in trackControllerArray) {
                    NSTimeInterval currentFinishTime = [obj estimatedFinishTimeForCurrentAttributes];
                    if (currentFinishTime < minFinishTime) {
                        minFinishTime = currentFinishTime;
                        targetTrackController = obj;
                    }
                }
            }
        } break;
        default: {
            
        }break;
    }
    
    if (targetTrackController) {
        NSTimeInterval maxAliveTime = [targetTrackController estimatedMaxAliveTimeFor:attributes];
        if (maxAliveTime >= 0.f) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(dispatcher:willDispatch:to:)]) {
                [self.delegate dispatcher:self willDispatch:attributes to:targetTrackController];
            }
            attributes.currentAliveTime = MIN(maxAliveTime, attributes.currentAliveTime);
            [targetTrackController recoverLoadAttributes:attributes];
            if (self.delegate && [self.delegate respondsToSelector:@selector(dispatcher:didDispatch:to:)]) {
                [self.delegate dispatcher:self didDispatch:attributes to:targetTrackController];
            }
        } else {
            [self.attributesQueue push:attributes];
        }
    } else {
        [self.attributesQueue push:attributes];
    }
}

@end

