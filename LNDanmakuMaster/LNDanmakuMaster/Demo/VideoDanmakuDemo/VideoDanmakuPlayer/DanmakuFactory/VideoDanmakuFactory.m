//
//  VideoDanmakuFactory.m
//  LNDanmakuMaster
//
//  Created by Levison on 31.1.21.
//  Copyright © 2021 Levison. All rights reserved.
//

#import "VideoDanmakuFactory.h"

@interface VideoDanmakuFactory ()

@end

@implementation VideoDanmakuFactory

- (LNDanmakuAttributes *)attributesForDanmakuModel:(VideoDanmakuModel *)danmakuModel
{
    LNDanmakuAttributes *attributes = [[LNDanmakuAttributes alloc] init];
    return attributes;
}

@end
