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
    LEAVING,
    AWAY_COUNTDOWN
};

@interface Cannon : NSObject

- (id)initWithYPosition:(float)y;

- (void)update;

@property (nonatomic, retain) SKSpriteNode *headSprite;
@property (nonatomic, retain) SKSpriteNode *wheelSprite;

@property (nonatomic) enum CannonState state;

@end
