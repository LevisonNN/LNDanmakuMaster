//
//  UIView+LNDanmakuAttributesHolder.h
//  LNDanmakuMaster
//
//  Created by Levison on 31.1.21.
//  Copyright © 2021 Levison. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LNDanmakuAbstractAttributes.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIView (LNDanmakuAttributesHolder)

//weak/delegate
- (void)setDanmakuAttributes:(LNDanmakuAbstractAttributes * _Nullable)attributes;
- (LNDanmakuAbstractAttributes * _Nullable)danmakuAttributes;

@end

NS_ASSUME_NONNULL_END
