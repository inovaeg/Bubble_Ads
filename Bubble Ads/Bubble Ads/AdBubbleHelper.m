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


+(void)presentBubblesViewOnView:(SKView *)skView{
    if(skView.scene == nil){
        // Configure the view.
        skView.allowsTransparency = YES;
        //    skView.showsFPS = YES;
        //    skView.showsNodeCount = YES;
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = YES;

        
        // Create and configure the scene.
        SKScene * scene = [AdBubbleScene sceneWithSize:skView.bounds.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;

        
        // Present the scene.
        [skView presentScene:scene];

    }else{
        AdBubbleScene* sc = (AdBubbleScene*)skView.scene;
        [sc updateBubbleLocationsAndPhysicalBodyWithFrameRect:skView.frame];
    }
}

+ (void)startWithView:(SKView *)skView{
        skView.allowsTransparency = YES;
        skView.ignoresSiblingOrder = YES;
        
        SKScene * scene = [AdBubbleScene sceneWithSize:skView.bounds.size];
        scene.scaleMode = SKSceneScaleModeResizeFill;
        
        // Present the scene.
        [skView presentScene:scene];
}

@end
