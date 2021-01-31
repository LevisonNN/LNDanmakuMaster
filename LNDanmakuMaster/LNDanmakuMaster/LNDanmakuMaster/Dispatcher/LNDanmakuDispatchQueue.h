//
//  LNDanmakuDispatchQueue.h
//  LNDanmakuMaster
//
//  Created by Levison on 31.1.21.
//  Copyright © 2021 Levison. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LNDanmakuAbstractAttributes.h"

NS_ASSUME_NONNULL_BEGIN

/*
 * Every dispatch queue has two subqueues:
 * Default queue: For those danmaku which is loaded from server at begining.
 * High priority queue: For those danmaku user just send or other cases.
 * When poping, dispatch queue will visit high priority queue first, if high priority queue is empty then visit default queue.
 **/

typedef NS_ENUM(NSInteger, LNDanmakuDispatchQueuePriority)
{
    LNDanmakuDispatchQueuePriorityDefault = 0,
    LNDanmakuDispatchQueuePriorityHigh
};


@protocol LNDanmakuDispatchQueueDelegate <NSObject>

@optional
- (void)danmakuDispatchQueueDidDrop:(LNDanmakuAbstractAttributes *)attributes;

@end

@interface LNDanmakuDispatchQueue : NSObject

@property (nonatomic, weak) id <LNDanmakuDispatchQueueDelegate> delegate;

@property (nonatomic, assign) NSInteger maxCapacity;

- (void)push:(LNDanmakuAbstractAttributes *)attributes;//defaultPriority
- (void)push:(LNDanmakuAbstractAttributes *)attributes priority:(LNDanmakuDispatchQueuePriority)priority;
- (LNDanmakuAbstractAttributes *)top;
- (LNDanmakuAbstractAttributes *)pop;

- (NSArray<LNDanmakuAbstractAttributes *> *)clearQueue;
- (BOOL)contains:(LNDanmakuAbstractAttributes *)attributes;
- (void)remove:(LNDanmakuAbstractAttributes *)attributes;
- (BOOL)isEmpty;

@end

NS_ASSUME_NONNULL_END
