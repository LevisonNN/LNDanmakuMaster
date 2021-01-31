//
//  LNDanmakuHorizontalMoveTrack.m
//  LNDanmakuMaster
//
//  Created by Levison on 31.1.21.
//  Copyright © 2021 Levison. All rights reserved.
//

#import "LNDanmakuHorizontalMoveTrack.h"

@interface LNDanmakuHorizontalMoveTrack ()

@end

@implementation LNDanmakuHorizontalMoveTrack

- (void)updateAttributes:(LNDanmakuAbstractAttributes *)attributes
{
    [super updateAttributes:attributes];
    float percent = attributes.currentPercent;
    CGFloat totalDistance = self.width + attributes.size.width;
    CGFloat currentDistance = totalDistance * percent;
    CGFloat currentX = self.startPosition.x + self.width - currentDistance;
    CGFloat currentY = self.startPosition.y - attributes.size.height/2.f;
    attributes.position = CGPointMake(currentX, currentY);
}

@end
