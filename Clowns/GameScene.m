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
#import "Constants.h"

@interface GameScene ()

@property (nonatomic, retain) NSMutableArray *sceneShapes;

@property (nonatomic, retain) TiltObject *tilt;
@property (nonatomic, retain) NSMutableArray *clownCharacters;
@property (nonatomic, retain) Cannon *cannon;

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
    [Constants sharedInstance].lineWidth = 1.5f;
    [Constants sharedInstance].borderTop = 100.0f;
    [Constants sharedInstance].borderBottom = 25.0f;
}

- (void)setupScene {
    self.backgroundColor = [SKColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:1.0];

    [self setupTilt];

    [Constants sharedInstance].borderLeft = (self.frame.size.width * 0.15f) + (self.tilt.sprite.size.width / 2.0f);
    [Constants sharedInstance].borderRight = self.frame.size.width - (self.tilt.sprite.size.width / 2.0f);
    
    [self setupSceneShapes];
    [self setupClowns];
    [self setupCannon];
}

- (void)setupTilt {
    self.tilt = [[TiltObject alloc] init];
    self.tilt.state = NORMAL;
    self.tilt.sprite.position = CGPointMake(CGRectGetMidX(self.frame), [Constants sharedInstance].borderBottom + (self.tilt.sprite.size.height / 2.0f));
    [self addChild:self.tilt.sprite];
}

- (void)setupClowns {
    self.clownCharacters = [NSMutableArray array];
    [self spawnClown];
    [self spawnClown];

    [self.tilt putClownOnTilt:[self.clownCharacters lastObject]];
}

- (void)setupCannon {
    self.cannon = [[Cannon alloc] initWithYPosition:[Constants sharedInstance].borderBottom];
    self.cannon.delegate = self;
    
    [self addChild:self.cannon.headSprite];
    [self addChild:self.cannon.wheelSprite];
}

- (void)setupSceneShapes {
    self.sceneShapes = [NSMutableArray array];
    
    // Bottom
    UIBezierPath *bottomPath = [UIBezierPath bezierPath];
    [bottomPath moveToPoint:CGPointMake(0.0f, [Constants sharedInstance].borderBottom)];
    [bottomPath addLineToPoint:CGPointMake(self.frame.size.width, [Constants sharedInstance].borderBottom)];
    
    SKShapeNode *bottomShape = [[SKShapeNode alloc] init];
    bottomShape.lineWidth = [Constants sharedInstance].lineWidth;
    bottomShape.antialiased = NO;
    [bottomShape setPath:bottomPath.CGPath];
    
    [self addChild:bottomShape];
}

- (ClownCharacter *)spawnClown {
    ClownCharacter *clown = [[ClownCharacter alloc] init];
    clown.state = IN_AIR;
    clown.sprite.position = CGPointMake(CGRectGetMidX(self.frame) + 20.0f - self.clownCharacters.count * 70.0f, CGRectGetMidY(self.frame));

    [self.clownCharacters addObject:clown];
    [self addChild:clown.sprite];
    
    return clown;
}

- (ClownCharacter *)spawnClownAtPosition:(CGPoint)p withVelocity:(CGPoint)v {
    ClownCharacter *clown = [[ClownCharacter alloc] init];
    clown.state = IN_AIR;
    clown.sprite.position = p;
    clown.velocity = v;
    
    [self.clownCharacters addObject:clown];
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
    p.x = MAX(p.x, [Constants sharedInstance].borderLeft);
    p.x = MIN(p.x, [Constants sharedInstance].borderRight);
    self.tilt.sprite.position = CGPointMake(p.x, p.y);
}

- (void)update:(CFTimeInterval)currentTime {
    [self updateCannon:currentTime];
    [self updateClowns:currentTime];
}

- (void)updateCannon:(CFTimeInterval)currentTime {
    [self.cannon update];
}

- (void)updateClowns:(CFTimeInterval)currentTime {
    for (ClownCharacter *clown in self.clownCharacters) {
        if (clown.state == ON_TILT) {
            [clown positionClownOnTilt:self.tilt];
        }
        if (clown.state == IN_AIR) {
            [self updateClownInAir:clown];
        }
        if (clown.state == WALKING_AWAY) {
            [clown updateWalkingAway];
        }
    }
}

- (void)updateClownInAir:(ClownCharacter *)clown {
    [clown updateAirPosition];
    
    if (clown.sprite.position.y <= [Constants sharedInstance].borderBottom) {
        clown.sprite.position = CGPointMake(clown.sprite.position.x, [Constants sharedInstance].borderBottom);
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
    if (clown.sprite.position.y <= [Constants sharedInstance].borderBottom) {
        [clown startWalkingAway];
    }
}

- (void)fireClownAtPosition:(CGPoint)p withVelocity:(CGPoint)v {
    [self spawnClownAtPosition:p withVelocity:v];
}

@end
