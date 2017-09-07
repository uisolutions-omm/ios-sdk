# OMMWifi

[![CI Status](http://img.shields.io/travis/karthik1739/OMMWifi.svg?style=flat)](https://travis-ci.org/karthik1739/OMMWifi)
[![Version](https://img.shields.io/cocoapods/v/OMMWifi.svg?style=flat)](http://cocoapods.org/pods/OMMWifi)
[![License](https://img.shields.io/cocoapods/l/OMMWifi.svg?style=flat)](http://cocoapods.org/pods/OMMWifi)
[![Platform](https://img.shields.io/cocoapods/p/OMMWifi.svg?style=flat)](http://cocoapods.org/pods/OMMWifi)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

OMMWifi is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'OMMWifi'
```

## Initialising OMMWifi

Import the OMMWifi in your AppDelegate

```sh
#import "OMMWifiAPIController.h"
```

Add this method to didFinishLaunchingWithOptions in AppDelegate

```sh
[[OMMWifiAPIController sharedInstance] performWifiRecharge];
```

## Configuring Location Permission

To enable location permissions add these lines to info.plist of the project

```sh
<key>NSLocationWhenInUseUsageDescription</key>
<string>This application requires location services to work</string>

<key>NSLocationAlwaysUsageDescription</key>
<string>This application requires location services to work</string>
```


## Author

Krishna Chaitanya, kchaitanya@onmymobile.co

## License

OMMWifi is available under the MIT license. See the LICENSE file for more info.
