//
//  UIView+LNDanmakuAttributesHolder.m
//  LNDanmakuMaster
//
//  Created by Levison on 31.1.21.
//  Copyright © 2021 Levison. All rights reserved.
//

#import "UIView+LNDanmakuAttributesHolder.h"
#import "LNDanmakuAttributesHolder.h"
#import <objc/runtime.h>

NSString *const kLNDanmakuViewAttributesHolder = @"kLNDanmakuViewAttributesHolder";

@implementation UIView (LNDanmakuAttributesHolder)

//weak/delegate
- (void)setDanmakuAttributes:(LNDanmakuAbstractAttributes * _Nullable)attributes
{
    LNDanmakuAttributesHolder *attributesHolder = objc_getAssociatedObject(self, kLNDanmakuViewAttributesHolder.UTF8String);
    if (!attributesHolder) {
        attributesHolder = [[LNDanmakuAttributesHolder alloc] init];
    }
    attributesHolder.attributes = attributes;
    objc_setAssociatedObject(self, kLNDanmakuViewAttributesHolder.UTF8String, attributesHolder, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (LNDanmakuAbstractAttributes * _Nullable)danmakuAttributes
{
    LNDanmakuAttributesHolder *attributesHolder = objc_getAssociatedObject(self, kLNDanmakuViewAttributesHolder.UTF8String);
    return attributesHolder.attributes;
}

@end
