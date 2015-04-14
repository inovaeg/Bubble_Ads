//
//  AdBubbleScene.m
//  Bubble Ads
//
//  Created by Kareem Ahmed on 3/16/15.
//  Copyright (c) 2015 Inova LLC. All rights reserved.
//

#import "AdBubbleScene.h"
#import "BubbleSpritesHeader.h"
#import "AdsManager.h"

#define AD_DIC_KEY @"adObject"
#define AVOCARROT_AD_DIC_KEY @"adObject"
#define INMOBI_AD_DIC_KEY @"adObject"

#define BUBBLE_NODE_NAME @"BubbleNode"
#define AD_NODE_NAME @"AdNode"

#define ADS_IMAGE_PADDING 45

#define NORMAL_BUBBLE_ANIMATION_FRAME_TIME 0.07
#define NORMAL_BUBBLE_ANIMATION_FRAMES_COUNT 36

#define BUBBLE_EXPLOSION_ANIMATION_FRAME_TIME 0.03
#define BUBBLE_EXPLOSION_ANIMATION_FRAMES_COUNT 8

#define BUBBLE_COLLISION_ANIMATION_FRAME_TIME 0.05
#define BUBBLE_COLLISION_ANIMATION_FRAMES_COUNT 10

//#define BUBBLE_RADIUS 160
#define BUBBLE_SPEED 30
#define BUBBLES_COUNT 5
#define BUBBLES_NEW_ANGLE_DIFF 70 // angle difference between new and old bubble velocity
#define SHADOWVIEW_TIME 0.33f
#define BUBBLE_FADEIN_TIME 0.5f
#define BUBBLE_FADEOUT_TIME 0.33f

#define RADIANS_TO_DEGREES(radians) ((radians) * (180.0 / M_PI))
#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

@interface AdBubbleScene() <SKPhysicsContactDelegate>
{
    UIView* shadowView;
    UIDeviceOrientation currentOrientation;
}

@property (nonatomic) SKSpriteNode * selectedNode;
@property (nonatomic) NSTimeInterval lastSpawnTimeInterval;
@property (nonatomic) NSTimeInterval lastUpdateTimeInterval;
@property (nonatomic) CGFloat minVelocity;
@property (nonatomic) NSInteger bubblesCount;
@property (nonatomic) BOOL isClick ;

@property (nonatomic) NSMutableArray * bubblesArray;

@end

@implementation AdBubbleScene

static const uint32_t bubbleCategory =  0x1 << 0;
static const uint32_t movableBubbleCategory =  0x1 << 1;

static inline CGVector getRandomVelocity(CGFloat velocity, CGVector oldVelocity) {
    
    
    CGFloat angle = arc4random() % (BUBBLES_NEW_ANGLE_DIFF*2);
    angle -= BUBBLES_NEW_ANGLE_DIFF;
    
    CGFloat oldAngle = RADIANS_TO_DEGREES(atan2f(oldVelocity.dy, oldVelocity.dx));
    
    CGFloat newAngle = oldAngle + angle;
    
    CGFloat y = sinf(DEGREES_TO_RADIANS(newAngle))* BUBBLE_SPEED;
    CGFloat x = cosf(DEGREES_TO_RADIANS(newAngle))* BUBBLE_SPEED;
    
    return CGVectorMake(x, y);
}


-(CGPoint)geRandomPointAtScreenBoundriesForBubbleSize:(CGSize)bubbleSize{
    
    CGFloat minX = bubbleSize.width/2;
    CGFloat maxX = self.frame.size.width - bubbleSize.width/2;
    CGFloat minY = bubbleSize.height/2;
    CGFloat maxY = self.frame.size.height - bubbleSize.height/2;
    
    return [AdBubbleScene getRandomPointForMinX:minX maxX:maxX minY:minY maxY:maxY];
}

+(CGPoint)getRandomPointForMinX:(CGFloat)minX maxX:(CGFloat)maxX minY:(CGFloat)minY maxY:(CGFloat)maxY{
    
    CGFloat x = arc4random() % (NSInteger)(maxX - minX);
    CGFloat y = arc4random() % (NSInteger)(maxY - minY);
    return CGPointMake(x+minX, y+minY);
}

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        //        NSLog(@"Size: %@", NSStringFromCGSize(size));

        //Loading SpriteSheet
        self->atlas = [SKTextureAtlas atlasNamed:SPRITES_ATLAS_NAME];
        
        self.minVelocity = BUBBLE_SPEED;
        self.bubblesCount = BUBBLES_COUNT;
        self.bubblesArray = [[NSMutableArray alloc] init];
        self.backgroundColor = [SKColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0];
        
        self.physicsWorld.gravity = CGVectorMake(0,0);
        self.physicsWorld.contactDelegate = self;
        self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
        self.physicsBody.usesPreciseCollisionDetection = YES;
        
        [[AdsManager sharedManager] attachScene:self];
        for(NSInteger i = 0 ; i < self.bubblesCount; i++){
            [[AdsManager sharedManager] requestAd];
        }
        
        //Listen on Orientation
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(deviceOrientationWillChange:) name: UIDeviceOrientationDidChangeNotification object: nil];
        currentOrientation = [[UIDevice currentDevice] orientation];
    }
    return self;
}

- (void)deviceOrientationWillChange:(NSNotification *)notification {
    //Obtain current device orientation
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    
    if ((UIDeviceOrientationIsPortrait(currentOrientation) && UIDeviceOrientationIsPortrait(orientation)) ||
        (UIDeviceOrientationIsLandscape(currentOrientation) && UIDeviceOrientationIsLandscape(orientation)) ||
        (orientation == UIDeviceOrientationFaceUp || orientation == UIDeviceOrientationFaceDown) ) {
        //still saving the current orientation
        return;
    }else{
        [self updateBubbleLocationsAndPhysicalBodyWithFrameRect:self.view.frame];
        currentOrientation = orientation;
    }
    //Do my thing
}

-(void)updateBubbleLocationsAndPhysicalBodyWithFrameRect:(CGRect)rect{
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:rect];
    
    for(NSInteger i = 0 ; i < self.bubblesArray.count; i++){
        SKSpriteNode * node = [self.bubblesArray objectAtIndex:i];
        CGPoint position = [node position];
        CGPoint newPoint = CGPointMake(position.y , position.x);
        [node setPosition:newPoint];
    }
    
}

-(void)castShadowLayer{
    shadowView = [[UIView alloc] initWithFrame:self.frame];
    shadowView.autoresizingMask = (UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight);
    shadowView.backgroundColor = [UIColor blackColor];
    shadowView.alpha = 0.0f;
    [[self.view superview] insertSubview:shadowView belowSubview:self.view];// Code to run after animation
}

-(void)applyBubbleProperties:(SKSpriteNode *)node{
    
//    node.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:BUBBLE_RADIUS];
    node.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:(node.size.width - 30)/2];
    node.physicsBody.dynamic = YES;
    node.physicsBody.usesPreciseCollisionDetection = YES;
    node.physicsBody.density = 5;
    node.physicsBody.restitution = 1;
    node.physicsBody.allowsRotation = NO;
    node.physicsBody.categoryBitMask = bubbleCategory;
    node.physicsBody.collisionBitMask = bubbleCategory;
    node.physicsBody.contactTestBitMask = bubbleCategory;

}

-(void)applyBubbleAnimationToBubble:(SKSpriteNode *)bubble{
    
    SKTextureAtlas * atlasBubble = [SKTextureAtlas atlasNamed:@"spritesBubble"];
    
    NSMutableArray * animatedBubbleTextureArray = [[NSMutableArray alloc] init];
    for(NSInteger i = 0; i < 60; i++){
        NSString * imageName = [NSString stringWithFormat:@"%ld.png",(long)i];
        SKTexture * texture = [atlasBubble textureNamed:imageName];
        [animatedBubbleTextureArray addObject:texture];
    }
    
    SKAction * runAnimation = [SKAction animateWithTextures:animatedBubbleTextureArray timePerFrame:(4.0f/60.0f) resize:NO restore:NO];
    [bubble runAction:[SKAction repeatActionForever:runAnimation]];

//    SKAction * runAnimation = [SKAction animateWithTextures:SPRITES_ANIM_BUBBLE timePerFrame:NORMAL_BUBBLE_ANIMATION_FRAME_TIME resize:NO restore:NO];
//    [bubble runAction:[SKAction repeatActionForever:runAnimation]];
}

-(UIImage *)getCircleImage:(UIImage *)image withRadius:(CGFloat)radius{
    
    // create the image with rounded corners
    CGFloat diameter = radius * 2;
//    UIGraphicsBeginImageContextWithOptions(CGSizeMake(diameter,diameter), NO, 0);
//    CGRect rect = CGRectMake(0, 0, diameter, diameter);
//    [[UIColor whiteColor] setStroke];
//    UIBezierPath* path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius];
//    [path addClip];
//    [image drawInRect:rect];
//    UIImage *roundedImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
    
    CALayer *imageLayer = [CALayer layer];
    imageLayer.frame = CGRectMake(0, 0, diameter, diameter);
    imageLayer.contents = (id) image.CGImage;
    
    imageLayer.backgroundColor=[[UIColor clearColor] CGColor];
    imageLayer.cornerRadius = radius;
    imageLayer.borderWidth = 1.5f;
    imageLayer.masksToBounds = YES;
    imageLayer.borderColor=[[UIColor whiteColor] CGColor];
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(diameter,diameter), NO, 0);
    [imageLayer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *roundedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return roundedImage;
    
    return roundedImage;
}

-(SKSpriteNode *)addAdImage:(UIImage *)adImage toBubble:(SKSpriteNode *)bubble{
    
    
    CGFloat adImagePadding = ADS_IMAGE_PADDING;
    CGFloat minSize = adImage.size.height;
    if(minSize > adImage.size.width){
        minSize = adImage.size.width;
    }
    
    CGFloat newImageSize = minSize - adImagePadding*2;
    UIImage * circleAdImage = [self getCircleImage:adImage withRadius:newImageSize/2];
    SKTexture * adTexture = [SKTexture textureWithImage:circleAdImage];
    
    SKSpriteNode * adNode = [SKSpriteNode spriteNodeWithTexture:adTexture size:CGSizeMake( bubble.size.width - adImagePadding*2 , bubble.size.height -adImagePadding*2)];
    adNode.name = AD_NODE_NAME;
    adNode.position = CGPointMake(0, 0);
    
    [bubble addChild:adNode];
    return adNode;
}

-(SKSpriteNode *)addBubble:(NSString *)bubbleImageName atCenter:(CGPoint)center withAd:(AdFactory*)ad{

    SKSpriteNode * bubbleNode= [self addBubble:bubbleImageName atCenter:center withImage:[ad getImage] ];
    [bubbleNode setUserData:[[NSMutableDictionary alloc] initWithObjects:@[ad] forKeys:@[AD_DIC_KEY]]];

    return bubbleNode;
}

-(SKSpriteNode *)addBubble:(NSString *)bubbleImageName atCenter:(CGPoint)center withImage:(UIImage *)image{
    
    SKSpriteNode * bubbleNode = [SKSpriteNode spriteNodeWithImageNamed:bubbleImageName];
    bubbleNode.name = BUBBLE_NODE_NAME;
    bubbleNode.position = center;
    bubbleNode.alpha = 0.0f;
    [self applyBubbleProperties:bubbleNode];
    [self addChild:bubbleNode];
    SKSpriteNode * adNode= [self addAdImage:image toBubble:bubbleNode];
    [self.bubblesArray addObject:bubbleNode];
    [self applyBubbleAnimationToBubble:bubbleNode];
    SKAction *fadeIn = [SKAction fadeInWithDuration:BUBBLE_FADEIN_TIME];
    [bubbleNode runAction:fadeIn];
    
    adNode.zPosition = -3;
    bubbleNode.zPosition = -2;
    
    return bubbleNode;
}

-(SKSpriteNode *)createAdNodeWithAdImage:(UIImage *)adImage size:(CGSize)nodeSize{
    
    SKTexture * adTexture = [SKTexture textureWithImage:adImage];
    SKSpriteNode * adNode = [SKSpriteNode spriteNodeWithTexture:adTexture size:nodeSize];
    adNode.name = AD_NODE_NAME;
    
    return adNode;
}

-(void)createBubbleWithAd:(AdFactory*) ad{
//    CGPoint bubbleCenter = [self geRandomPointAtScreenBoundriesForBubbleSize:CGSizeMake(250, 250)];
    CGPoint bubbleCenter = [self geRandomPointAtScreenBoundriesForBubbleSize:CGSizeMake(280, 280)];
    if(shadowView == nil){
        [self castShadowLayer];
        [UIView transitionWithView:self.view
                          duration:SHADOWVIEW_TIME
                           options:UIViewAnimationOptionCurveEaseInOut
                        animations:^{
                            shadowView.alpha = 0.5f;
                        } completion:^(BOOL finished) {
                        }];
    }
//    [self addBubble:@"bubble_1" atCenter:bubbleCenter withAd:ad];
    [self addBubble:@"0" atCenter:bubbleCenter withAd:ad];
}

//-(SKSpriteNode *)createBubble{
//
//    NSString * bubbleImageName = @"bubble_1.png";
//    SKSpriteNode * bubbleNode = [SKSpriteNode spriteNodeWithImageNamed:bubbleImageName];
//    NSLog(@"[%f][%f]",bubbleNode.size.width,bubbleNode.size.height);
//    bubbleNode.name = BUBBLE_NODE_NAME;
//    [self applyBubbleProperties:bubbleNode];
//    [self applyBubbleAnimationToBubble:bubbleNode];
//    
//    return bubbleNode;
//}

- (void)updateWithTimeSinceLastUpdate:(CFTimeInterval)timeSinceLast {
    
    self.lastSpawnTimeInterval += timeSinceLast;
    if (self.lastSpawnTimeInterval > 1) {
        self.lastSpawnTimeInterval = 0;
        
        
        for(NSInteger i = 0 ; i < self.bubblesArray.count; i++){
            SKSpriteNode * ad = [self.bubblesArray objectAtIndex:i];
            if(ad != self.selectedNode){
                CGVector adVelocity = ad.physicsBody.velocity;
                ad.physicsBody.velocity = getRandomVelocity(self.minVelocity,adVelocity);
            }
        }
    }
}

- (void)update:(NSTimeInterval)currentTime {
    // Handle time delta.
    // If we drop below 60fps, we still want everything to move the same distance.
    CFTimeInterval timeSinceLast = currentTime - self.lastUpdateTimeInterval;
    
    self.lastUpdateTimeInterval = currentTime;
    if (timeSinceLast > 1) { // more than a second since last update
        timeSinceLast = 1.0 / 60.0;
        self.lastUpdateTimeInterval = currentTime;
    }
    
    [self updateWithTimeSinceLastUpdate:timeSinceLast];
    
}


- (void)panForTranslation:(CGPoint)translation {
    CGPoint position = [_selectedNode position];
    
    CGPoint newPoint = CGPointMake(position.x + translation.x, position.y + translation.y);
    
    CGFloat maxX = self.frame.size.width - self.selectedNode.size.width/2 - 1;
    CGFloat minX = self.selectedNode.size.width/2 + 1;
    
    CGFloat maxY = self.frame.size.height - self.selectedNode.size.height/2 - 1;
    CGFloat minY = self.selectedNode.size.height/2 + 1;
    
    if(newPoint.x > maxX){
        newPoint.x = maxX;
    }else if(newPoint.x < minX){
        newPoint.x = minX;
    }
    
    if(newPoint.y > maxY){
        newPoint.y = maxY;
    }else if(newPoint.y < minY){
        newPoint.y = minY;
    }
    
    //    NSLog(@"setPosition %@",NSStringFromCGPoint(newPoint));
    
    [self.selectedNode setPosition:newPoint];
}

- (void)selectNodeForTouch:(CGPoint)touchLocation {
    
    SKSpriteNode *touchedNode = (SKSpriteNode *)[self nodeAtPoint:touchLocation];
    
    if(![touchedNode.name isEqualToString:BUBBLE_NODE_NAME]){
        while (touchedNode.parent != nil) {
            touchedNode = (SKSpriteNode *)touchedNode.parent;
            if([touchedNode.name isEqualToString:BUBBLE_NODE_NAME]){
                break;
            }
        }
    }
    
    if([self.bubblesArray containsObject:touchedNode]){
        
        self.selectedNode = touchedNode;
        self.selectedNode.physicsBody.dynamic = NO;
        self.selectedNode.physicsBody.velocity = CGVectorMake(0, 0);
        
        self.selectedNode.physicsBody.categoryBitMask = movableBubbleCategory;
        self.selectedNode.physicsBody.collisionBitMask = movableBubbleCategory;
    }
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    self.isClick = YES;
    
    UITouch *touch = [touches anyObject];
    CGPoint positionInScene = [touch locationInNode:self];
    [self selectNodeForTouch:positionInScene];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
    self.isClick = NO;
    
    if(self.selectedNode){
        UITouch *touch = [touches anyObject];
        CGPoint positionInScene = [touch locationInNode:self];
        CGPoint previousPosition = [touch previousLocationInNode:self];
        
        CGPoint translation = CGPointMake(positionInScene.x - previousPosition.x, positionInScene.y - previousPosition.y);
        
        [self panForTranslation:translation];
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if(self.selectedNode){
        
        self.selectedNode.physicsBody.dynamic = YES;
        self.selectedNode.physicsBody.velocity = getRandomVelocity(self.minVelocity,CGVectorMake(self.minVelocity, 0));
        self.selectedNode.physicsBody.categoryBitMask = bubbleCategory;
        self.selectedNode.physicsBody.collisionBitMask = bubbleCategory;
        self.selectedNode.physicsBody.contactTestBitMask = bubbleCategory;

        if(self.isClick){
            [self exploadeBubble:self.selectedNode];
        }
        
        self.selectedNode = nil;
    }else{
        //Touch outside on the screen
        if(self.bubblesArray.count > 0){
            
            SKAction *fadeOut = [SKAction fadeOutWithDuration:BUBBLE_FADEOUT_TIME];
            for(NSInteger i = 0 ; i < self.bubblesArray.count - 1; i++){
                SKSpriteNode* node = [self.bubblesArray objectAtIndex:i];
                [node removeAllActions];[node runAction:fadeOut];
            }
            SKSpriteNode* node = [self.bubblesArray objectAtIndex:self.bubblesArray.count - 1 ];
            [node removeAllActions];
            [node runAction:fadeOut completion:^{
                [self removeAllChildren];
                [UIView transitionWithView:self.view
                                  duration:SHADOWVIEW_TIME
                                   options:UIViewAnimationOptionCurveEaseInOut
                                animations:^{
                                    shadowView.alpha = 0.0f;
                                } completion:^(BOOL finished) {
                                    [shadowView removeFromSuperview];shadowView = nil;
                                    
                                    SKView* view = self.view;
                                    [view presentScene:nil];
                                    [view removeFromSuperview];
                                    [self removeFromParent];
                                }];
            }];
            [self.bubblesArray removeAllObjects];
        }
    }
}

-(void)openAd:(AVCustomAd *)ad {
    [ad bindToView:self.view];
    [ad handleClick];
}
-(void)exploadeBubble:(SKSpriteNode *)bubble{
    [self applyBubbleExplosionAnimationToBubble:self.selectedNode];
}

-(void)applyBubbleExplosionAnimationToBubble:(SKSpriteNode *)bubble{
    
    [bubble removeAllActions];
    [bubble removeAllChildren];
    
    SKTextureAtlas * spriteAtlas = [SKTextureAtlas atlasNamed:@"spritesBubble"];
    NSMutableArray * animatedBubbleExplosionTextureArray = [[NSMutableArray alloc] init];
    for(NSInteger i = 0; i <= 7 /*BUBBLE_EXPLOSION_ANIMATION_FRAMES_COUNT */; i++){
        NSString * imageName = [NSString stringWithFormat:@"burst_%ld.png",(long)i];
        SKTexture * texture = [spriteAtlas textureNamed:imageName];
        [animatedBubbleExplosionTextureArray addObject:texture];
    }
    SKAction * actionAnimation = [SKAction animateWithTextures:animatedBubbleExplosionTextureArray timePerFrame:BUBBLE_EXPLOSION_ANIMATION_FRAME_TIME resize:NO restore:NO];
//    SKAction * actionAnimation = [SKAction animateWithTextures:SPRITES_ANIM_BUBBLES_EXPLOSION timePerFrame:BUBBLE_EXPLOSION_ANIMATION_FRAME_TIME resize:NO restore:NO];
    
    SKAction * actionMoveDone = [SKAction removeFromParent];
    SKAction * actionOpenAd = [SKAction runBlock:^{
        AdFactory * ad = [bubble.userData objectForKey:AD_DIC_KEY];
        [ad openWithView:self.view];
//        AVCustomAd * ad = [bubble.userData objectForKey:AVOCARROT_AD_DIC_KEY];
//        [self openAd:ad];
//        IMNative * ad = [bubble.userData objectForKey:INMOBI_AD_DIC_KEY];
//        [ad attachToView:self.view];
//        [ad handleClick:nil];
    }];
    [bubble runAction:[SKAction sequence:[NSArray arrayWithObjects:actionAnimation, actionOpenAd,actionMoveDone, nil]]];
}


-(void)applyBubbleCollisionAnimationToBubble:(SKSpriteNode *)bubble{
    
    //[bubble removeAllActions];
    SKTextureAtlas * spriteAtlas = [SKTextureAtlas atlasNamed:@"spritesBubble"];
    NSMutableArray * animatedBubbleCollisionTextureArray = [[NSMutableArray alloc] init];
    for(NSInteger i = 0; i <= 26 /*BUBBLE_COLLISION_ANIMATION_FRAMES_COUNT*/ ; i++){
        NSString * imageName = [NSString stringWithFormat:@"collision_%ld.png",(long)i];
        SKTexture * texture = [spriteAtlas textureNamed:imageName];
        [animatedBubbleCollisionTextureArray addObject:texture];
    }
    
    SKAction * actionAnimation = [SKAction animateWithTextures:animatedBubbleCollisionTextureArray timePerFrame:(0.6f/26.0f) /*BUBBLE_COLLISION_ANIMATION_FRAME_TIME*/ resize:NO restore:NO];
//    SKAction * actionAnimation = [SKAction animateWithTextures:SPRITES_ANIM_BUBBLE_COLLISION2 timePerFrame:BUBBLE_COLLISION_ANIMATION_FRAME_TIME resize:NO restore:NO];
    
    [bubble runAction:[SKAction repeatAction:actionAnimation count:1] completion:^{ // count:2
        [bubble removeAllActions];
        [self applyBubbleAnimationToBubble:bubble];
    }];
}

- (void)didBeginContact:(SKPhysicsContact *)contact
{
//    NSLog(@"didBeginContact");
    
    SKPhysicsBody * firstBody = contact.bodyA;
    SKPhysicsBody * secondBody = contact.bodyB;
    
    SKSpriteNode * bubbleNode1 = (SKSpriteNode *) firstBody.node;
    SKSpriteNode * bubbleNode2 = (SKSpriteNode *) secondBody.node;
    
    [self applyBubbleCollisionAnimationToBubble:bubbleNode1];
    [self applyBubbleCollisionAnimationToBubble:bubbleNode2];
}

-(void) dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver: self];
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
}

@end