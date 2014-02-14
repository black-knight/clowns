//
//  ViewController.m
//  Clowns
//
//  Created by Daniel Andersen on 12/02/14.
//  Copyright (c) 2014 Trolls Ahead. All rights reserved.
//

#import "IntroViewController.h"
#import "IntroScene.h"

@implementation IntroViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Configure the view
    SKView *skView = (SKView *)self.view;
    
    // Create and configure the scene
    SKScene *scene = [IntroScene sceneWithSize:CGSizeMake(skView.bounds.size.height, skView.bounds.size.width)];
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

- (IBAction)tap:(id)sender {
}

@end
