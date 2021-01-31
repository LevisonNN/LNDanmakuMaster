//
//  LNDanmakuAbstractDispatcher.h
//  LNDanmakuMaster
//
//  Created by Levison on 31.1.21.
//  Copyright © 2021 Levison. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LNDanmakuAbstractAttributes.h"
#import "LNDanmakuAbstractTrackController.h"
#import "LNDanmakuClock.h"

NS_ASSUME_NONNULL_BEGIN

@class LNDanmakuAbstractDispatcher;

@protocol LNDanmakuAbstractDispatcherDelegate <NSObject>

@optional
- (void)dispatcher:(LNDanmakuAbstractDispatcher *)dispatcher
      willDispatch:(LNDanmakuAbstractAttributes *)attributes
                to:(LNDanmakuAbstractTrackController *)trackController;
- (void)dispatcher:(LNDanmakuAbstractDispatcher *)dispatcher
       didDispatch:(LNDanmakuAbstractAttributes *)attributes
                to:(LNDanmakuAbstractTrackController *)trackController;

- (void)dispatcher:(LNDanmakuAbstractDispatcher *)dispatcher
              drop:(LNDanmakuAbstractAttributes *)attributes;

- (void)dispatcher:(LNDanmakuAbstractDispatcher *)dispatcher
             clear:(NSArray<LNDanmakuAbstractAttributes *> *)attributesArr;

@end

@protocol LNDanmakuAbstractDispatcherSmoothGrainDataSource <NSObject>

@required
- (NSInteger)restGrainNumForDispatcher:(LNDanmakuAbstractDispatcher *)dispatcher;
- (void)decreaseGrainNumForDispatcher:(LNDanmakuAbstractDispatcher *)dispatcher;

@end

@interface LNDanmakuAbstractDispatcher : NSObject <LNDanmakuClockDelegate>

@property (nonatomic, weak) id <LNDanmakuAbstractDispatcherDelegate> delegate;

@property (nonatomic, weak) id <LNDanmakuAbstractDispatcherSmoothGrainDataSource> grainDataSource;

@property (nonatomic, assign) NSInteger maxSmoothGrainNum;

- (NSInteger)restGrainNum;
- (void)decreaseRestGrainNum;

@end

@interface LNDanmakuAbstractDispatcher (Override)

//private use
- (void)dispatchNewAttributesToFreeTracks:(NSArray<LNDanmakuAbstractTrackController *> *)trackControllerArray;

//public use
- (void)insertNewAttributes:(NSArray <LNDanmakuAbstractAttributes *> *)newAttributesArray;
- (void)insertHighPriorityAttributes:(NSArray <LNDanmakuAbstractAttributes *> *)highPriorityAttributesArray;
- (void)clear;
- (BOOL)containsAttributes:(LNDanmakuAbstractAttributes *)attributes;
- (void)removeAttributes:(LNDanmakuAbstractAttributes *)attributes;
@end

@interface LNDanmakuAbstractDispatcher (Recover)

- (void)recoverInsertAttributes:(NSArray <LNDanmakuAbstractAttributes *> *)attributesArray toTrackControllers:(NSArray<LNDanmakuAbstractTrackController *> *)trackControllerArray;

@end


NS_ASSUME_NONNULL_END
