//
//  LNDanmakuChristinaTrack.m
//  LNDanmakuMaster
//
//  Created by Levison on 31.1.21.
//  Copyright © 2021 Levison. All rights reserved.
//

#import "LNDanmakuChristinaTrack.h"

@implementation LNDanmakuChristinaTrack

- (void)updateAttributes:(LNDanmakuAbstractAttributes *)attributes
{
    [super updateAttributes:attributes];
    
    float percent = attributes.currentPercent;
    float angle = percent * 2 * M_PI;
    
    CGFloat radius = self.a * (1 - cos(angle));
    
    CGFloat offsetX = sin(angle) * radius;
    CGFloat offsetY = cos(angle) * radius;
    
    CGPoint center = CGPointMake(self.center.x + offsetX, self.center.y - offsetY);
    
    attributes.position = CGPointMake(center.x - attributes.size.width/2.f, center.y - attributes.size.height/2.f);

    float rotateAngle = 0.f;
    rotateAngle = 3*angle/2.f - M_PI/2.f;
    CGAffineTransform affine = CGAffineTransformMakeRotation(rotateAngle);
    attributes.transform = CATransform3DMakeAffineTransform(affine);

    attributes.opacity = angle * (2*M_PI - angle)/(M_PI * M_PI);
}

@end
