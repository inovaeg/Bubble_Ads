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
//    [AdBubbleHelper presentBubblesViewOnView:self.sceneView];
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.view.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.view.layer.shadowOpacity = 0.4;
    self.view.layer.shadowRadius = 20.0;
    self.view.layer.shadowOffset = self.view.layer.frame.size;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [AdBubbleHelper startWithView:self.sceneView];
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
