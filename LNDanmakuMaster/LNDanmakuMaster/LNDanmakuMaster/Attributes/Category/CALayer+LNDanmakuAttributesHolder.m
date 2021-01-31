//
//  CALayer+LNDanmakuAttributesHolder.m
//  LNDanmakuMaster
//
//  Created by Levison on 31.1.21.
//  Copyright © 2021 Levison. All rights reserved.
//

#import "CALayer+LNDanmakuAttributesHolder.h"
#import "LNDanmakuAttributesHolder.h"
#import <objc/runtime.h>

NSString *const kLNDanmakuLayerAttributesHolder = @"kLNDanmakuLayerAttributesHolder";

@implementation CALayer (LNDanmakuAttributesHolder)

//weak/delegate
- (void)setDanmakuAttributes:(LNDanmakuAbstractAttributes * _Nullable)attributes
{
    LNDanmakuAttributesHolder *attributesHolder = objc_getAssociatedObject(self, kLNDanmakuLayerAttributesHolder.UTF8String);
    if (!attributesHolder) {
        attributesHolder = [[LNDanmakuAttributesHolder alloc] init];
    }
    attributesHolder.attributes = attributes;
    objc_setAssociatedObject(self, kLNDanmakuLayerAttributesHolder.UTF8String, attributesHolder, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (LNDanmakuAbstractAttributes * _Nullable)danmakuAttributes
{
    LNDanmakuAttributesHolder *attributesHolder = objc_getAssociatedObject(self, kLNDanmakuLayerAttributesHolder.UTF8String);
    return attributesHolder.attributes;
}

@end
