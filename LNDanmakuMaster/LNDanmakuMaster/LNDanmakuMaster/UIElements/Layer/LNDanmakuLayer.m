//
//  LNDanmakuLayer.m
//  LNDanmakuMaster
//
//  Created by Levison on 31.1.21.
//  Copyright © 2021 Levison. All rights reserved.
//

#import "LNDanmakuLayer.h"

@implementation LNDanmakuLayer

+ (LNDanmakuLayer *)danmakuLayerWithView:(UIView *)view
{
    UIImage *renderedImage = nil;
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, 0.0, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    renderedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    LNDanmakuLayer *danmakuLayer = [[LNDanmakuLayer alloc] init];
    danmakuLayer.bounds = view.bounds;
    danmakuLayer.contents = (id)renderedImage.CGImage;
    return danmakuLayer;
}

+ (UIImage *)captureImageForLayer:(CALayer *)layer
{
    UIImage *renderedImage = nil;
    UIGraphicsBeginImageContextWithOptions(layer.bounds.size, 0.0, [UIScreen mainScreen].scale);
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    renderedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return renderedImage;
}

- (id<CAAction>)actionForKey:(NSString *)event
{
    return nil;
}

@end
