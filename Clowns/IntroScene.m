//
//  IntroScene.m
//  Clowns
//
//  Created by Daniel Andersen on 14/02/14.
//  Copyright (c) 2014 Trolls Ahead. All rights reserved.
//

#import "IntroScene.h"
#import "Util.h"

@implementation IntroScene {
    SKSpriteNode *logoSprite;
    SKSpriteNode *subtitleSprite;
    SKSpriteNode *tiltSprite;
    SKLabelNode *startLabel;
}

- (id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        [self setupScene];
    }
    return self;
}

- (void)setupScene {
    self.backgroundColor = [SKColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:1.0];

    [self setupTitle];
    [self setupStartLabel];
    
    [self performSelector:@selector(startTitleAnimation) withObject:self afterDelay:1.0f];
    [self performSelector:@selector(startStartAnimation) withObject:self afterDelay:2.0f];
}

- (void)setupTitle {
    const float logoPadding = 16.0f;
    const float tiltPadding = 2.0f;

    logoSprite = [Util spriteFromFile:@"Images/logo.png"];
    subtitleSprite = [Util spriteFromFile:[self sublogoFilename]];
    tiltSprite = [Util spriteFromFile:@"Images/tilt.png"];
    
    logoSprite.anchorPoint = CGPointMake(0.5f, 0.0f);
    subtitleSprite.anchorPoint = CGPointMake(0.5f, 0.0f);
    tiltSprite.anchorPoint = CGPointMake(0.5f, 1.0f);
    
    float totalWidth = logoSprite.size.width + logoPadding + subtitleSprite.size.width;
    
    float logoX = ((self.frame.size.width - totalWidth) / 2.0f) + (logoSprite.size.width / 2.0f);
    float subtitleX = ((self.frame.size.width + totalWidth) / 2.0f) - (subtitleSprite.size.width / 2.0f);
    float tiltX = logoX;
    
    float y = self.frame.size.height * 0.7f;
    
    logoSprite.position = CGPointMake(logoX, y);
    subtitleSprite.position = CGPointMake(subtitleX, y);
    tiltSprite.position = CGPointMake(tiltX, y - tiltPadding);

    [self addChild:logoSprite];
    [self addChild:subtitleSprite];
    [self addChild:tiltSprite];
}

- (void)setupStartLabel {
    startLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    startLabel.text = @"START";
    startLabel.fontSize = 24;
    startLabel.position = CGPointMake(CGRectGetMidX(self.frame), self.frame.size.height * 0.5);
    startLabel.color = [UIColor whiteColor];
    startLabel.alpha = 0.0f;
    
    [self addChild:startLabel];
}

- (void)startTitleAnimation {
    SKAction *action = [SKAction rotateByAngle:(M_PI / 8.0f) duration:0.4f];
    action.timingMode = SKActionTimingEaseIn;
    [tiltSprite runAction:action];
    [logoSprite runAction:action];
}

- (void)startStartAnimation {
    SKAction *action = [SKAction fadeAlphaTo:1.0f duration:1.0f];
    //action.timingMode = SKActionTimingEaseIn;
    [startLabel runAction:action];
}

- (void)update:(CFTimeInterval)currentTime {
}

- (NSString *)sublogoFilename {
    return @"Images/presidents.png";
}

@end
