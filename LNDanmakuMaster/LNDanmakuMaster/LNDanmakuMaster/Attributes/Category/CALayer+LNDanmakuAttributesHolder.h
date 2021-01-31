//
//  CALayer+LNDanmakuAttributesHolder.h
//  LNDanmakuMaster
//
//  Created by Levison on 31.1.21.
//  Copyright © 2021 Levison. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "LNDanmakuAbstractAttributes.h"

NS_ASSUME_NONNULL_BEGIN

@interface CALayer (LNDanmakuAttributesHolder)

//weak/delegate
- (void)setDanmakuAttributes:(LNDanmakuAbstractAttributes * _Nullable)attributes;
- (LNDanmakuAbstractAttributes * _Nullable)danmakuAttributes;

@end

NS_ASSUME_NONNULL_END
