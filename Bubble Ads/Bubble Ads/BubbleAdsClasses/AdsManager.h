//
//  AdsManager.h
//  Bubble Ads
//
//  Created by Inova5 on 4/8/15.
//  Copyright (c) 2015 Kareem. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AvocarrotSDK/AvocarrotCustom.h>

#import "InMobi.h"
#import "IMNative.h"
#import "IMConstants.h"
#import "AdBubbleScene.h"
#import "IMNativeDelegate.h"

@interface AdsManager : NSObject <IMNativeDelegate, AVCustomAdDelegate>

@property (nonatomic, strong) IMNative* nativeAd;
@property (nonatomic, strong) NSString* nativeContent;

+ (id)sharedManager;

-(void)requestAd;
-(void)startInMobi;
-(void)attachScene:(AdBubbleScene*) scene;

@end
