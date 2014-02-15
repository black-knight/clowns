//
//  ClownCharacter.h
//  Clowns
//
//  Created by Daniel Andersen on 15/02/14.
//  Copyright (c) 2014 Trolls Ahead. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

#import "TiltObject.h"

enum ClownState {
    ON_TILT,
    IN_AIR
};

@interface ClownCharacter : NSObject

- (void)positionClownOnTilt:(TiltObject *)tilt;
- (void)updateAirPosition;

@property (nonatomic, retain) SKSpriteNode *sprite;

@property (nonatomic) enum ClownState state;

@property (nonatomic) float tiltOffset;

@property (nonatomic) CGPoint velocity;

@end