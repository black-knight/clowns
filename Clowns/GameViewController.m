//
//  GameViewController.m
//  Clowns
//
//  Created by Daniel Andersen on 14/02/14.
//  Copyright (c) 2014 Trolls Ahead. All rights reserved.
//

#import "GameViewController.h"
#import "GameScene.h"

@implementation GameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Configure the view
    SKView *skView = (SKView *)self.view;
    
    // Create and configure the scene
    SKScene *scene = [GameScene sceneWithSize:CGSizeMake(skView.bounds.size.height, skView.bounds.size.width)];
    scene.scaleMode = SKSceneScaleModeAspectFit;
    
    // Present the scene
    [skView presentScene:scene];
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskLandscape;
    } else {
        return UIInterfaceOrientationMaskLandscape;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
