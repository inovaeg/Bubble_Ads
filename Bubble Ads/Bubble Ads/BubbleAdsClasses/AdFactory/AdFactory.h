//
//  AdFactory.h
//  Bubble Ads
//
//  Created by Inova5 on 4/9/15.
//  Copyright (c) 2015 Kareem. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum
{
    InMobiAd,
    AvocarrotAd
} AdFactoryType;

@interface AdFactory : NSObject
{
}

-(UIImage*)getImage;
-(id)initWithAd:(id)currentAd;
-(void)openWithView:(UIView*)view;


@end
