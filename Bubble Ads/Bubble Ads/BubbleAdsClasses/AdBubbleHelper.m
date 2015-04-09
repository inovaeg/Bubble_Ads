//
//  AdBubbleHelper.m
//  Bubble Ads
//
//  Created by Kareem Ahmed on 3/17/15.
//  Copyright (c) 2015 Inova LLC. All rights reserved.
//

#import "AdBubbleHelper.h"
#import "AdBubbleScene.h"

@interface AdBubbleHelper()
{
}

@end

@implementation AdBubbleHelper

+ (void)startWithView:(SKView *)skView{
        skView.allowsTransparency = YES;
        skView.ignoresSiblingOrder = YES;
        
        SKScene * scene = [AdBubbleScene sceneWithSize:skView.bounds.size];
        scene.scaleMode = SKSceneScaleModeResizeFill;
        
        // Present the scene.
        [skView presentScene:scene];
}

@end
