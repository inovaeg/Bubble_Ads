//
//  AdInMobi.m
//  Bubble Ads
//
//  Created by Inova5 on 4/9/15.
//  Copyright (c) 2015 Kareem. All rights reserved.
//

#import "AdInMobi.h"
#import "IMGlobalImageCache.h"

@interface AdInMobi(){
    IMNative * ad;
}

@end

@implementation AdInMobi

@synthesize nativeContent;

-(id)initWithAd:(id)currentAd{
    if(self = [super initWithAd:currentAd]){
        ad = currentAd;
        const char* nativeCString = [ad.content cStringUsingEncoding:NSISOLatin1StringEncoding];
        NSString* utf8PubContent = [[NSString alloc] initWithCString:nativeCString encoding:NSUTF8StringEncoding];
        nativeContent = [self newsDictFromNativeContent:utf8PubContent];
    }
    return self;
}

-(void)openWithView:(UIView*)view{
   [ad attachToView:view];
    NSString* url = [nativeContent valueForKey:@"landingURL"];
    if ([nativeContent valueForKey:@"isAd"]) {
        NSURL* URL = [NSURL URLWithString:url];
        [[UIApplication sharedApplication] openURL:URL];
        [ad handleClick:nil];
    }
}

-(UIImage*)getImage{
    NSDictionary* iconDict = [nativeContent valueForKey:@"icon"];
    NSString* adImageUrl = [iconDict valueForKey:@"url"];
    return [[IMGlobalImageCache sharedCache] imageForKey:adImageUrl];
}

-(NSDictionary*)newsDictFromNativeContent:(NSString*)content {
    if (content == nil) {
        return nil;
    }
    NSData* data = [content dataUsingEncoding:NSUTF8StringEncoding];
    NSError* error = nil;
    NSDictionary* jsonDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSMutableDictionary* nativeJsonDict = [NSMutableDictionary dictionaryWithDictionary:jsonDict];
    if (error == nil && nativeJsonDict != nil) {
        [nativeJsonDict setValue:[NSNumber numberWithBool:YES] forKey:@"isAd"];
    }
    return nativeJsonDict;
}

@end
