//
//  LNDanmakuSinTrack.m
//  LNDanmakuMaster
//
//  Created by Levison on 31.1.21.
//  Copyright © 2021 Levison. All rights reserved.
//

#import "LNDanmakuSinTrack.h"

@interface LNDanmakuSinTrack ()

@end

@implementation LNDanmakuSinTrack

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.T = 1.f;
        self.A = 20.f;
    }
    return self;
}

- (void)updateAttributes:(LNDanmakuAbstractAttributes *)attributes
{
    [super updateAttributes:attributes];
    
    float percent = attributes.currentPercent;
    
    CGFloat alpha = M_PI * 2.f * (percent/self.T);
    CGFloat bias = sin(alpha) * self.A;
    
    CGFloat totalDistance = self.width + attributes.size.width;
    CGFloat currentDistance = totalDistance * percent;
    CGFloat currentX = self.startPosition.x + self.width - currentDistance;
    CGFloat currentY = self.startPosition.y - attributes.size.height/2.f + bias;

    attributes.position = CGPointMake(currentX, currentY);
    
    CGAffineTransform affine = CGAffineTransformMakeRotation(-atan(cos(alpha)));
    attributes.transform = CATransform3DMakeAffineTransform(affine);
}

@end
