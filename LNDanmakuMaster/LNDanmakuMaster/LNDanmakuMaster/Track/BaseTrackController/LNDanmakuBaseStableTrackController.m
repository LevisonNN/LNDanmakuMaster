//
//  LNDanmakuBaseStableTrackController.m
//  LNDanmakuMaster
//
//  Created by Levison on 31.1.21.
//  Copyright © 2021 Levison. All rights reserved.
//

#import "LNDanmakuBaseStableTrackController.h"

@interface LNDanmakuBaseStableTrackController ()

@property (nonatomic, strong) LNDanmakuAbstractAttributes *currentAttributes;

@property (nonatomic, assign) NSTimeInterval freeInterval;

@end

@implementation LNDanmakuBaseStableTrackController

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)update:(NSTimeInterval)elapsingTime
{
    if (self.currentAttributes) {
        self.currentAttributes.currentAliveTime += elapsingTime;
        if (self.currentAttributes.currentAliveTime > self.currentAttributes.totalAliveTime) {
            [self unloadAttributes:self.currentAttributes];
        } else {
            [self.track updateAttributes:self.currentAttributes];
        }
    } else {
        if (self.freeInterval < 2.f) {
            self.freeInterval += elapsingTime;
        }
    }
}

- (void)clearTrack
{
    [self unloadAttributes:self.currentAttributes];
    self.freeInterval = 2.f;
}

- (BOOL)isFree
{
    if (self.currentAttributes == nil && self.freeInterval >= 2.f) {
        return YES;
    }
    return NO;
}

- (BOOL)containsAttributes:(LNDanmakuAbstractAttributes *)attributes
{
    if (self.currentAttributes == attributes) {
        return YES;
    }
    return NO;
}

- (NSTimeInterval)estimatedFinishTimeForCurrentAttributes
{
    if (self.currentAttributes) {
        NSTimeInterval rest = self.currentAttributes.totalAliveTime - self.currentAttributes.currentAliveTime;
        return rest>0.f?rest + 2.f : 2.f;
    } else {
        NSTimeInterval rest = 2.f - self.freeInterval;
        return rest>0.f?rest:0.f;
    }
}

- (NSTimeInterval)estimatedMinDisplayWaitTimeFor:(LNDanmakuAbstractAttributes *)attributes
{
    return [self estimatedFinishTimeForCurrentAttributes];
}

//recover
- (NSTimeInterval)estimatedMaxAliveTimeFor:(LNDanmakuAbstractAttributes *)attributes
{
    if (self.estimatedFinishTimeForCurrentAttributes > 0.f) {
        return -1.f;
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
    if (maxAliveTime >= 0.f) {
        self.currentAttributes = attributes;
        [self.viewDelegate viewShouldLoadAttributes:attributes];
        [self.track updateAttributes:attributes];
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
    
    if (!attributes || attributes == self.currentAttributes) {
        return;
    }
    
    [self.track resetAttributes:attributes];
    [super loadAttributes:attributes];
    self.currentAttributes = attributes;
    [self.viewDelegate viewShouldLoadAttributes:attributes];
    [self.track updateAttributes:attributes];
    self.freeInterval = 0.f;
}

- (void)unloadAttributes:(LNDanmakuAbstractAttributes *)attributes
{
    if (attributes == self.currentAttributes && attributes) {
        [super unloadAttributes:attributes];
        [self.viewDelegate viewShouldRemoveAttributes:attributes];
        self.currentAttributes = nil;
    }
}

@end
