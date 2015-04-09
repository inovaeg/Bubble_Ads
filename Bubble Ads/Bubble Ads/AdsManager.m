//
//  AdsManager.m
//  Bubble Ads
//
//  Created by Inova5 on 4/8/15.
//  Copyright (c) 2015 Kareem. All rights reserved.
//


#import "AdsManager.h"

@interface AdsManager(){

}
+ (id)sharedManager;
@end

@implementation AdsManager

-(void)startInMobi{
    [InMobi initialize:@"20a1885a75074931946458f6d190cbd4"];
    self.nativeAd = [[IMNative alloc] initWithAppId:@"20a1885a75074931946458f6d190cbd4"];
    self.nativeAd.delegate = self;
    [self.nativeAd loadAd];
}

-(void)loadInMobiAd{
    if (self.nativeContent!=nil) {
        NSData* data = [self.nativeContent dataUsingEncoding:NSUTF8StringEncoding];
        NSError* error = nil;
        NSDictionary* jsonDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        NSMutableDictionary* nativeJsonDict = [NSMutableDictionary dictionaryWithDictionary:jsonDict];
        
        /*The above lines of code convert the native JSON content to NSDictionary.*/
        if (error == nil && nativeJsonDict != nil) { // The native JSON is parsed and can be used.
            [nativeJsonDict setValue:[NSNumber numberWithBool:YES] forKey:@"isAd"]; // To differentiate the native JSON dictionary from other data.
            
            /*Fetch the image url from the dictionary in the following way.*/
            NSDictionary* imageDict = [nativeJsonDict valueForKey:@"icon"];
            NSString* url = [imageDict valueForKey:@"url"];
            
            /*Fetch the tile from the dictionary*/
            NSString* title = [imageDict valueForKey:@"title"];
        }
    }
}

-(void)nativeAdDidFinishLoading:(IMNative*)native {
    /* Use below lines only if you are using SDK 4.1.0 */
    const char* nativeCString = [native.content cStringUsingEncoding:NSISOLatin1StringEncoding];
    NSString* utf8PubContent = [[NSString alloc] initWithCString:nativeCString encoding:NSUTF8StringEncoding];
    self.nativeContent = utf8PubContent;
    
    /* Use below lines only if you are using SDK 4.3.0 or above */
    self.nativeContent = native.content;
    NSLog(@"Native ad content is %@", self.nativeContent);
}

-(void)nativeAd:(IMNative*)native didFailWithError:(IMError*)error {
    NSLog(@"Native ad failed to load with error %@", error);
}

+ (id)sharedManager {
    static AdsManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}


@end
