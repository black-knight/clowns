//
//  Util.m
//  Clowns
//
//  Created by Daniel Andersen on 14/02/14.
//  Copyright (c) 2014 Trolls Ahead. All rights reserved.
//

#import "Util.h"

@implementation Util

+ (SKSpriteNode *)spriteFromFile:(NSString *)filename {
    SKTexture *texture = [SKTexture textureWithImageNamed:filename];
    texture.filteringMode = SKTextureFilteringNearest;
    
    SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithTexture:texture];

    return sprite;
}

@end
