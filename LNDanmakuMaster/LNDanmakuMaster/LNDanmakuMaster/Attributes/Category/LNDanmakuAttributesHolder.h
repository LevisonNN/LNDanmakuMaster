//
//  LNDanmakuAttributesHolder.h
//  LNDanmakuMaster
//
//  Created by Levison on 31.1.21.
//  Copyright © 2021 Levison. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LNDanmakuAbstractAttributes.h"

NS_ASSUME_NONNULL_BEGIN

/*
 * Help every CALayer/UIView keep a weak pointer to attributes.
 **/

@interface LNDanmakuAttributesHolder : NSObject

@property (nonatomic, weak) LNDanmakuAbstractAttributes *attributes;

@end

NS_ASSUME_NONNULL_END
