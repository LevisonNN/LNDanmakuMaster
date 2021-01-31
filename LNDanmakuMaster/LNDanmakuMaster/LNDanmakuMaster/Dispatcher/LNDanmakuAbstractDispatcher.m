//
//  LNDanmakuAbstractDispatcher.m
//  LNDanmakuMaster
//
//  Created by Levison on 31.1.21.
//  Copyright © 2021 Levison. All rights reserved.
//

#import "LNDanmakuAbstractDispatcher.h"

@interface LNDanmakuAbstractDispatcher ()

@property (nonatomic, assign) NSInteger pRestGrainNum;

@end

@implementation LNDanmakuAbstractDispatcher

//override
- (void)dispatchNewAttributesToFreeTracks:(NSArray<LNDanmakuAbstractTrackController *> *)trackControllerArray
{
    for (LNDanmakuAbstractTrackController *trackController in trackControllerArray) {
        if (trackController.isFree) {
            if (self.restGrainNum > 0) {
                [self decreaseRestGrainNum];
            } else {
                break;
            }
        }
    }
}
//override
- (void)insertNewAttributes:(NSArray<LNDanmakuAbstractAttributes *> *)newAttributesArray
{

}

- (void)insertHighPriorityAttributes:(NSArray<LNDanmakuAbstractAttributes *> *)highPriorityAttributesArray
{
    
}

- (void)clear
{
    
}

- (BOOL)containsAttributes:(LNDanmakuAbstractAttributes *)attributes
{
    return NO;
}

- (void)removeAttributes:(LNDanmakuAbstractAttributes *)attributes
{
}

- (void)setMaxSmoothGrainNum:(NSInteger)maxSmoothGrainNum
{
    if (maxSmoothGrainNum <= 1) {
        _maxSmoothGrainNum = 1;
    }
    _maxSmoothGrainNum = maxSmoothGrainNum;
}

- (NSInteger)restGrainNum
{
    NSInteger superRestGrain = NSIntegerMax;
    if (self.grainDataSource && [self.grainDataSource respondsToSelector:@selector(restGrainNumForDispatcher:)]) {
        superRestGrain = [self.grainDataSource restGrainNumForDispatcher:self];
    }
    NSInteger realRestGrain = MIN(superRestGrain, self.pRestGrainNum);
    return realRestGrain;
}

- (void)decreaseRestGrainNum
{
    self.pRestGrainNum--;
    if (self.grainDataSource && [self.grainDataSource respondsToSelector:@selector(decreaseGrainNumForDispatcher:)]) {
        [self.grainDataSource decreaseGrainNumForDispatcher:self];
    }
}

- (void)danmakuClockUpdateTimeInterval:(NSTimeInterval)time
{
    self.pRestGrainNum = self.maxSmoothGrainNum;
}

@end

@implementation LNDanmakuAbstractDispatcher (Recover)

- (void)recoverInsertAttributes:(NSArray<LNDanmakuAbstractAttributes *> *)attributesArray toTrackControllers:(nonnull NSArray<LNDanmakuAbstractTrackController *> *)trackControllerArray
{
    
}

@end

