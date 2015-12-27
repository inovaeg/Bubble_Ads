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

- (void)viewDidLoad
{
    [super viewDidLoad];
    //Put this method inside your ViewDidLoad method
    [AdBubbleHelper startWithView:self.sceneView];
    
    //You could initialize it programatically if you want
    /* 
    SKView* view = [[SKView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.view addSubview:view];
    [AdBubbleHelper startWithView:view]; */
}

- (BOOL)shouldAutorotate
{
    return YES;
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
