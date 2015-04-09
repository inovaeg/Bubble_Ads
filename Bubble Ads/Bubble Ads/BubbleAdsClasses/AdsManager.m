//
//  AdsManager.m
//  Bubble Ads
//
//  Created by Inova5 on 4/8/15.
//  Copyright (c) 2015 Kareem. All rights reserved.
//

#import "AdInMobi.h"
#import "AdFactory.h"
#import "AdsManager.h"
#import "IMUtilities.h"
#import "AdAvocarrot.h"
#import "IMGlobalImageCache.h"

#define INMOBI_INITIALIZE   @"d053d02e788a4d9bb75ca742c3757abe"
#define INMOBI_NEWSFEED     @"e369e7c1fa4f4161826db2e30550143a"
#define INMOBI_COVERFLOW    @"708e18a0c68240f9836d86f87d7f24bd"
#define INMOBI_BOARDVIEW    @"06929c9d84d7475889bb22d2a23d085a"
#define INMOBI_FEEDS        @"9b74f765ade543a19d2c794242289369"

#define AVOCARROT_API_KEY   @"d2d4f6a7a99471027143e8bf17138c054ccb5786"
#define AVOCARROT_PLACEMENT @"d8847579caad3a624970f179d50b2d9e77ec9d14"

@interface AdsManager(){

    NSMutableArray* inMobiAds;
    AdBubbleScene* bubbleScene;
    
}
+ (id)sharedManager;
@end

@implementation AdsManager

-(id)init{
    if(self = [super init]){
        inMobiAds = [[NSMutableArray alloc] init];
        [self startInMobi];
    }
    return self;
}

-(void)attachScene:(AdBubbleScene*) scene{
    bubbleScene = scene;
}

//---------------------------- InMobi -------------------------------------

-(void)startInMobi{
    [InMobi initialize:@"20a1885a75074931946458f6d190cbd4"];
    //[InMobi setLogLevel:IMLogLevelDebug];
}

-(void)loadInMobiAd{
    UIImage* image = nil;
    if (self.nativeContent!=nil) {
//        NSData* data = [self.nativeContent dataUsingEncoding:NSUTF8StringEncoding];
//        NSError* error = nil;
//        NSDictionary* jsonDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
//        NSMutableDictionary* nativeJsonDict = [NSMutableDictionary dictionaryWithDictionary:jsonDict];
//        
//        /*The above lines of code convert the native JSON content to NSDictionary.*/
//        if (error == nil && nativeJsonDict != nil) { // The native JSON is parsed and can be used.
//            [nativeJsonDict setValue:[NSNumber numberWithBool:YES] forKey:@"isAd"]; // To differentiate the native JSON dictionary from other data.
//            
//            /*Fetch the image url from the dictionary in the following way.*/
//            NSDictionary* imageDict = [nativeJsonDict valueForKey:@"icon"];
//            NSString* url = [imageDict valueForKey:@"url"];
//            
//            /*Fetch the tile from the dictionary*/
//            NSString* title = [imageDict valueForKey:@"title"];
//        }
        
        NSDictionary* dict = [inMobiAds objectAtIndex:0];
        
//        labelInCollectionView.text = [dict valueForKey:@"title"];
//        descriptionInCollectionView.text = [dict valueForKey:@"content"];
        
        NSDictionary* iconDict = [dict valueForKey:@"icon"];
        NSString* adImageUrl = [iconDict valueForKey:@"url"];
        if (adImageUrl) {
            image = [[IMGlobalImageCache sharedCache] imageForKey:adImageUrl];
        }
    }
}

-(void)nativeAdDidFinishLoading:(IMNative*)native {
//    const char* nativeCString = [native.content cStringUsingEncoding:NSISOLatin1StringEncoding];
//    NSString* utf8PubContent = [[NSString alloc] initWithCString:nativeCString encoding:NSUTF8StringEncoding];
//    
//    NSLog(@"Native ad content after encoding is %@", utf8PubContent);
//    self.nativeContent = utf8PubContent;
//    
//    NSLog(@"JSON content is %@", self.nativeContent);
//    NSDictionary* nativeJson = [self dictFromNativeContent];
//    
//    if (nativeJson!=nil) {
//        [inMobiAds addObject:nativeJson];
//    }
    
    AdInMobi* currentAd = [[AdInMobi alloc] initWithAd:native];
    [self loadIMNativeImage:currentAd];
    
}

-(void)nativeAd:(IMNative*)native didFailWithError:(IMError*)error {
    NSLog(@"Native ad failed to load with error %@", error);
}

//Get InMobi Image
-(void)loadIMNativeImage:(AdInMobi*) ad{
    NSDictionary* iconDict = [ad.nativeContent valueForKey:@"icon"];
    NSString* adImageUrl = [iconDict valueForKey:@"url"];
    if (adImageUrl) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
            NSData* imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:adImageUrl]];
            UIImage* img = [UIImage imageWithData:imgData];
            [[IMGlobalImageCache sharedCache] addImage:img forKey:adImageUrl];
            dispatch_async(dispatch_get_main_queue(), ^{
                [bubbleScene createBubbleWithAd:ad];
            });
        });
    }
}

//---------------------------- InMobi -------------------------------------

//--------------------------- AvoCarrot -----------------------------------

-(void) adDidNotLoad:(NSString *)reason{
    NSLog(@"adDidNotLoad reason : %@",reason);
}

-(void) adDidFailToLoad:(NSError *)error{
    NSLog(@"adDidFailToLoad error: %@",error);
}
-(void) adDidLoad:(AVCustomAd *)ad {
    NSLog(@"adDidLoad");
    
    // Bind ad to a UIView
    [ad bindToView:bubbleScene.view];
    dispatch_after(DISPATCH_TIME_NOW, dispatch_get_main_queue(), ^(void){
        // Get Ad Image
        if (([ad getImageHeight]>0) && ([ad getImageWidth]>0) && ([ad getImage] != nil)){
            AdFactory* currentAd = [[AdAvocarrot alloc] initWithAd:ad];
            [bubbleScene createBubbleWithAd:currentAd];
        }
    });
}

-(void)onAdClick:(NSString *)message{
    //    NSLog(@"onAdClick message %@: ",message);
}

- (void) onAdImpression: (NSString *) message{
    //    NSLog(@"onAdImpression message %@: ",message);
}

-(void) userWillLeaveApp{
    //    NSLog(@"userWillLeaveApp");
    
}

//--------------------------- AvoCarrot -----------------------------------

-(void)requestAd{
    
    self.nativeAd = [[IMNative alloc] initWithAppId:@"20a1885a75074931946458f6d190cbd4"];
    self.nativeAd.delegate = self;
    [self.nativeAd loadAd];
    
    AvocarrotCustom *myAd = [[AvocarrotCustom alloc] init];
    [myAd setApiKey: AVOCARROT_API_KEY];
    [myAd setSandbox:NO];
    [myAd setLogger:NO withLevel:@"ALL"];
    [myAd loadAdForPlacement: AVOCARROT_PLACEMENT];
    [myAd setDelegate:self];
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
