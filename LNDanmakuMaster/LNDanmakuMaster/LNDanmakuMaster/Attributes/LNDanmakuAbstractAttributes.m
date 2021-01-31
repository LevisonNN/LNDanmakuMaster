//
//  LNDanmakuAbstractAttributes.m
//  LNDanmakuMaster
//
//  Created by Levison on 31.1.21.
//  Copyright © 2021 Levison. All rights reserved.
//

#import "LNDanmakuAbstractAttributes.h"
#import "CALayer+LNDanmakuAttributesHolder.h"
#import "UIView+LNDanmakuAttributesHolder.h"


static NSInteger createCount;

@interface LNDanmakuAbstractAttributes ()

@end

@implementation LNDanmakuAbstractAttributes
{
    CATransform3D _transform;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _opacity = 1.f;
        _transform = CATransform3DIdentity;
        createCount ++;
    }
    return self;
}

- (void)setSize:(CGSize)size
{
    _size = size;
    [self updateSize];
}

- (void)updateSize
{
    if (self.presentLayer) {
        self.presentLayer.bounds = CGRectMake(0, 0, _size.width, _size.height);
    } else if (self.presentView) {
        self.presentView.bounds = CGRectMake(0, 0, _size.width, _size.height);
    }
}

- (void)setPosition:(CGPoint)position
{
    _position = position;
    [self updatePosition];
}

- (void)updatePosition
{
    if (self.presentLayer) {
        self.presentLayer.position = CGPointMake(_position.x + _size.width/2.f, _position.y + _size.height/2.f);
    } else if (self.presentView) {
        self.presentView.center = CGPointMake(_position.x + _size.width/2.f, _position.y + _size.height/2.f);
    }
}

- (void)updateFrame
{
    //frame布局在transform时有点问题
    [self updateSize];
    [self updatePosition];
}

- (void)setTransform:(CATransform3D)transform
{
    _transform = transform;
    [self updateTransform];
}

- (void)updateTransform
{
    if (_presentLayer) {
        _presentLayer.transform = _transform;
    } else if (_presentView) {
        _presentView.layer.transform = _transform;
    }
}

- (void)setOpacity:(float)opacity
{
    _opacity = opacity;
    [self updateOpacity];
}

- (void)updateOpacity
{
    if (_presentLayer) {
        _presentLayer.opacity = _opacity;
    } else {
        _presentView.layer.opacity = _opacity;
    }
}

- (void)setPresentLayer:(CALayer *)presentLayer
{
    if (_presentView) {
        return;
    }
    
    if (_presentLayer) {
        [_presentLayer setDanmakuAttributes:nil];
    }
    _presentLayer = presentLayer;
    [_presentLayer setDanmakuAttributes:self];
    
    [self updateFrame];
    [self updateOpacity];
    [self updateTransform];
}

- (void)setPresentView:(UIView *)presentView
{
    if (_presentLayer) {
        return;
    }
    
    if (_presentView) {
        [_presentView setDanmakuAttributes:nil];
    }
    _presentView = presentView;
    [_presentView setDanmakuAttributes:self];
    [self updateFrame];
    [self updateOpacity];
    [self updateTransform];
}

- (NSTimeInterval)totalAliveTime
{
    return self.trackTime + self.danmakuTime;
}

- (float)currentPercent
{
    if (self.totalAliveTime > 0.f && self.currentAliveTime >= 0.f) {
        float percent = self.currentAliveTime/self.totalAliveTime;
        return percent > 1.f ? 1.f: percent;
    }
    return 0.f;
}

- (void)dealloc
{
    createCount--;
}

@end
