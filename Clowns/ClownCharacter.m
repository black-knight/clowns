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
#import "Constants.h"

@interface ClownCharacter ()

@property (nonatomic) float gravity;
@property (nonatomic) float maxVelocity;
@property (nonatomic) float bounceVelocity;
@property (nonatomic) float walkAwaySpeed;

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
    self.bounceVelocity = -9.0f;
    self.walkAwaySpeed = 1.0f;
    
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
    float velY = [self calculateBounceVelocityYWithGivenForce:force];
    float velX = [self calculateBounceVelocityXWithGivenVelocity:velY];
    self.velocity = CGPointMake(velX, velY);
    self.sprite.position = CGPointMake(self.sprite.position.x, y);
}

- (float)calculateBounceVelocityXWithGivenVelocity:(float)velY {
    float velX = ((float)rand() / RAND_MAX) * 2.0f - 1.0f;
    float predictedLandingX = [self predictedLandingXWithVelocityX:velX velocityY:velY];
    if (predictedLandingX < [Constants sharedInstance].borderLeft) {
        velX = ABS(velX);
    }
    if (predictedLandingX > [Constants sharedInstance].borderRight) {
        velX = -ABS(velX);
    }
    return velX;
}

- (float)predictedLandingXWithVelocityX:(float)velX velocityY:(float)velY {
    // x = velX * t + 0.5*velY*(t^2)
    // y = velY * t + 0.5*-gravity*(t^2)

    float t = 125.0f;
    return self.sprite.position.x + (velX * t);
}

- (float)calculateBounceVelocityYWithGivenForce:(float)force {
    return self.bounceVelocity * force * (0.5f + (ABS(self.tiltOffset) * 0.5f));
}

- (void)updateWalkingAway {
    self.sprite.position = CGPointMake(self.sprite.position.x + self.walkAwaySpeed, self.sprite.position.y);
}

- (void)startWalkingAway {
    self.state = WALKING_AWAY;
    self.velocity = CGPointMake(0.0f, 0.0f);
}

@end
