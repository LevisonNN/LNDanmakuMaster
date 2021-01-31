//
//  LNDanmakuLayer.h
//  LNDanmakuMaster
//
//  Created by Levison on 31.1.21.
//  Copyright © 2021 Levison. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/*
 * Help user make a screenshot for a complex but stable view.
 **/

/*
 * If user choose other subclass of CALayer, should cancel CAAnimation.
 **/

@interface LNDanmakuLayer : CALayer

+ (LNDanmakuLayer *)danmakuLayerWithView:(UIView *)view;
+ (UIImage *)captureImageForLayer:(CALayer *)layer;

@end

NS_ASSUME_NONNULL_END
