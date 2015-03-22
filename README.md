# Bubble Ads

Is a native iOS library to display animated floating Ads inside iOS apps and game. The library deliver Ads from [Avocarrot](http://www.avocarrot.com/) Ad network.


##Components

The library components

1. **AdBubbleScene**
2. **AdBubbleHelper**

Sample code for testing

1. **ViewController**

The **ViewController** should present AdBubbleScene.


##Code Example

Request presenting Ads on top of your view.

    [AdBubbleHelper presentBubblesViewOnView:self.sceneView];

##Motivation

Although, Banner and Interstitial Ads are the most common display Ads, but they provide very dull and boring user experience.

Such boring experience leads users to subconsciously ignore Ads. Such behavior lead advertisers spend more money trying to get their message to users. Also publishers suffered less profit because their ads are not getting clicked and viewed by users.

At Inova, we believe Ads experience should be fun for the user and profitable for both advertisers and publishers. Thus why we developed this magnificent native iOS bubble Ads library. Using this library, you can show floating bubble ads that the users can drag and move across their screens. Users can also tap on the Ads to learn more about the offer or install a mobile app. The library was developed to display Bubble themed Ads but we plan to deliver more customized themes like balloons and floating clouds in the future. The library makes Ads more enjoyable by users. 

The floating Ads are proven to be more engaging due to their interactive nature, thus, they deliver better results to both advertisers and publishers when compared with other traditional display Ads. Using this library, you can show eye catching animations to display Ads. You can also easily customize the library to use custom app relevant graphics.

The library currently display ads from [Avocarrot](http://www.avocarrot.com/) Ad network but we plan to support other Ad networks.

// Add new Image here.
![MY_COOL_IMAGE](https://raw.githubusercontent.com/inovaeg/UI-Hierarchy-View/master/sample.png)

##Installation

To use this project just pull or download it and import it to your project.
You will need the following classes:

1. **AdBubbleScene**
2. **AdBubbleHelper**
3. **Adding SkView on top of your view**

Also adding resource file `sprites.atlas` to the project
and then:

* In your ViewController Request presenting Ads.

Finally add required frameworks:

1. **AvocarrotSDK.framework**
2. **AdSupport.framework**
3. **CoreTelephony.framework**
4. **SystemConfiguration.framework**
5. **CoreGraphics.framework**

For help [support@inovaeg.com](support@inovaeg.com)

##API Reference

The view controller that will present Ads should have a `SKView` on it's subviews

```
@interface ViewController : UIViewController

#pragma mark - view parameters:
// a view that hold Ads Bubbles.
@property (nonatomic, retain) IBOutlet SKView * sceneView;

@end
```

##Tests

There is a class called **ViewController**, here you can test or use our library.

The class contains one method:

* **-(void) viewWillLayoutSubviews;**


`-(void) viewWillLayoutSubviews` method here you request displaying bubble Ads.


##Contributor list

1. [Inova Team](http://www.inovaeg.co/) 
2. [Kareem Ahmed](https://www.facebook.com/profile.php?id=641156392)
3. [Temon](https://www.behance.net/temon_art_design)

##Contribution guidelines

-  We plan to deliver multiple more themes for floating ads like floating balloons and floating clouds
-  We will improve to the library to make it more customizable to display app relevant graphics.
-  Support other Ads networks. 

##License
Copyright (C) 2015 Inova LLC. Licensed under the [Apache License](http://www.apache.org/licenses/LICENSE-2.0)
, Version 2.0 
