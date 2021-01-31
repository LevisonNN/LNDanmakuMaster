//
//  LNDanmakuBaseFreeTrackController.m
//  LNDanmakuMaster
//
//  Created by Levison on 31.1.21.
//  Copyright © 2021 Levison. All rights reserved.
//

#import "LNDanmakuBaseFreeTrackController.h"

@interface LNDanmakuBaseFreeTrackController ()

@property (nonatomic, strong) NSMutableSet *currentAttributesMSet;
@property (nonatomic, strong) LNDanmakuAbstractAttributes *firstAttributes;
@property (nonatomic, strong) LNDanmakuAbstractAttributes *lastAttributes;

@end

@implementation LNDanmakuBaseFreeTrackController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.maxCapacity = 100.f;
    }
    return self;
}

- (void)update:(NSTimeInterval)elapsingTime
{
    if (elapsingTime < 0.f) {
        return;
    }
    
    NSMutableSet<LNDanmakuAbstractAttributes *> *shouldUnloadAttributes = [[NSMutableSet alloc] init];
    for (LNDanmakuAbstractAttributes *attributes in self.currentAttributesMSet) {
        attributes.currentAliveTime += elapsingTime;
        NSTimeInterval restAliveTime = attributes.totalAliveTime - attributes.currentAliveTime;
        if (restAliveTime > self.lastAttributes.totalAliveTime - self.lastAttributes.currentAliveTime) {
            self.lastAttributes = attributes;
        }
        
        if (!self.firstAttributes) {
            self.firstAttributes = attributes;
        } else if (restAliveTime < self.firstAttributes.totalAliveTime - self.firstAttributes.currentAliveTime) {
            self.firstAttributes = attributes;
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
}

- (void)clearTrack
{
    NSSet<LNDanmakuAbstractAttributes *> *attributesArr = [NSSet setWithSet:self.currentAttributesMSet];
    for (LNDanmakuAbstractAttributes *attributes in attributesArr) {
        [self unloadAttributes:attributes];
    }
}

- (BOOL)isFree
{
    if (self.currentAttributesMSet.count < self.maxCapacity) {
        return YES;
    }
    return NO;
}

- (BOOL)containAttributes:(LNDanmakuAbstractAttributes *)attributes
{
    if ([self.currentAttributesMSet containsObject:attributes]) {
        return YES;
    }
    return NO;
}

- (NSTimeInterval)estimatedFinishTimeForCurrentAttributes
{
    if (self.lastAttributes) {
        return self.lastAttributes.totalAliveTime - self.lastAttributes.currentAliveTime;
    } else {
        return 0.f;
    }
}

- (NSTimeInterval)estimatedMinDisplayWaitTimeFor:(LNDanmakuAbstractAttributes *)attributes
{
    if (self.currentAttributesMSet.count < self.maxCapacity) {
        return 0.f;
    } else if (self.firstAttributes) {
        return self.firstAttributes.totalAliveTime - self.firstAttributes.currentAliveTime;
    } else {
        return CGFLOAT_MAX;
    }
}

//recover
- (NSTimeInterval)estimatedMaxAliveTimeFor:(LNDanmakuAbstractAttributes *)attributes
{
    if (self.isFree) {
        return attributes.totalAliveTime;
    } else {
        return -1.f;
    }
}

- (void)recoverLoadAttributes:(LNDanmakuAbstractAttributes *)attributes
{
    if (![self isFree]) {
        return;
    }
    
    if ([self containAttributes:attributes]) {
        return;
    }
    
    [super recoverLoadAttributes:attributes];
    //TODO 实现
    NSTimeInterval maxAliveTime = [self estimatedMaxAliveTimeFor:attributes];
    if (maxAliveTime > 0.f) {
        [self.currentAttributesMSet addObject:attributes];
        [self.viewDelegate viewShouldLoadAttributes:attributes];
        [self.track updateAttributes:attributes];
        NSTimeInterval restAliveTime = attributes.totalAliveTime - attributes.currentAliveTime;
        if (restAliveTime > self.lastAttributes.totalAliveTime - self.lastAttributes.currentAliveTime) {
            self.lastAttributes = attributes;
        }
    } else {
        return;
    }
}

//recover

- (void)loadAttributes:(LNDanmakuAbstractAttributes *)attributes
{
    if (![self isFree]) {
        return;
    }
    
    if ([self containAttributes:attributes]) {
        return;
    }

    [self.track resetAttributes:attributes];
    [super loadAttributes:attributes];
    
    [self.currentAttributesMSet addObject:attributes];
    [self.viewDelegate viewShouldLoadAttributes:attributes];
}

- (void)unloadAttributes:(LNDanmakuAbstractAttributes *)attributes
{
    if ([self containAttributes:attributes]) {
        [super unloadAttributes:attributes];
        [self.viewDelegate viewShouldRemoveAttributes:attributes];
        [self.currentAttributesMSet removeObject:attributes];
    }
    
    if (attributes == self.lastAttributes) {
        self.lastAttributes = nil;
    }
    
    if (attributes == self.firstAttributes) {
        self.firstAttributes = nil;
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
