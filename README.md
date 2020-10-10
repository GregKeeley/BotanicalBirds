# BotanicalBirds

BotanicalBirds is an iOS app that allows you to generate unique combinations of birds and plants (aka Botanicals).

Shuffle or swipe to browse random pairs <br/>
<img src="BirdFlower/Supporting Files/Assets.xcassets/Shuffle_Screen - iPhone 8 Plus.imageset/Shuffle_Screen - iPhone 8 Plus.png" alt="Shuffle Random Pairs" width="300" height="600" />

Browse, searcha and sort through a variety of lists <br/>
<img src="BirdFlower/Supporting Files/Assets.xcassets/List_Screen- iPhone 8 Plus.imageset/List_Screen- iPhone 8 Plus.png" alt="Shuffle Random Pairs" width="300" height="600" />

Take a closer look at images from the list <br/>
<img src="BirdFlower/Supporting Files/Assets.xcassets/Detail_Screen - iPhone 8 Plus.imageset/Detail_Screen - iPhone 8 Plus.png" alt="Shuffle Random Pairs" width="300" height="600" />

## Tools & Frameworks
xCode 12, Swift 5, UIKit, Kingfisher

## Challenge

### Providing an odered set of items while retaining the appearance of being "random"

- Originally, on the shuffle screen of the app, I would simply return a random element from the array of data from the birds and plants collection respectively. Then with both a bird and plant, I perform all of the UI functions to return present it to the user. Each time the shuffle button was hit, it could return a completely random element from the collections. 

- This presented a small problem, as things didn't always appear to be random to the user. For example, you could get the same item twice in a row, or in close proximity. Additionally, if the user hit shuffle in error they could easily lose track of what they wanted. To counter this, I refactored the collections to be shuffled on load, and then incremementing the index in each collection, to give the appearance of a randomized collection. I also added swipe gestures to the UIImageViews themselves to allow the user to swipe up and down through the collection in order. 

## CocoaPods

[Kingfisher](https://github.com/onevcat/Kingfisher)


