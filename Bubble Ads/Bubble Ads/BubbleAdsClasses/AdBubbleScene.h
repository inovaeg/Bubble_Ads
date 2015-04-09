//
//  AdBubbleScene.h
//  Bubble Ads
//

//  Copyright (c) 2015 Inova LLC. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "AdFactory.h"

@interface AdBubbleScene : SKScene
{
    SKTextureAtlas *atlas;
}

-(void)createBubbleWithAd:(AdFactory*) ad;
-(SKSpriteNode *)addBubble:(NSString *)bubbleImageName atCenter:(CGPoint)center withAd:(AdFactory *)ad;

@end
