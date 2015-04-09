//
//  AdsManager.h
//  Bubble Ads
//
//  Created by Inova5 on 4/8/15.
//  Copyright (c) 2015 Kareem. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "InMobi.h"
#import "IMNative.h"
#import "IMConstants.h"
#import "IMNativeDelegate.h"

@interface AdsManager : NSObject <IMNativeDelegate>

@property (nonatomic, strong) IMNative* nativeAd;
@property (nonatomic, strong) NSString* nativeContent;

+ (id)sharedManager;
-(void)startInMobi;

@end
