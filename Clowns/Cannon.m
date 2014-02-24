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
@property (nonatomic) float stopPosition;
@property (nonatomic) float targetAngle;
@property (nonatomic) float targetAngleMin;
@property (nonatomic) float targetAngleMax;
@property (nonatomic) float adjustAngleSpeed;
@property (nonatomic) float fireCountdown;
@property (nonatomic) float fireCountdownMax;
@property (nonatomic) float fireCountdownSpeed;

@end

@implementation Cannon

- (id)initWithYPosition:(float)y {
    if (self = [super init]) {
        [self initializeWithYPosition:y];
    }
    return self;
}

- (void)initializeWithYPosition:(float)y {
    self.state = ENTERING;

    self.headSprite = [Util spriteFromFile:@"Images/cannon_head.png"];
    self.headSprite.anchorPoint = CGPointMake(0.5f, 0.3816f);
    self.headSprite.position = CGPointMake(-self.headSprite.size.width / 2.0f, y + (self.headSprite.size.height * self.headSprite.anchorPoint.y));

    self.wheelSprite = [Util spriteFromFile:@"Images/cannon_wheel.png"];
    self.wheelSprite.anchorPoint = self.headSprite.anchorPoint;
    self.wheelSprite.position = self.headSprite.position;

    self.moveSpeed = 0.4f;
    self.stopPosition = self.headSprite.size.width * 3.0f / 5.0f;
    self.targetAngle = 0.0f;
    self.targetAngleMin = M_PI_2 * 6.0 / 8.0f;
    self.targetAngleMax = M_PI_2 * 7.0 / 8.0f;
    self.adjustAngleSpeed = 0.01f;
    self.fireCountdown = 0.0f;
    self.fireCountdownMax = 1.0f;
    self.fireCountdownSpeed = 0.05f;
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
            break;
        case FIRING:
            break;
        case LEAVING:
            break;
        case AWAY_COUNTDOWN:
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
        self.fireCountdown = 0.0f;
        self.state = FIRE_COUNTDOWN;
    }
}

- (void)updateFireCountdown {
    self.fireCountdown = MIN(self.fireCountdown + self.fireCountdownSpeed, self.fireCountdownMax);
    
    if (self.fireCountdown >= self.fireCountdownMax) {
        self.state = FIRING;
    }
}

@end
