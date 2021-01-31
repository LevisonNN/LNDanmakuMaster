//
//  DispatcherDemoViewController.h
//  LNDanmakuMaster
//
//  Created by Levison on 31.1.21.
//  Copyright © 2021 Levison. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/*
 * 这个Demo用来演示如何应用不同的分发策略来顺应不同轨道
 * Default: 从上到下寻找第一个可以放置的轨道分发
 * LowDensity: 从上到下寻找最空闲的轨道分发
 * MostFast: 从上到下寻找可以放置，且能最快显示的轨道分发
 * 统一选择条形轨道演示
 **/

/*
 * 三种分布策略的差别仅在松散的状态下才能看出差别，拥塞状态下都是全充满的
 **/

typedef NS_ENUM(NSInteger, DispatcherDemoViewControllerType)
{
    DispatcherDemoViewControllerDefault = 0,
    DispatcherDemoViewControllerLowDensity,
    DispatcherDemoViewControllerMostFast,
};


@interface DispatcherDemoViewController : UIViewController

- (instancetype)initWithType:(DispatcherDemoViewControllerType)type;

@end

NS_ASSUME_NONNULL_END
