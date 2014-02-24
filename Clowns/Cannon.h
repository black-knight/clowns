//
//  Cannon.h
//  Clowns
//
//  Created by Daniel Andersen on 24/02/14.
//  Copyright (c) 2014 Trolls Ahead. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

enum CannonState {
    ENTERING,
    ADJUSTING_ANGLE,
    FIRE_COUNTDOWN,
    FIRING,
    LEAVE_COUNTDOWN,
    LEAVING,
    AWAY_COUNTDOWN
};

@protocol CannonProtocol <NSObject>

- (void)fireClownAtPosition:(CGPoint)p withVelocity:(CGPoint)v;

@end

@interface Cannon : NSObject

- (id)initWithYPosition:(float)y;

- (void)update;

@property (nonatomic, retain) id<CannonProtocol> delegate;

@property (nonatomic, retain) SKSpriteNode *headSprite;
@property (nonatomic, retain) SKSpriteNode *wheelSprite;

@property (nonatomic) enum CannonState state;

@end
