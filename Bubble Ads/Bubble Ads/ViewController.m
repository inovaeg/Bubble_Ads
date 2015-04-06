//
//  ViewController.m
//  Bubble Ads
//
//  Created by Kareem Ahmed on 3/16/15.
//  Copyright (c) 2015 Inova LLC. All rights reserved.
//

#import "ViewController.h"
#import "AdBubbleHelper.h"

@implementation ViewController


-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    [AdBubbleHelper presentBubblesViewOnView:self.sceneView];
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

//- (NSUInteger)supportedInterfaceOrientations
//{
//    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
//        return UIInterfaceOrientationMaskAllButUpsideDown;
//    } else {
//        return UIInterfaceOrientationMaskLandscape;
//    }
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
