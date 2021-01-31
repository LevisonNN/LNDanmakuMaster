//
//  LNDanmakuAbstractAttributes.h
//  LNDanmakuMaster
//
//  Created by Levison on 31.1.21.
//  Copyright © 2021 Levison. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class LNDanmakuAbstractAttributes;

//track
@protocol LNDanmakuAttributesUpdater <NSObject>

@required
- (void)resetAttributes:(LNDanmakuAbstractAttributes *)attributes;
- (void)updateAttributes:(LNDanmakuAbstractAttributes *)attributes;

@end

/*
 * Use LNDanmakuAttributes instead.
 */

@interface LNDanmakuAbstractAttributes : NSObject

//This property depends on what kind of track you want define.
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGPoint position;
@property (nonatomic, assign) CATransform3D transform;
@property (nonatomic, assign) float opacity;

//Normally, TrackControllers use
//Seek/recover may also set this property at the beginning.
//If you must change this property in other cases, be careful.
@property (nonatomic, assign) NSTimeInterval currentAliveTime;


//Will totally disappear
@property (nonatomic, assign) NSTimeInterval danmakuTime;
//did totally disappear
@property (nonatomic, assign) NSTimeInterval trackTime;
//danmakuTime + trackTime
@property (nonatomic, assign, readonly) NSTimeInterval totalAliveTime;//danmakuTime + trackTime
//(currentAliveTime/totalAliveTime)
@property (nonatomic, assign, readonly) float currentPercent;

@property (nonatomic, strong) id customObj;

//priority: layer > view， needs [super setPresentLayer:presentLayer];
@property (nonatomic, strong) CALayer * _Nullable presentLayer;
@property (nonatomic, strong) UIView * _Nullable presentView;

@end

NS_ASSUME_NONNULL_END
