//
//  AdBubbleHelper.m
//  Bubble Ads
//
//  Created by Inova PC 06 on 3/17/15.
//  Copyright (c) 2015 Kareem. All rights reserved.
//

#import "AdBubbleHelper.h"
#import "AdBubbleScene.h"

@implementation AdBubbleHelper


+(void)presentBubblesViewOnView:(SKView *)skView{
    
    // Configure the view.
    skView.allowsTransparency = YES;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    /* Sprite Kit applies additional optimizations to improve rendering performance */
    skView.ignoresSiblingOrder = YES;
    
    // Create and configure the scene.
    SKScene * scene = [AdBubbleScene sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene.
    [skView presentScene:scene];
}

@end
