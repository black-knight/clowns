//
//  ClownCharacter.m
//  Clowns
//
//  Created by Daniel Andersen on 15/02/14.
//  Copyright (c) 2014 Trolls Ahead. All rights reserved.
//

#import "ClownCharacter.h"
#import "TiltObject.h"
#import "Util.h"

@interface ClownCharacter ()

@property (nonatomic) float gravity;
@property (nonatomic) float maxVelocity;
@property (nonatomic) float bounceVelocity;

@end

@implementation ClownCharacter

- (id)init {
    if (self = [super init]) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    self.gravity = 0.1f;
    self.maxVelocity = 10.0f;
    self.bounceVelocity = -10.0f;
    
    self.state = NORMAL;
    self.sprite = [Util spriteFromFile:@"Images/clown_jumping.png"];
    self.sprite.anchorPoint = CGPointMake(0.5f, 0.0f);
    self.velocity = CGPointZero;
}

- (void)positionClownOnTilt:(TiltObject *)tilt {
    CGPoint p = CGPointMake(tilt.sprite.position.x, tilt.sprite.position.y + (tilt.sprite.size.height / 2.0f));
    p.x += self.tiltOffset * (tilt.sprite.size.width / 2.0f);
    p.y -= sinf(tilt.sprite.zRotation + M_PI) * self.tiltOffset * (tilt.sprite.size.width / 2.0f);
    self.sprite.position = p;
}

- (void)updateAirPosition {
    self.velocity = CGPointMake(self.velocity.x,
                                MIN(self.velocity.y + self.gravity, self.maxVelocity));
    self.sprite.position = CGPointMake(self.sprite.position.x + self.velocity.x,
                                       self.sprite.position.y - self.velocity.y);
}

- (void)bounceIntoAirFromYPosition:(float)y withForce:(float)force {
    self.state = IN_AIR;
    self.velocity = CGPointMake([self calculateBounceVelocityX], [self calculateBounceVelocityYWithGivenForce:force]);
    self.sprite.position = CGPointMake(self.sprite.position.x, y);
}

- (float)calculateBounceVelocityX {
    float x = ((float)rand() / RAND_MAX) - 0.5f;
    return x;
}

- (float)calculateBounceVelocityYWithGivenForce:(float)force {
    return self.bounceVelocity * force * (0.5f + (ABS(self.tiltOffset) * 0.5f));
}

- (void)startWalkingAway {
    self.state = WALKING_AWAY;
    self.velocity = CGPointMake(0.0f, 0.0f);
}

@end
