//
//  TiltObject.h
//  Clowns
//
//  Created by Daniel Andersen on 15/02/14.
//  Copyright (c) 2014 Trolls Ahead. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

enum TiltState {
    NORMAL,
    BEING_DRAGGED
};

@interface TiltObject : NSObject

- (bool)touchesTiltWithPoint:(CGPoint)p;

- (float)tiltYPositionAtOffset:(float)offset;
- (float)tiltOffsetAtX:(float)x;

@property (nonatomic, retain) SKSpriteNode *sprite;

@property (nonatomic) enum TiltState state;

@property (nonatomic) CGPoint touchOffset;

@end
