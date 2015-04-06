//
//  AdBubbleScene.h
//  Bubble Ads
//

//  Copyright (c) 2015 Inova LLC. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface AdBubbleScene : SKScene
{
    SKTextureAtlas *atlas;
}

-(void)updateBubbleLocationsAndPhysicalBodyWithFrameRect:(CGRect)rect;
@end
