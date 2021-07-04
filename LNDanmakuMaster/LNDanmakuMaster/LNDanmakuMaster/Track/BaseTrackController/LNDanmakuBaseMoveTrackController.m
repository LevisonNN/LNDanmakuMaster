//
//  LNDanmakuBaseMoveTrackController.m
//  LNDanmakuMaster
//
//  Created by Levison on 31.1.21.
//  Copyright © 2021 Levison. All rights reserved.
//

#import "LNDanmakuBaseMoveTrackController.h"

@interface LNDanmakuBaseMoveTrackController ()

@property (nonatomic, strong) NSMutableSet<LNDanmakuAbstractAttributes *> *currentAttributesMSet;
@property (nonatomic, strong) LNDanmakuAbstractAttributes *candidateAttributes;

@property (nonatomic, strong) LNDanmakuAbstractAttributes *lastAttributes;

@end

@implementation LNDanmakuBaseMoveTrackController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.spaceTimeInterval = 0.2f;
    }
    return self;
}

- (void)update:(NSTimeInterval)elapsingTime
{
    if (elapsingTime < 0.f) {
        return;
    }
    
    if (elapsingTime < 0.018 && elapsingTime > 0.016) {
        elapsingTime = 0.0167;
    }
    
    NSMutableSet<LNDanmakuAbstractAttributes *> *shouldUnloadAttributes = [[NSMutableSet alloc] init];
    for (LNDanmakuAbstractAttributes *attributes in self.currentAttributesMSet) {
        attributes.currentAliveTime += elapsingTime;
        NSTimeInterval restAliveTime = attributes.totalAliveTime - attributes.currentAliveTime;
        //NSLog(@"%lf --- %lf", attributes.currentAliveTime ,restAliveTime);
        if (restAliveTime > self.lastAttributes.totalAliveTime - self.lastAttributes.currentAliveTime) {
            self.lastAttributes = attributes;
        }
        if (restAliveTime <= 0) {
            [shouldUnloadAttributes addObject:attributes];
        } else {
            [self.track updateAttributes:attributes];
        }
    }
    
    for (LNDanmakuAbstractAttributes *attributes in shouldUnloadAttributes) {
        [self unloadAttributes:attributes];
    }
    [self checkCanLoadCandidate];
}

- (void)clearTrack
{
    NSSet<LNDanmakuAbstractAttributes *> *attributesArr = [NSSet setWithSet:self.currentAttributesMSet];
    for (LNDanmakuAbstractAttributes *attributes in attributesArr) {
        [self unloadAttributes:attributes];
    }
    if (self.candidateAttributes) {
        [self unloadAttributes:self.candidateAttributes];
    }
}

- (void)checkCanLoadCandidate
{
    if (self.candidateAttributes) {
        BOOL canLoadCandidate = NO;
        if (!self.lastAttributes) {
            canLoadCandidate = YES;
        } else {
            if (self.candidateAttributes.trackTime >= self.lastAttributes.totalAliveTime - self.lastAttributes.currentAliveTime + self.spaceTimeInterval &&
                self.lastAttributes.currentAliveTime >= self.lastAttributes.danmakuTime + self.spaceTimeInterval) {
                canLoadCandidate = YES;
            } else {
                canLoadCandidate = NO;
            }
        }
        
        if (canLoadCandidate) {
            [self.currentAttributesMSet addObject:self.candidateAttributes];
            [self.viewDelegate viewShouldLoadAttributes:self.candidateAttributes];
            [self.track updateAttributes:self.candidateAttributes];
            NSTimeInterval restAliveTime = self.candidateAttributes.totalAliveTime - self.candidateAttributes.currentAliveTime;
            if (restAliveTime > self.lastAttributes.totalAliveTime - self.lastAttributes.currentAliveTime) {
                self.lastAttributes = self.candidateAttributes;
            }
            self.candidateAttributes = nil;
        }
    }
}

- (BOOL)isFree
{
    if (self.candidateAttributes) {
        return NO;
    }
    return YES;
}

- (NSTimeInterval)estimatedFinishTimeForCurrentAttributes
{
    if (self.lastAttributes) {
        if (self.candidateAttributes) {
            return MAX(self.candidateAttributes.trackTime, self.lastAttributes.totalAliveTime - self.lastAttributes.currentAliveTime + self.spaceTimeInterval) + self.candidateAttributes.danmakuTime;
        }
        return self.lastAttributes.totalAliveTime - self.lastAttributes.currentAliveTime;
    } else {
        return 0.f;
    }
}

- (NSTimeInterval)estimatedMinDisplayWaitTimeFor:(LNDanmakuAbstractAttributes *)attributes
{
    NSTimeInterval estimatedTime = 0.0;
    if (self.candidateAttributes) {
        estimatedTime = 1000.0;
    } else {
        if (!self.lastAttributes) {
            estimatedTime = 0.0;
        } else {
            if (self.lastAttributes.currentAliveTime <= self.lastAttributes.danmakuTime) {
                //last danmaku is not totally displayed.
                NSTimeInterval lowSpeedMaxWaitTime = self.lastAttributes.danmakuTime - self.lastAttributes.currentAliveTime + self.spaceTimeInterval;
                NSTimeInterval highSpeedMaxWaitTime = (self.lastAttributes.totalAliveTime - self.lastAttributes.currentAliveTime) - (attributes.trackTime - self.spaceTimeInterval);
                estimatedTime = MAX(0.0, MAX(highSpeedMaxWaitTime, lowSpeedMaxWaitTime));
            } else if (self.lastAttributes.currentAliveTime - self.lastAttributes.danmakuTime < self.spaceTimeInterval){
                //last danmaku totally displayed，consider some time spacing.
                NSTimeInterval lowSpeedMaxWaitTime = self.spaceTimeInterval - (self.lastAttributes.currentAliveTime - self.lastAttributes.danmakuTime);
                NSTimeInterval highSpeedMaxWaitTime = (self.lastAttributes.totalAliveTime - self.lastAttributes.currentAliveTime) - (attributes.trackTime - self.spaceTimeInterval);
                estimatedTime = MAX(0.0, MAX(highSpeedMaxWaitTime, lowSpeedMaxWaitTime));
            } else {
                //last danmaku totally displayed, and no time spacing.
                NSTimeInterval lowSpeedMaxWaitTime = 0.0;
                NSTimeInterval highSpeedMaxWaitTime = (self.lastAttributes.totalAliveTime - self.lastAttributes.currentAliveTime) - (attributes.trackTime - self.spaceTimeInterval);
                estimatedTime = MAX(0.0, MAX(highSpeedMaxWaitTime, lowSpeedMaxWaitTime));
            }
        }
    }
    return estimatedTime;
}

//recover

- (NSTimeInterval)estimatedMaxAliveTimeFor:(LNDanmakuAbstractAttributes *)attributes
{
    if (self.candidateAttributes) {
        return -1.f;
    } else if (self.lastAttributes) {
        NSTimeInterval lastRestTrackTime = self.lastAttributes.totalAliveTime - self.lastAttributes.currentAliveTime;
        if (self.lastAttributes.currentAliveTime > self.lastAttributes.danmakuTime + self.spaceTimeInterval && attributes.trackTime > lastRestTrackTime +  self.spaceTimeInterval) {
            return MIN(attributes.trackTime - (lastRestTrackTime + self.spaceTimeInterval), self.lastAttributes.currentAliveTime - self.lastAttributes.danmakuTime - self.spaceTimeInterval) ;
        } else {
            return 0.f;
        }
    } else {
        return attributes.totalAliveTime;
    }
}

- (void)recoverLoadAttributes:(LNDanmakuAbstractAttributes *)attributes
{
    if (![self isFree]) {
        return;
    }
    
    if ([self containsAttributes:attributes]) {
        return;
    }
    
    [super recoverLoadAttributes:attributes];
    
    NSTimeInterval maxAliveTime = [self estimatedMaxAliveTimeFor:attributes];
    if (maxAliveTime > 0.f) {
        [self.currentAttributesMSet addObject:attributes];
        [self.viewDelegate viewShouldLoadAttributes:attributes];
        [self.track updateAttributes:attributes];
        NSTimeInterval restAliveTime = attributes.totalAliveTime - attributes.currentAliveTime;
        if (restAliveTime > self.lastAttributes.totalAliveTime - self.lastAttributes.currentAliveTime) {
            self.lastAttributes = attributes;
        }
    } else if (maxAliveTime == 0.f){
        self.candidateAttributes = attributes;
    } else {
        return;
    }
}

//recover

- (BOOL)containsAttributes:(LNDanmakuAbstractAttributes *)attributes
{
    if ([self.currentAttributesMSet containsObject:attributes] || self.candidateAttributes == attributes) {
        return YES;
    }
    return NO;
}

- (void)loadAttributes:(LNDanmakuAbstractAttributes *)attributes
{
    if (![self isFree]) {
        return;
    }
    
    if ([self containsAttributes:attributes]) {
        return;
    }
    [self.track resetAttributes:attributes];
    [super loadAttributes:attributes];
    self.candidateAttributes = attributes;
}

- (void)unloadAttributes:(LNDanmakuAbstractAttributes *)attributes
{
    if (![self containsAttributes:attributes]) {
        return;
    }
    
    if ([self.currentAttributesMSet containsObject:attributes]) {
        [super unloadAttributes:attributes];
        [self.currentAttributesMSet removeObject:attributes];
        [self.viewDelegate viewShouldRemoveAttributes:attributes];
    } else if (self.candidateAttributes == attributes) {
        [super unloadAttributes:attributes];
        self.candidateAttributes = nil;
    }
    
    if (attributes == self.lastAttributes) {
        self.lastAttributes = nil;
    }
}

- (NSMutableSet<LNDanmakuAbstractAttributes *> *)currentAttributesMSet
{
    if (!_currentAttributesMSet) {
        _currentAttributesMSet = [[NSMutableSet alloc] init];
    }
    return _currentAttributesMSet;
}

@end
