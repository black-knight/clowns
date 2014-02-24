//
//  Cannon.m
//  Clowns
//
//  Created by Daniel Andersen on 24/02/14.
//  Copyright (c) 2014 Trolls Ahead. All rights reserved.
//

#import "Cannon.h"
#import "Util.h"

@interface Cannon ()

@property (nonatomic) float moveSpeed;
@property (nonatomic) float startPosition;
@property (nonatomic) float stopPosition;
@property (nonatomic) float targetAngle;
@property (nonatomic) float targetAngleMin;
@property (nonatomic) float targetAngleMax;
@property (nonatomic) float adjustAngleSpeed;
@property (nonatomic) float countdown;
@property (nonatomic) float countdownSpeed;
@property (nonatomic) float fireCountdownMax;
@property (nonatomic) float leaveCountdownMax;
@property (nonatomic) float awayCountdownMax;
@property (nonatomic) float fireForce;

@end

@implementation Cannon

- (id)initWithYPosition:(float)y {
    if (self = [super init]) {
        [self initializeWithYPosition:y];
    }
    return self;
}

- (void)initializeWithYPosition:(float)y {
    self.state = AWAY_COUNTDOWN;

    self.headSprite = [Util spriteFromFile:@"Images/cannon_head.png"];
    self.headSprite.anchorPoint = CGPointMake(0.5f, 0.3816f);

    self.moveSpeed = 0.4f;
    self.startPosition = -self.headSprite.size.width / 2.0f;
    self.stopPosition = self.headSprite.size.width * 3.0f / 5.0f;

    self.headSprite.position = CGPointMake(self.startPosition, y + (self.headSprite.size.height * self.headSprite.anchorPoint.y));

    self.wheelSprite = [Util spriteFromFile:@"Images/cannon_wheel.png"];
    self.wheelSprite.anchorPoint = self.headSprite.anchorPoint;
    self.wheelSprite.position = self.headSprite.position;

    self.targetAngle = 0.0f;
    self.targetAngleMin = M_PI_2 * 6.0 / 8.0f;
    self.targetAngleMax = M_PI_2 * 7.0 / 8.0f;
    self.adjustAngleSpeed = 0.01f;
    self.countdown = 0.0f;
    self.countdownSpeed = 0.05f;
    self.fireCountdownMax = 1.0f;
    self.leaveCountdownMax = 1.0f;
    self.awayCountdownMax = 10.0f;
    self.fireForce = 5.0f;
}

- (void)update {
    switch (self.state) {
        case ENTERING:
            [self updateEntering];
            break;
        case ADJUSTING_ANGLE:
            [self updateAdjustingAngle];
            break;
        case FIRE_COUNTDOWN:
            [self updateFireCountdown];
            break;
        case FIRING:
            [self updateFiring];
            break;
        case LEAVE_COUNTDOWN:
            [self updateLeaveCountdown];
            break;
        case LEAVING:
            [self updateLeaving];
            break;
        case AWAY_COUNTDOWN:
            [self updateAwayCountdown];
            break;
    }
}

- (void)updateEntering {
    self.headSprite.position = CGPointMake(MIN(self.headSprite.position.x + self.moveSpeed, self.stopPosition), self.headSprite.position.y);
    self.wheelSprite.position = self.headSprite.position;
    self.wheelSprite.zRotation = -self.wheelSprite.position.x * 5.0f * M_PI / 180.0f;

    if (self.headSprite.position.x >= self.stopPosition) {
        [self prepareToAdjustAngle];
    }
}

- (void)prepareToAdjustAngle {
    self.targetAngle = (((float)rand() / (float)RAND_MAX) * (self.targetAngleMax - self.targetAngleMin)) + self.targetAngleMin;
    self.state = ADJUSTING_ANGLE;
}

- (void)updateAdjustingAngle {
    self.headSprite.zRotation = MIN(self.headSprite.zRotation + self.adjustAngleSpeed, self.targetAngle);

    if (self.headSprite.zRotation >= self.targetAngle) {
        self.countdown = 0.0f;
        self.state = FIRE_COUNTDOWN;
    }
}

- (void)updateFireCountdown {
    self.countdown = MIN(self.countdown + self.countdownSpeed, self.fireCountdownMax);
    
    if (self.countdown >= self.fireCountdownMax) {
        self.state = FIRING;
    }
}

- (void)updateFiring {
    CGPoint v;
    v.x = cosf(self.headSprite.zRotation) * self.fireForce;
    v.y = -sinf(self.headSprite.zRotation) * self.fireForce;
    [self.delegate fireClownAtPosition:self.headSprite.position withVelocity:v];
    
    self.countdown = 0.0f;
    self.state = LEAVE_COUNTDOWN;
}

- (void)updateLeaveCountdown {
    self.countdown = MIN(self.countdown + self.countdownSpeed, self.leaveCountdownMax);
    
    if (self.countdown >= self.leaveCountdownMax) {
        self.state = LEAVING;
    }
}

- (void)updateLeaving {
    self.headSprite.position = CGPointMake(MAX(self.headSprite.position.x - self.moveSpeed, self.startPosition), self.headSprite.position.y);
    self.wheelSprite.position = self.headSprite.position;
    self.wheelSprite.zRotation = -self.wheelSprite.position.x * 5.0f * M_PI / 180.0f;
    
    if (self.headSprite.position.x <= self.startPosition) {
        self.countdown = 0.0f;
        self.state = AWAY_COUNTDOWN;
    }
}

- (void)updateAwayCountdown {
    self.countdown = MIN(self.countdown + self.countdownSpeed, self.awayCountdownMax);
    
    if (self.countdown >= self.awayCountdownMax) {
        self.state = ENTERING;
    }
}

@end
