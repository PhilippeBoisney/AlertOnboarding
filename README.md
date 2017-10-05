# AlertOnboarding
A simple and attractive AlertView **to onboard your users** in your amazing world.

[![Platform](http://img.shields.io/badge/platform-ios-blue.svg?style=flat
)](https://developer.apple.com/iphone/index.action)
[![Language](http://img.shields.io/badge/language-swift-brightgreen.svg?style=flat
)](https://developer.apple.com/swift)
[![License](http://img.shields.io/badge/license-MIT-lightgrey.svg?style=flat
)](http://mit-license.org)

## PRESENTATION
This AlertOnboarding was inspired by [this amazing dribbble](https://dribbble.com/shots/2422143-Space-onboarding). It will help you to maximise, simply, onboarding process on your app.

## DEMO
<p align="center">
 <img src ="https://raw.githubusercontent.com/PhilippeBoisney/AlertOnboarding/master/demo.gif", width=200, height=350, align="left"/>
 <img src ="https://raw.githubusercontent.com/PhilippeBoisney/AlertOnboarding/master/screenshot.png", height=350/>
</p>

## INSTALLATION
####COCOAPODS
```
pod 'AlertOnboarding'
```


## USAGE
```swift
//First, declare datas
var arrayOfImage = ["image1", "image2", "image3"]
var arrayOfTitle = ["CREATE ACCOUNT", "CHOOSE THE PLANET", "DEPARTURE"]
var arrayOfDescription = ["In your profile, you can view the statistics of its operations and the recommandations of friends",
"Purchase tickets on hot tours to your favorite planet and fly to the most comfortable intergalactic spaceships of best companies",
"In the process of flight you will be in cryogenic sleep and supply the body with all the necessary things for life"]

//Simply call AlertOnboarding...
var alertView = AlertOnboarding(arrayOfImage: arrayOfImage, arrayOfTitle: arrayOfTitle, arrayOfDescription: arrayOfDescription)

//... and show it !
alertView.show()

//And maybe, if you want, you can hide it.
alertView.hide()

```
**CUSTOMIZING**

You have to set options **BEFORE** call show() function.

```swift
//Modify background color of AlertOnboarding
self.alertView.colorForAlertViewBackground = UIColor(red: 173/255, green: 206/255, blue: 183/255, alpha: 1.0)

//Modify colors of AlertOnboarding's button
self.alertView.colorButtonText = UIColor.whiteColor()
self.alertView.colorButtonBottomBackground = UIColor(red: 65/255, green: 165/255, blue: 115/255, alpha: 1.0)

//Modify colors of labels
self.alertView.colorTitleLabel = UIColor.whiteColor()
self.alertView.colorDescriptionLabel = UIColor.whiteColor()

//Modify colors of page indicator
self.alertView.colorPageIndicator = UIColor.whiteColor()
self.alertView.colorCurrentPageIndicator = UIColor(red: 65/255, green: 165/255, blue: 115/255, alpha: 1.0)

//Modify size of alertview (Purcentage of screen height and width)
self.alertView.percentageRatioHeight = 0.5
self.alertView.percentageRatioWidth = 0.5

//Modify labels
self.alertView.titleSkipButton = "PASS"
self.alertView.titleGotItButton = "UNDERSTOOD !"

```
**TRACKING EVENTS**

If you want to know when the user completes onboarding, skips onboarding, or triggers the next step, you can use the `AlertOnboardingDelegate` to listen for these updates.

```swift
//Add delegate to your ViewController
class ViewController: UIViewController, AlertOnboardingDelegate

//... when initialising AlertOnboarding
alertView.delegate = self

//... inside your class that conforms to AlertOnboardingDelegate
func alertOnboardingSkipped(currentStep: Int, maxStep: Int) {
    print("Onboarding skipped the \(currentStep) step and the max step he saw was the number \(maxStep)")
}

func alertOnboardingCompleted() {
   print("Onboarding completed!")
}

func alertOnboardingNext(nextStep: Int) {
   print("Next step triggered! \(nextStep)")
}

```

## FEATURES
- [x] Multi-Device Full Support
- [x] Rotation Support
- [x] Swift 3 Support
- [x] Fully customisable
- [x] Tracking Events

## Version
2.0

## Author
Philippe BOISNEY (phil.boisney(@)gmail.com)

## Design
[Sasha Gorosh](https://dribbble.com/SashaGorosh)
