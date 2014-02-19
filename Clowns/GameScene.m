//
//  MyScene.m
//  Clowns
//
//  Created by Daniel Andersen on 12/02/14.
//  Copyright (c) 2014 Trolls Ahead. All rights reserved.
//

#import "GameScene.h"
#import "TiltObject.h"
#import "ClownCharacter.h"
#import "Util.h"

@interface GameScene ()

@property (nonatomic, retain) NSMutableArray *sceneShapes;

@property (nonatomic) float lineWidth;

@property (nonatomic) float borderLeft;
@property (nonatomic) float borderRight;
@property (nonatomic) float borderTop;
@property (nonatomic) float borderBottom;

@property (nonatomic, retain) TiltObject *tilt;
@property (nonatomic, retain) NSMutableArray *clownCharacters;

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
    self.lineWidth = 1.5f;
    self.borderTop = 100.0f;
    self.borderBottom = 25.0f;
}

- (void)setupScene {
    self.backgroundColor = [SKColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:1.0];

    [self setupTilt];

    self.borderLeft = (self.frame.size.width * 0.15f) + (self.tilt.sprite.size.width / 2.0f);
    self.borderRight = self.frame.size.width - (self.tilt.sprite.size.width / 2.0f);
    
    [self setupSceneShapes];
    [self setupClowns];
}

- (void)setupTilt {
    self.tilt = [[TiltObject alloc] init];
    self.tilt.state = NORMAL;
    self.tilt.sprite.position = CGPointMake(CGRectGetMidX(self.frame), self.borderBottom + (self.tilt.sprite.size.height / 2.0f));
    [self addChild:self.tilt.sprite];
}

- (void)setupClowns {
    self.clownCharacters = [NSMutableArray array];
    [self.clownCharacters addObject:[self spawnClown]];
    [self.clownCharacters addObject:[self spawnClown]];

    [self.tilt putClownOnTilt:[self.clownCharacters lastObject]];
}

- (void)setupSceneShapes {
    self.sceneShapes = [NSMutableArray array];
    
    // Bottom
    UIBezierPath *bottomPath = [UIBezierPath bezierPath];
    [bottomPath moveToPoint:CGPointMake(0.0f, self.borderBottom)];
    [bottomPath addLineToPoint:CGPointMake(self.frame.size.width, self.borderBottom)];
    
    SKShapeNode *bottomShape = [[SKShapeNode alloc] init];
    bottomShape.lineWidth = self.lineWidth;
    bottomShape.antialiased = NO;
    [bottomShape setPath:bottomPath.CGPath];
    
    [self addChild:bottomShape];
}

- (ClownCharacter *)spawnClown {
    ClownCharacter *clown = [[ClownCharacter alloc] init];
    clown.state = IN_AIR;
    clown.sprite.position = CGPointMake(CGRectGetMidX(self.frame) + 20.0f - self.clownCharacters.count * 70.0f, CGRectGetMidY(self.frame));
    [self addChild:clown.sprite];
    return clown;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.tilt.state == BEING_DRAGGED) {
        return;
    }
    for (UITouch *touch in touches) {
        CGPoint p = [touch locationInNode:self];
        if ([self.tilt touchesTiltWithPoint:p]) {
            self.tilt.state = BEING_DRAGGED;
            self.tilt.touchOffset = CGPointMake(p.x - self.tilt.sprite.position.x, p.y - self.tilt.sprite.position.y);
            return;
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.tilt.state != BEING_DRAGGED) {
        return;
    }
    for (UITouch *touch in touches) {
        CGPoint p = [touch locationInNode:self];
        [self setTiltPosition:CGPointMake(p.x - self.tilt.touchOffset.x, self.tilt.sprite.position.y)];
        return;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    self.tilt.state = NORMAL;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    self.tilt.state = NORMAL;
}

- (void)setTiltPosition:(CGPoint)p {
    p.x = MAX(p.x, self.borderLeft);
    p.x = MIN(p.x, self.borderRight);
    self.tilt.sprite.position = CGPointMake(p.x, p.y);
}

- (void)update:(CFTimeInterval)currentTime {
    [self updateClowns:currentTime];
}

- (void)updateClowns:(CFTimeInterval)currentTime {
    for (ClownCharacter *clown in self.clownCharacters) {
        if (clown.state == ON_TILT) {
            [clown positionClownOnTilt:self.tilt];
        }
        if (clown.state == IN_AIR) {
            [self updateClownInAir:clown];
        }
    }
}

- (void)updateClownInAir:(ClownCharacter *)clown {
    [clown updateAirPosition];
    
    if (clown.sprite.position.y <= self.borderBottom) {
        clown.sprite.position = CGPointMake(clown.sprite.position.x, self.borderBottom);
    }

    float tiltOffset = [self.tilt tiltOffsetAtX:clown.sprite.position.x];
    float tiltY = [self.tilt tiltYPositionAtOffset:tiltOffset];

    if (clown.sprite.position.y <= tiltY && ABS(tiltOffset) <= 1.0f) {
        int signClown = tiltOffset > 0.0f ? 1.0f : -1.0f;
        int signTiltClown = ((ClownCharacter *)[self.tilt.clownsOnTilt lastObject]).tiltOffset > 0.0f ? 1.0f : -1.0f;
        if (signClown != signTiltClown) {
            [self.tilt putClownOnTilt:clown];
        }
    }
    if (clown.sprite.position.y <= self.borderBottom) {
        [clown startWalkingAway];
    }
}

@end
