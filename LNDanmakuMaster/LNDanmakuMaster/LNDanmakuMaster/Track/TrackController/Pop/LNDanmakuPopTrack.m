//
//  LNDanmakuPopTrack.m
//  LNDanmakuMaster
//
//  Created by Levison on 31.1.21.
//  Copyright © 2021 Levison. All rights reserved.
//

#import "LNDanmakuPopTrack.h"

@interface LNDanmakuPopTrack ()

@property (nonatomic, copy) NSArray<NSNumber *> *defaultPopScaleArrA;

@end

@implementation LNDanmakuPopTrack

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.A = 1.f;
        self.beta = 10.f;
        self.w = M_PI/16.f;
        self.theta = M_PI_2;
        self.strategy = LNDanmakuPopTrackStrategyDynamic;
    }
    return self;
}

- (void)resetAttributes:(LNDanmakuAbstractAttributes *)attributes
{
    attributes.opacity = 0.f;
}

- (void)updateAttributes:(LNDanmakuAbstractAttributes *)attributes
{
    if (attributes.opacity == 0.f) {
        attributes.opacity = 1.f;
    }
    
    switch (self.strategy) {
        case LNDanmakuPopTrackStrategyStatic: {
            [self updateScaleWithStatic:attributes];
        } break;
        default: {
            [self updateScaleWithDynamic:attributes];
        } break;
    }
}

- (void)updateScaleWithStatic:(LNDanmakuAbstractAttributes *)attributes
{
    NSInteger t = (NSInteger)(attributes.currentAliveTime * 60.f);
    float scale = 1;
    if (self.defaultPopScaleArrA.count > t) {
        scale = [self.defaultPopScaleArrA[MAX(0, t - 1)] floatValue]/100.f;
    }
    
    CGAffineTransform affine = CGAffineTransformMakeScale(scale, scale);
    attributes.transform = CATransform3DMakeAffineTransform(affine);
    attributes.opacity = MIN(1.f, t/10.f);
    
    NSTimeInterval restTime = attributes.totalAliveTime - attributes.currentAliveTime;
    if (restTime < 0.8f) {
        attributes.opacity = (1.f - (0.8f - restTime)/0.8f);
    }
}


- (void)updateScaleWithDynamic:(LNDanmakuAbstractAttributes *)attributes
{
    NSInteger t = (NSInteger)(attributes.currentAliveTime * 60.f);
    CGFloat decay = 1.f/expf(self.beta*(t/60.f));
    float scale = self.A;
    if (decay < 0.01) {
        scale = self.A;
        decay = 0.f;
    } else {
        scale = ((self.A *sinf(self.w * t - self.theta))*decay + self.A);
    }
    
    CGAffineTransform affine = CGAffineTransformMakeScale(scale, scale);
    attributes.transform = CATransform3DMakeAffineTransform(affine);
    attributes.opacity = (1.f - decay);
    
    
    NSTimeInterval restTime = attributes.totalAliveTime - attributes.currentAliveTime;
    if (restTime < 0.8f) {
        attributes.opacity = (1.f - (0.8f - restTime)/0.8f);
    }
}

//振幅 : 1.f , 阻尼 : 10.f ,角速度 M_PI/16.f, 相位: M_PI_2 (向前 90°)
- (NSArray <NSNumber *> *)defaultPopScaleArrA
{
    if (!_defaultPopScaleArrA) {
        _defaultPopScaleArrA = @[
            @(0.000000),
            @(16.97831),
            @(33.80114),
            @(49.56881),
            @(63.69593),
            @(75.85501),
            @(85.92186),
            @(93.92482),
            @(100.0000),
            @(104.3530),
            @(107.2279),
            @(108.8824),
            @(109.5696),
            @(109.5252),
            @(108.9590),
            @(108.0507),
            @(106.9483),
            @(105.7686),
            @(104.5997),
            @(103.5041),
            @(102.5225),
            @(101.6776),
            @(100.9781),
            @(100.4221),
            @(100.0000),
            @(99.69753),
            @(99.49778),
            @(99.38282),
            @(99.33506),
            @(99.33815),
            @(99.37749),
            @(99.44060),
            @(99.51720),
            @(99.59917),
            @(99.68039),
            @(99.75652),
            @(99.82472),
            @(99.88343),
            @(99.93203),
            @(99.97067),
            @(100.0000),
            @(100.0210),
            @(100.0348),
            @(100.0428),
            @(100.0462),
            @(100.0459),
            @(100.0432),
            @(100.0388),
            @(100.0335),
            @(100.0278),
            @(100.0222),
            @(100.0169),
            @(100.0121),
            @(100.0081),
            @(100.0047),
            @(100.0020),
            @(100.0000),
            @(99.99854),
            @(99.99757),
            @(99.99701)
        ];
    }
    return _defaultPopScaleArrA;
}

@end
