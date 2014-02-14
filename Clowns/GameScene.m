//
//  MyScene.m
//  Clowns
//
//  Created by Daniel Andersen on 12/02/14.
//  Copyright (c) 2014 Trolls Ahead. All rights reserved.
//

#import "GameScene.h"
#import "Util.h"

@interface GameScene ()

@property (nonatomic) bool movingTilt;
@property (nonatomic) CGPoint touchOffset;

@property (nonatomic, retain) SKSpriteNode *tiltSprite;

@property (nonatomic) float borderLeft;
@property (nonatomic) float borderRight;

@end

@implementation GameScene

- (id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        [self initConstants];
        [self setupScene];
    }
    return self;
}

- (void)initConstants {
    self.movingTilt = NO;
}

- (void)setupScene {
    self.backgroundColor = [SKColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:1.0];

    [self setupTilt];

    self.borderLeft = self.tiltSprite.size.width / 2.0f;
    self.borderRight = self.frame.size.width - self.borderLeft;
}

- (void)setupTilt {
    self.tiltSprite = [Util spriteFromFile:@"Images/tilt.png"];
    self.tiltSprite.position = CGPointMake(CGRectGetMidX(self.frame), self.frame.size.height * 0.1f);
    [self addChild:self.tiltSprite];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.movingTilt) {
        return;
    }
    for (UITouch *touch in touches) {
        CGPoint p = [touch locationInNode:self];
        self.movingTilt = [self touchesTiltWithPoint:p];
        self.touchOffset = CGPointMake(p.x - self.tiltSprite.position.x, p.y - self.tiltSprite.position.y);
        return;
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!self.movingTilt) {
        return;
    }
    for (UITouch *touch in touches) {
        CGPoint p = [touch locationInNode:self];
        [self setTiltPosition:CGPointMake(p.x - self.touchOffset.x, self.tiltSprite.position.y)];
        return;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    self.movingTilt = NO;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    self.movingTilt = NO;
}

- (void)update:(CFTimeInterval)currentTime {
}

- (void)setTiltPosition:(CGPoint)p {
    p.x = MAX(p.x, self.borderLeft);
    p.x = MIN(p.x, self.borderRight);
    self.tiltSprite.position = CGPointMake(p.x, p.y);
}

- (bool)touchesTiltWithPoint:(CGPoint)p {
    CGPoint delta = CGPointMake(ABS(self.tiltSprite.position.x - p.x), ABS(self.tiltSprite.position.y - p.y));
    return delta.x <= self.tiltSprite.size.width / 2.0f && delta.y <= self.tiltSprite.size.height / 2.0f;
}

@end
