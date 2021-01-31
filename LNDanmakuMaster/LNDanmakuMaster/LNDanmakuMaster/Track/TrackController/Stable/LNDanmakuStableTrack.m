//
//  LNDanmakuStableTrack.m
//  LNDanmakuMaster
//
//  Created by Levison on 31.1.21.
//  Copyright © 2021 Levison. All rights reserved.
//

#import "LNDanmakuStableTrack.h"

@implementation LNDanmakuStableTrack

- (void)updateAttributes:(LNDanmakuAbstractAttributes *)attributes
{
    [super updateAttributes:attributes];
    CGFloat currentX = self.position.x - attributes.size.width/2.f;
    CGFloat currentY = self.position.y - attributes.size.height/2.f;
    attributes.position = CGPointMake(currentX, currentY);
}

@end
