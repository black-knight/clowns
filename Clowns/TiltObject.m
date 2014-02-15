//
//  TiltObject.m
//  Clowns
//
//  Created by Daniel Andersen on 15/02/14.
//  Copyright (c) 2014 Trolls Ahead. All rights reserved.
//

#import "TiltObject.h"
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
    self.sprite.zRotation = M_PI / 8.0f;
}

- (bool)touchesTiltWithPoint:(CGPoint)p {
    CGPoint delta = CGPointMake(ABS(self.sprite.position.x - p.x), ABS(self.sprite.position.y - p.y));
    return delta.x <= self.sprite.size.width / 2.0f && delta.y <= self.sprite.size.height / 2.0f;
}

- (float)tiltOffsetAtX:(float)x {
    return (x - self.sprite.position.x) / (self.sprite.size.width / 2.0f);
}

- (float)tiltYPositionAtOffset:(float)offset {
    return self.sprite.position.y + (self.sprite.size.height / 2.0f) + (cosf(self.sprite.zRotation + M_PI) * offset * (self.sprite.size.width / 2.0f));
}

@end
