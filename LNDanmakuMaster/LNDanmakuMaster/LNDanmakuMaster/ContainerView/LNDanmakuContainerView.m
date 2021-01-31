//
//  LNDanmakuContainerView.m
//  LNDanmakuMaster
//
//  Created by Levison on 31.1.21.
//  Copyright © 2021 Levison. All rights reserved.
//

#import "LNDanmakuContainerView.h"
#import "CALayer+LNDanmakuAttributesHolder.h"
#import "UIView+LNDanmakuAttributesHolder.h"

@interface LNDanmakuContainerView ()

@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

@end

@implementation LNDanmakuContainerView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addGestureRecognizer:self.tapGesture];
    }
    return self;
}

- (void)setTapGestureEnabled:(BOOL)enabled
{
    self.tapGesture.enabled = enabled;
}

- (UITapGestureRecognizer *)tapGesture
{
    if (!_tapGesture) {
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapped:)];
    }
    return _tapGesture;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    if (self.hidden) {
        return [super hitTest:point withEvent:event];
    }
    for (CALayer *layer in [self.layer.sublayers reverseObjectEnumerator]) {
        if ([layer hitTest:point]) {
            if (layer.danmakuAttributes) {
                return self;
            } else {
                return [super hitTest:point withEvent:event];
            }
            break;
        }
    }
    return nil;
}

- (void)didTapped:(UITapGestureRecognizer *)tap
{
    CGPoint point = [tap locationInView:self];
    CALayer *tappedLayer = nil;
    UIView *tappedView = nil;
    for (CALayer *layer in [self.layer.sublayers reverseObjectEnumerator]) {
        if ([layer hitTest:point]) {
            if (layer.danmakuAttributes) {
                tappedLayer = layer;
            } else {
                if ([layer.delegate isKindOfClass:[UIView class]]) {
                    tappedView = (UIView *)layer.delegate;
                }
            }
            break;
        }
    }

    LNDanmakuAbstractAttributes *targetAttributes;
    if (tappedLayer) {
        targetAttributes = [tappedLayer danmakuAttributes];
    } else if (tappedView) {
        targetAttributes = [tappedView danmakuAttributes];
    }
    
    if (targetAttributes && self.delegate && [self.delegate respondsToSelector:@selector(danmakuContainerDidTappedAttributes:)]) {
        [self.delegate danmakuContainerDidTappedAttributes:targetAttributes];
    }
}

- (void)viewShouldLoadAttributes:(LNDanmakuAbstractAttributes *)attributes
{
    if (attributes.presentView) {
        [self addSubview:attributes.presentView];
    }
    
    if (attributes.presentLayer) {
        [self.layer addSublayer:attributes.presentLayer];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(danmakuContainerViewDidLoadAttributes:)]) {
        [self.delegate danmakuContainerViewDidLoadAttributes:attributes];
    }
}
- (void)viewShouldRemoveAttributes:(LNDanmakuAbstractAttributes *)attributes
{
    if ([self.subviews containsObject:attributes.presentView]) {
        [attributes.presentView removeFromSuperview];
    }
    
    if ([self.layer.sublayers containsObject:attributes.presentLayer]) {
        [attributes.presentLayer removeFromSuperlayer];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(danmakuContainerViewDidUnloadAttributes:)]) {
        [self.delegate danmakuContainerViewDidUnloadAttributes:attributes];
    }
}

@end
