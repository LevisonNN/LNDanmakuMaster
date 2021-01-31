//
//  LNDanmakuAbstractTrackController.m
//  LNDanmakuMaster
//
//  Created by Levison on 31.1.21.
//  Copyright © 2021 Levison. All rights reserved.
//

#import "LNDanmakuAbstractTrackController.h"

static NSInteger currentDanmakuNum;


@interface LNDanmakuAbstractTrackController ()


@end

@implementation LNDanmakuAbstractTrackController

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)update:(NSTimeInterval)elapsingTime
{
    
}

- (void)clearTrack
{
    
}

- (BOOL)isFree
{
    return NO;
}

- (NSTimeInterval)estimatedFinishTimeForCurrentAttributes
{
    return 0;
}

- (NSTimeInterval)estimatedMinDisplayWaitTimeFor:(LNDanmakuAbstractAttributes *)attributes
{
    return 0;
}

- (BOOL)couldLoadNewAttributes:(LNDanmakuAbstractAttributes *)attributes
{
    return NO;
}

- (BOOL)containsAttributes:(LNDanmakuAbstractAttributes *)attributes
{
    return NO;
}

- (void)loadAttributes:(LNDanmakuAbstractAttributes *)attributes
{
    if (isNeedDanmakuCountDanmakuNumber) {
        currentDanmakuNum ++;
        NSLog(@"Danmaku count:%ld",(long)currentDanmakuNum);
    }
}

- (void)unloadAttributes:(LNDanmakuAbstractAttributes *)attributes
{
    if (isNeedDanmakuCountDanmakuNumber) {
        currentDanmakuNum --;
        NSLog(@"Danmaku count:%ld",(long)currentDanmakuNum);
    }
}

@end

@implementation LNDanmakuAbstractTrackController (Recover)

- (NSTimeInterval)estimatedMaxAliveTimeFor:(LNDanmakuAbstractAttributes *)attributes
{
    return 0.f;
}

- (void)recoverLoadAttributes:(LNDanmakuAbstractAttributes *)attributes
{
    
}

@end
