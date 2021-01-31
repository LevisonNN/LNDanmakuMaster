//
//  LNDanmakuDispatchQueue.m
//  LNDanmakuMaster
//
//  Created by Levison on 31.1.21.
//  Copyright © 2021 Levison. All rights reserved.
//

#import "LNDanmakuDispatchQueue.h"

@interface LNDanmakuDispatchSubQueue : NSObject

@property (nonatomic, strong) NSMutableOrderedSet <LNDanmakuAbstractAttributes *> *mSet;

@end

@implementation LNDanmakuDispatchSubQueue

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)push:(LNDanmakuAbstractAttributes *)attributes
{
    if (!attributes) {
        return;
    }
    [self.mSet addObject:attributes];
}

- (LNDanmakuAbstractAttributes *)top
{
    if (self.isEmpty) {
        return nil;
    }
    LNDanmakuAbstractAttributes *attributes = [self.mSet objectAtIndex:0];
    return attributes;
}

- (LNDanmakuAbstractAttributes *)pop
{
    if (self.isEmpty) {
        return nil;
    }
    LNDanmakuAbstractAttributes *attributes = [self.mSet objectAtIndex:0];
    [self.mSet removeObject:attributes];
    return attributes;
}

- (NSArray <LNDanmakuAbstractAttributes *> *)clearQueue
{
    NSArray *resultArray = [self.mSet.array copy];
    [self.mSet removeAllObjects];
    return resultArray;
}

- (BOOL)contains:(LNDanmakuAbstractAttributes *)attributes
{
    if ([self.mSet containsObject:attributes]) {
        return YES;
    }
    return NO;
}

- (void)remove:(LNDanmakuAbstractAttributes *)attributes
{
    [self.mSet removeObject:attributes];
}

- (BOOL)isEmpty
{
    if (self.mSet.count > 0) {
        return NO;
    }
    return YES;
}

- (NSInteger)length
{
    return self.mSet.count;
}

- (NSMutableOrderedSet<LNDanmakuAbstractAttributes *> *)mSet
{
    if (!_mSet) {
        _mSet = [[NSMutableOrderedSet alloc] init];
    }
    return _mSet;
}

@end


@interface LNDanmakuDispatchQueue ()

@property (nonatomic, strong) LNDanmakuDispatchSubQueue *highQueue;
@property (nonatomic, strong) LNDanmakuDispatchSubQueue *defaultQueue;

@end

@implementation LNDanmakuDispatchQueue

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.maxCapacity = 60;
    }
    return self;
}

- (void)setMaxCapacity:(NSInteger)maxCapacity
{
    if (maxCapacity > 0) {
        _maxCapacity = maxCapacity;
    }
}

- (void)push:(LNDanmakuAbstractAttributes *)attributes
{
    if (!attributes) {
        return;
    }
    [self push:attributes priority:LNDanmakuDispatchQueuePriorityDefault];
}

- (void)push:(LNDanmakuAbstractAttributes *)attributes priority:(LNDanmakuDispatchQueuePriority)priority
{
    if (!attributes) {
        return;
    }
    switch (priority) {
        case LNDanmakuDispatchQueuePriorityHigh: {
            [self.highQueue push:attributes];
            while ([self.highQueue length] > self.maxCapacity) {
                LNDanmakuAbstractAttributes *droppedAttributes = [self.highQueue pop];
                if (self.delegate && [self.delegate respondsToSelector:@selector(danmakuDispatchQueueDidDrop:)]) {
                    [self.delegate danmakuDispatchQueueDidDrop:droppedAttributes];
                }
            }
        } break;
        default: {
            [self.defaultQueue push:attributes];
            while ([self.defaultQueue length] > self.maxCapacity) {
                LNDanmakuAbstractAttributes *droppedAttributes = [self.defaultQueue pop];
                if (self.delegate && [self.delegate respondsToSelector:@selector(danmakuDispatchQueueDidDrop:)]) {
                    [self.delegate danmakuDispatchQueueDidDrop:droppedAttributes];
                }
            }
        } break;
    }
}

- (LNDanmakuAbstractAttributes *)top
{
    if (![self.highQueue isEmpty]) {
        return [self.highQueue top];
    }
    return [self.defaultQueue top];
}

- (LNDanmakuAbstractAttributes *)pop
{
    if ([self.highQueue top]) {
        return [self.highQueue pop];
    }
    return [self.defaultQueue pop];
}

- (NSArray<LNDanmakuAbstractAttributes *> *)clearQueue
{
    NSMutableArray <LNDanmakuAbstractAttributes *> *clearedAttributes = [[NSMutableArray alloc] init];
    [clearedAttributes addObjectsFromArray:[self.highQueue clearQueue]];
    [clearedAttributes addObjectsFromArray:[self.defaultQueue clearQueue]];
    return [NSArray arrayWithArray:clearedAttributes];
}

- (BOOL)contains:(LNDanmakuAbstractAttributes *)attributes
{
    if ([self.defaultQueue contains:attributes] || [self.highQueue contains:attributes]) {
        return YES;
    }
    return NO;
}

- (void)remove:(LNDanmakuAbstractAttributes *)attributes
{
    if ([self.defaultQueue contains:attributes]) {
        [self.defaultQueue remove:attributes];
    }
    if ([self.highQueue contains:attributes]) {
        [self.highQueue remove:attributes];
    }
}

- (BOOL)isEmpty
{
    return [self.highQueue isEmpty] && [self.defaultQueue isEmpty];
}

- (LNDanmakuDispatchSubQueue *)highQueue
{
    if (!_highQueue) {
        _highQueue = [[LNDanmakuDispatchSubQueue alloc] init];
    }
    return _highQueue;
}

- (LNDanmakuDispatchSubQueue *)defaultQueue
{
    if (!_defaultQueue) {
        _defaultQueue = [[LNDanmakuDispatchSubQueue alloc] init];
    }
    return _defaultQueue;
}

@end
