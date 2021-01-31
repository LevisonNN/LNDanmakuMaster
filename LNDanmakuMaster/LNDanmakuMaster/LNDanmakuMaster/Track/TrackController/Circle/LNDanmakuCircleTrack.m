//
//  LNDanmakuCircleTrack.m
//  LNDanmakuMaster
//
//  Created by Levison on 31.1.21.
//  Copyright © 2021 Levison. All rights reserved.
//

#import "LNDanmakuCircleTrack.h"

@implementation LNDanmakuCircleTrack

- (void)updateAttributes:(LNDanmakuAbstractAttributes *)attributes
{
    [super updateAttributes:attributes];
    
    float percent = attributes.currentPercent;
    float angle = percent * 2 * M_PI;
    
    CGFloat offsetX = sin(angle) * self.radius;
    CGFloat offsetY = cos(angle) * self.radius;
    
    CGPoint center = CGPointMake(self.center.x + offsetX, self.center.y - offsetY);
    
    attributes.position = CGPointMake(center.x - attributes.size.width/2.f, center.y - attributes.size.height/2.f);
    
    CGAffineTransform affine = CGAffineTransformMakeRotation(angle);
    attributes.transform = CATransform3DMakeAffineTransform(affine);
    
    attributes.opacity = angle * (2*M_PI - angle)/(M_PI * M_PI);
}

@end
