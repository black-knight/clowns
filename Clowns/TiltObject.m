//
//  TiltObject.m
//  Clowns
//
//  Created by Daniel Andersen on 15/02/14.
//  Copyright (c) 2014 Trolls Ahead. All rights reserved.
//

#import "TiltObject.h"
#import "ClownCharacter.h"
#import "Util.h"

@implementation TiltObject

- (id)init {
    if (self = [super init]) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    self.state = NORMAL;
    self.sprite = [Util spriteFromFile:@"Images/tilt.png"];
    self.sprite.zRotation = atan2(self.sprite.size.width / 2.0f, self.sprite.size.height) + M_PI_2 - M_PI;
    self.clownsOnTilt = [NSMutableArray array];
}

- (bool)touchesTiltWithPoint:(CGPoint)p {
    return ABS(self.sprite.position.x - p.x) <= self.sprite.size.width / 2.0f && p.y < self.sprite.position.y + (self.sprite.size.height / 2.0f);
}

- (float)tiltOffsetAtX:(float)x {
    return (x - self.sprite.position.x) / (self.sprite.size.width / 2.0f);
}

- (float)tiltYPositionAtOffset:(float)offset {
    return self.sprite.position.y + (self.sprite.size.height / 2.0f) - (sinf(self.sprite.zRotation + M_PI) * offset * (self.sprite.size.width / 2.0f));
}

- (void)putClownOnTilt:(ClownCharacter *)clown {
    clown.state = ON_TILT;
    clown.tiltOffset = [self tiltOffsetAtX:clown.sprite.position.x];

    [self bounceClownsOnTiltWithForce:(0.75f + ABS(clown.tiltOffset) * 0.25f)];
    [self.clownsOnTilt addObject:clown];
    
    self.sprite.zRotation = ABS(self.sprite.zRotation) * (clown.tiltOffset < 0.0f ? 1.0f : -1.0f);
}

- (void)bounceClownsOnTiltWithForce:(float)force {
    for (ClownCharacter *clown in self.clownsOnTilt) {
        [clown bounceIntoAirFromYPosition:[self tiltYPositionAtOffset:-clown.tiltOffset] withForce:force];
    }
    [self.clownsOnTilt removeAllObjects];
}

@end
