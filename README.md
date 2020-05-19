# TOSegmentedControl

![TOSegmentedControl](screenshot.jpg)

[![CI](https://github.com/TimOliver/TOSegmentedControl/workflows/CI/badge.svg)](https://github.com/TimOliver/TOSegmentedControl/actions?query=workflow%3ACI)
[![Version](https://img.shields.io/cocoapods/v/TOSegmentedControl.svg?style=flat)](http://cocoadocs.org/docsets/TOSegmentedControl)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/TimOliver/TOSegmentedControl/master/LICENSE)
[![Platform](https://img.shields.io/cocoapods/p/TOSegmentedControl.svg?style=flat)](http://cocoadocs.org/docsets/TOSegmentedControl)
[![PayPal](https://img.shields.io/badge/paypal-donate-blue.svg)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=M4RKULAVKV7K8)
[![Twitch](https://img.shields.io/badge/twitch-timXD-6441a5.svg)](http://twitch.tv/timXD)

As part of the visual improvements featured in iOS 13, `UISegmentedControl` was completely redesigned, featuring a much rounder, cleaner, and slightly more skeuomorphic appearance.

`TOSegmentedControl` is a subclass of of `UIControl` that completely re-implements the look and feel of the new `UISegmentedControl` component, allowing developers to adopt its look even in previous versions of iOS they support.

# Features

* Recreates the new look of `UISegmentedControl`, making it available on previous versions of iOS.
* Supports both text and images as segment types.
* Support for `@IBDesignable` and `@IBInspectable`.
* Configurable to dynamically add or remove items after its creation.
* Written in Objective-C, but provides full compatibility with Swift.
* Provides both a block, or `UIControlEvents` to receive when the control is tapped.
* Light and dark mode support for iOS 13.
* A reversible mode where tapping the same item twice flips its direction.

# Sample Code

`TOSegmentedControl` has been written to follow the interface of `UISegmentedControl` as closely as possible. This should make it very intuitive to work with.

## Swift

In Swift, the class is renamed to `SegmentedControl`. Creating a new instance is very similar to `UISegmentedControl`.

```Swift

// Create a new instance
let segmentedControl = SegmentedControl(items: )

// Add a closure that will be called each time the selected segment changes
segmentedControlsegmentTappedHandler = { segmentIndex, reversed in
   print("Segment \(segmentIndex) was tapped!")
}

// Add a new item to the end
segmentedControl.addSegment(withTitle: "Fourth")

// Insert a new item at the beginning
segmentedControl.insertSegment(withTitle: "Zero", at: 0)

// Remove all segments
segmentedControl.removeAllSegments()

```

## Objective-C

```objc

NSArray *items = @[@"First", @"Second", @"Third"];

// Create a new instance
TOSegmentedControl *segmentedControl = [[TOSegmentedControl alloc] initWithItems:items]];

// Add a block that will be called each time the selected segment changes
segmentedControl.segmentTappedHandler = ^(NSInteger index, BOOL reversed) {
    NSLog(@"Segment %d was tapped!", index);
};

// Add a new item to the end
[segmentedControl addSegmentWithTitle:@"Fourth"];

// Insert a new item at the beginning
[segmentedControl insertSegmentWithTitle:@"Zero" atIndex:0];

// Remove all segments
[segmentedControl removeAllSegments];
```


# System Requirements
iOS 9.0 or above

# Installation

<details>
  <summary><strong>CocoaPods</strong></summary>

Add the following to your Podfile:
``` ruby
pod 'TOSegmentedControl'
```
</details>

<details>
  <summary><strong>Carthage</strong></summary>

1. Add the following to your Cartfile:
``` 
github "TimOliver/TOSegmentedControl"
```

2. Run `carthage update`

3. From the `Carthage/Build` folder, import the  `TOSegmentedControl.framework`.

4. Follow the remaining steps on [Getting Started with Carthage](https://github.com/Carthage/Carthage#getting-started) to finish integrating the framework.

</details>

<details>
<summary><strong>Manual Installation</strong></summary>

All of the necessary source files located in the `TOSegmentedControl` folder. Simply drag that folder into your Xcode project. 
</details>

# Credits

`TOSegmentedControl` was created by [Tim Oliver](http://twitter.com/TimOliverAU) as a component for [iComics](http://icomics.co).

iOS device mockup by [Pixeden](http://www.pixeden.com).

# License

`TOSegmentedControl` is available under the MIT license. Please see the [LICENSE](LICENSE) file for more information. ![analytics](https://ga-beacon.appspot.com/UA-5643664-16/TOSegmentedControl/README.md?pixel)
